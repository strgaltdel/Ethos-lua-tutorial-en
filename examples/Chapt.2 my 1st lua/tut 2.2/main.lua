-- ***************************************
--				Ethos-lua
--        	tutorial script 2.2
-- 		 display telemetry values
-- ***************************************

-- 1.0 Nov 2024

-- sources
local srcValue1 = nil
local srcValue2 = nil

-- source-values
local value1 = nil
local value2 = nil



-- System type constants
local DISP_X20 <const> 		= 1
local DISP_X18 <const> 		= 2
local DISP_HORUS <const> 	= 3

-- actual system type
local txType = 1					-- standard = x20



-- layout, system dependent
local masterLayout = {	
	{hLine=46, offset=2, tabTxt=180,	tabValue=290},		-- x20
	{hLine=28, offset=0, tabTxt= 95,	tabValue=180},		-- x18
	{hLine=24, offset=1, tabTxt= 80,	tabValue=140},		-- horus
}

-- actual layout
local layout = {}




																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="tutorial 2.2"}

local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end



function evaluate_display()
		local detectSys = system.getVersion()																-- get system type string

		if detectSys.board == "X12" or detectSys.board == "X10EXPRESS" then 								-- evaluate return value
			return(DISP_HORUS) 			
		elseif detectSys.board == "X18S" or detectSys.board == "X18" then 
			return(DISP_X18) 
		else
			return(DISP_X20)
		end
end



																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)
	lcd.font(FONT_XXL)											-- set font size
--	lcd.font(FONT_XL)											-- X10 
	local xText = layout.tabTxt									-- x-coordinate text (both lines)

	
	--     #####   line1   #####

	local tmpColor = lcd.RGB( 170,  170,  200)					-- color definition line 1
	lcd.color(tmpColor)											-- set color
	local y=layout.offset + layout.hLine*0						-- y-coordinate line 1

	lcd.drawText(xText,y,"RSSI:",RIGHT)							-- text value 1
	value1 = srcValue1:value()									-- get value 1
	lcd.drawNumber(layout.tabValue,	y,	value1,	nil,1,RIGHT)	-- draw value 1


	--     #####   line2   #####

	tmpColor = lcd.RGB( 170,  200,  170)						-- color definition line 2
	lcd.color(tmpColor)											-- set color
	y=layout.offset + layout.hLine*1							-- y-coordinate line 2

	lcd.drawText(xText, y,"TxBat:",RIGHT)						-- text value 2
	value2 = srcValue2:value()									-- get value 2
	lcd.drawNumber(layout.tabValue,	y,	value2,	nil,1,RIGHT)	-- draw value 2	
end


																			-- ************************************************
																			-- ***		    startup (onetime) handler		*** 
																			-- ***	         returns widget vars			*** 
																			-- ************************************************
local function create()
	txType = evaluate_display()																	-- determine display
	layout = masterLayout[txType]																-- set layout

	srcValue1 = system.getSource({category=CATEGORY_TELEMETRY_SENSOR, name="RSSI"})				-- definition source 1
	srcValue2 = system.getSource({category=CATEGORY_SYSTEM, member=SYSTEM_MAIN_VOLTAGE})		-- definition source 2
	
  return{}
end


																			-- ************************************************
																			-- ***		     "background loop"				*** 
																			-- ************************************************

local function wakeup(widget)
	lcd.invalidate()
end
																			-- ************************************************
																			-- ***		     monitor events		 	   		*** 
																			-- ************************************************
local function event(widget, category, value, x, y)

end
																			-- ************************************************
																			-- ***		     init widget		 	   		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key="tut0202", name=name, create=create, wakeup=wakeup, paint = paint, event=event})
end

return {init=init}
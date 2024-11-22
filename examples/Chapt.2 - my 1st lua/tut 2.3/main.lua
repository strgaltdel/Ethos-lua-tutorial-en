-- ***************************************
--				Ethos-lua
--        	tutorial script 2.3
-- 		  display telemetry values
--			min / max option
-- ***************************************

-- 1.0 Nov 2024


local DISP_X20 <const> 		= 1
local DISP_X18 <const> 		= 2
local DISP_HORUS <const> 	= 3


local txType = 1					-- standard = x20



local masterLayout = {	
	{hLine=46, offset=2, tabTxt=180,	tabValue=290,	bmpYdelta=0,	},		-- x20
	{hLine=29, offset=0, tabTxt=117,	tabValue=182,	bmpYdelta=4,	},		-- x18
	{hLine=20, offset=1, tabTxt=100,	tabValue= 80,	bmpYdelta=0,	},		-- horus
}

local layout = {}





-- sources
local srcValue1 = nil		-- sensor
local srcValue2 = nil		-- sensor

local srcSwitch = system.getSource({category=CATEGORY_SWITCH, name="SA"})	-- switch


-- source-values
local value1 = nil
local value2 = nil



print("  >>>> load A")
bmp1 = lcd.loadBitmap("/scripts/tut 2.3/rssi.png")		
print("  >>>> load B")	
bmp2 = lcd.loadBitmap("/scripts/tut 2.3/VOLTAGE.png")



local swHandler = nil

local VALUE_MIN <const> = 1
local VALUE_MAX <const> = 2
local VALUE_LIVE <const> = 3


local COLOR_Min <const> =  lcd.RGB(150,  200,  255)					-- rgb color "min"
local COLOR_Max <const> =  lcd.RGB(255,  050,  050)					-- rgb color "max"


local tmpColor = nil

																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="tutorial 2.3"}

local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end



function evaluate_display()

		local detectSys = system.getVersion()

		if detectSys.board == "X12" or detectSys.board == "X10EXPRESS" then return(DISP_HORUS) end
		if detectSys.board == "X18S" or detectSys.board == "X18" then return(DISP_X18) end
		return(DISP_X20)
		
	end



																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)


	if swHandler == VALUE_LIVE then
		tmpColor = lcd.RGB( 170,  170,  200)
		value1 = srcValue1:value()											
		value2 = srcValue2:value()
		print("live")

	elseif swHandler == VALUE_MIN then
		value1 = srcValue1:value(OPTION_SENSOR_MIN)
		value2 = srcValue2:value(OPTION_SENSOR_MIN)

	else
		value1 = srcValue1:value(OPTION_SENSOR_MAX)
		value2 = srcValue2:value(OPTION_SENSOR_MAX)

	end
	

	
	lcd.font(FONT_XXL)										-- set font size
	lcd.color(tmpColor)										-- color value#1

	local bmpSize = layout.hLine * 0.9						-- sizing bitmap
	local xText = layout.tabTxt								-- eval text x-position


	-- line1:  *****************************************************
	local y		=layout.offset + layout.hLine*0					-- line1,		eval. text & number y-position
	local bmpY 	= y + layout.bmpYdelta							-- line1,		eval. bitmap y-position

	lcd.drawBitmap(0,bmpY,bmp1,bmpSize,bmpSize)					-- line1,		draw bitmap
	lcd.drawText(xText, y ,"RSSI:",RIGHT)						-- line1,		print Sensorname
	lcd.drawNumber(layout.tabValue,	y,	value1,	nil,1,RIGHT)	-- line1,		print value



	-- line2:  ******************************************************
	if swHandler == VALUE_LIVE then								-- line2,		change color in realtime mode
		tmpColor = lcd.RGB( 170,  200,  170)
		lcd.color(tmpColor)
	end

	y = layout.offset + layout.hLine*1							-- line2,		eval. text & number y-position
	bmpY = y + layout.bmpYdelta									-- line2,		eval. bitmap y-position

	lcd.drawBitmap(0, bmpY,bmp2,bmpSize,bmpSize)				-- line2,		draw bitmap
	lcd.drawText(xText, y,"TxBat:",RIGHT)						-- line2,		print Sensorname
	lcd.drawNumber(layout.tabValue,	y,	value2,	nil,1,RIGHT)	-- line2,		print value

	
end


																			-- ************************************************
																			-- ***		    startup (onetime) handler		*** 
																			-- ***	         returns widget vars			*** 
																			-- ************************************************
local function create()
	txType = evaluate_display()
	layout = masterLayout[txType]

	srcValue1 = system.getSource({category=CATEGORY_TELEMETRY_SENSOR, name="RSSI"})
	srcValue2 = system.getSource({category=CATEGORY_SYSTEM, member=SYSTEM_MAIN_VOLTAGE})

  return{}
end


																			-- ************************************************
																			-- ***		     configure widget				*** 
																			-- ************************************************
local function configure(widget)
	
end

																			-- ************************************************
																			-- ***		     "background loop"				*** 
																			-- ************************************************

local function wakeup(widget)

	local stateValue = srcSwitch:value()

	if stateValue == 0 then 
		swHandler = VALUE_LIVE
	
	elseif stateValue > 0 then 
		swHandler = VALUE_MIN
		tmpColor = COLOR_Min
	else
		swHandler = VALUE_MAX
		tmpColor = COLOR_Max
	end

	lcd.invalidate()

	
end
																			-- ************************************************
																			-- ***		     monitor events		 	   		*** 
																			-- ************************************************
local function event(widget, category, value, x, y)
	if debug3 then print("Event received:", category, value, x, y) end	
	if category == EVT_KEY and value == KEY_EXIT_BREAK then
				print("BREAK")
	end
	return false
end
																			-- ************************************************
																			-- ***		     init widget		 	   		*** 
																			-- ************************************************
local function init()
 system.registerWidget({key="tutB03", name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event})
end

return {init=init}
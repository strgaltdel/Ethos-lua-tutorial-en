-- ***************************************
--				Ethos-lua
--        	tutorial script 2.1
-- 			display simple text
-- ***************************************

-- 1.0 Nov 2024


																			-- ************************************************
																			-- ***		     name widget					*** 
																			-- ************************************************
local translations = {en="tutorial 2.1", de="tutorial 2.1"}

local function name(widget)					-- name script
  local locale = system.getLocale()
	 return translations[locale] or translations["en"]
end



																			-- ************************************************
																			-- ***		     "display handler"					*** 
																			-- ************************************************
local function paint(widget)
	local offset 	= 2
	
--	local line 		= 46		-- x20
	local line 		= 27		-- x18
--	local line 		= 24		-- x10


	lcd.font(FONT_XXL)
--	lcd.font(FONT_XL)			-- X10


	lcd.color(COLOR_RED)
	lcd.drawText(50,offset +line*0,"hello 1",TEXT_LEFT)


	lcd.color(COLOR_GREEN)
	lcd.drawText(50,offset +line*1,"hello 2",TEXT_LEFT)
	
end


																			-- ************************************************
																			-- ***		    startup (onetime) handler		*** 
																			-- ***	         returns widget vars			*** 
																			-- ************************************************
local function create()

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
 system.registerWidget({key="tut0201", name=name, create=create, wakeup=wakeup, paint = paint, configure=configure, event=event})
end

return {init=init}
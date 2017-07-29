--[[
    
***************************************************************
Creeps in the Deeps
v Internal

Created by: chromiumboy
Date: 08/09/15

Description: 
--
	
Overwritten files:
Files tweaked by postinits:

Changelog:
v1.0:
- Initial release

***************************************************************

]]

-- Global variables
GLOBAL.UW_GLOBALS = {
	MODNAME = modname
}

-- Mod import function
modimport "libraries/use.lua"

-- Mod assets
use "modassets"
-- Mod prefabs
use "modprefabs"

-- Mod TUNING variables
use "uw_tuning"

-- Mod custom strings and speeches
use "modstrings"
use "speeches//mod_speech_wilson"
use "speeches//mod_speech_willow"
use "speeches//mod_speech_wolfgang"
use "speeches//mod_speech_wickerbottom"
use "speeches//mod_speech_wx78"
use "speeches//mod_speech_wendy"
use "speeches//mod_speech_woodie"
use "speeches//mod_speech_maxwell"

if GLOBAL.IsDLCInstalled(GLOBAL.REIGN_OF_GIANTS) and GLOBAL.STRINGS.CHARACTERS.WEBBER and GLOBAL.STRINGS.CHARACTERS.WATHGRITHR then
	use "speeches//mod_speech_webber"
	use "speeches//mod_speech_wathgrithr"
end

--RemapSoundEvent("dontstarve/music/music_FE", "dontstarve/music/gramaphone_drstyle") --Again, it's just a placeholder until we have a proper theme

-- Mod recipes
use "modrecipes"

-- Mod actions
use "modactions"

-- Mod stategraphs
use "modstategraphs"

-- Mod cooking recipes and ingredients
use "scripts//citdcooking"

-- Post initialization functions
use "modpostinits"

-- Debug tool
if GLOBAL.UW_TUNING.DEBUG_MODE then

	function GLOBAL.c_dev()
		GLOBAL.c_give("devtool")
	end

end
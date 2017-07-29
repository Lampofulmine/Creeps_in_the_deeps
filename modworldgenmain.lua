print("Mod world generation")
local require = GLOBAL.require
modimport "libraries/use.lua"
local GROUND = GLOBAL.GROUND


-- IDs
local UNDERWATER_SANDY_ID = 101
local UNDERWATER_ROCKY_ID = 102


-- Add new tiles
use 'libraries.tile_adder'

--AddTile("TILE_NAME", TILE_ID, "tile_name", {noise_texture = "levels/texture/tile_name.tex", 	runsound = "dontstarve/movement/run_dirt", 		walksound = "dontstarve/movement/walk_dirt", 	snowsound = "dontstarve/movement/run_snow" }, {name = "tile_name", noise_texture = "levels/textures/mini_tile_name_noise.tex"})
AddTile("UNDERWATER_SANDY", UNDERWATER_SANDY_ID, "cave", {noise_texture = "levels/textures/underwater_sandy.tex", 	runsound = "dontstarve/movement/run_dirt", 		walksound = "dontstarve/movement/walk_dirt", 	snowsound = "dontstarve/movement/run_snow" }, {name = "cave", noise_texture = "levels/textures/underwater_sandy.tex"})
AddTile("UNDERWATER_ROCKY", UNDERWATER_ROCKY_ID, "marsh", {noise_texture = "levels/textures/underwater_rocky.tex", 	runsound = "dontstarve/movement/run_dirt", 		walksound = "dontstarve/movement/walk_dirt", 	snowsound = "dontstarve/movement/run_snow" }, {name = "marsh", noise_texture = "levels/textures/underwater_rocky.tex"})


-- Make tiles undiggable
--local Terraforming = use "libraries.terraforming"
--Terraforming.MakeTileUndiggable(GROUND.UNDERWATER_SANDY)
--Terraforming.MakeTileUndiggable(GROUND.UNDERWATER_ROCKY)


-- Load tasks, rooms, keys and locks, and levels
use "scripts//map//tasks//underwater_tasks"
use "scripts//map//rooms//underwater_rooms"
use "scripts//map//levels//underwater_levels"


-- Layouts
local StaticLayout = require("map/static_layout")
local Layouts = require("map/layouts").Layouts
Layouts["UnderwaterStart"] = StaticLayout.Get("map/static_layouts/layout_test")


-- Tiled IDs for custom textures
local old_table_get = StaticLayout.Get
StaticLayout.Get = function(...)
	local old_layout_table = old_table_get(...)
	
	old_layout_table.ground_types[UNDERWATER_SANDY_ID] = GROUND.UNDERWATER_SANDY
	old_layout_table.ground_types[UNDERWATER_ROCKY_ID] = GROUND.UNDERWATER_ROCKY
	
	return old_layout_table
end


-- Translate to prefabs 
local TRANSLATE_TO_PREFABS = require("map/forest_map").TRANSLATE_TO_PREFABS
TRANSLATE_TO_PREFABS["crabhole"] = "crabhole"
TRANSLATE_TO_PREFABS["mermnoblehouse"] = "mermnoblehouse"
TRANSLATE_TO_PREFABS["mermworkerhouse"] = "mermworkerhouse"
TRANSLATE_TO_PREFABS["mermguardhouse"] = "mermwguardhouse"
TRANSLATE_TO_PREFABS["bubble_vent"] = "bubble_vent"


-- World room preinits
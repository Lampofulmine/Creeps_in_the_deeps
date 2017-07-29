local require = GLOBAL.require
require("map/level")
local levels = require("map/levels")

local LEVELTYPE = GLOBAL.LEVELTYPE

--- add entrance to above world
for _, level in pairs(levels.sandbox_levels) do 
table.insert(level.tasks, "EntranceToReef")
end
---

----------------------------------
-- Underwater levels
----------------------------------


AddLevel(LEVELTYPE.CAVE, {
		id = "UNDERWATER_LEVEL_1",
		name = "UNDERWATER_LEVEL_1",
		overrides = {
			{"world_size", 		"tiny"},
			-- {"day", 			"onlynight"}, 
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"UnderwaterStart"},
			{"start_node",		"bg_SandyBottom"},
		},
		tasks = {
			"UnderwaterStart",
			"SandyBiome",
			"ReefBiome",
			"KelpBiome",
			"RockyBiome",
			"OpenWaterBiome",
		},
		numoptionaltasks = math.random(2,3),
		optionaltasks = {
			"SandyBiome",
			"ReefBiome",
			"KelpBiome",
			"RockyBiome",
			"OpenWaterBiome",
		},
	})

AddLevel(LEVELTYPE.CAVE, {
		id = "UNDERWATER_LEVEL_2",
		name = "UNDERWATER_LEVEL_2",
		overrides = {
			{"world_size", 		"tiny"},
			{"day", 			"onlynight"}, 
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"RuinsStart"},
			{"start_node",		"BGWilds"},
		},
		tasks = {
			"RuinsStart",
			"TheLabyrinth",
			"Residential",
			"Military",
			"Sacred",
		},
		numoptionaltasks = math.random(1,2),
		optionaltasks = {
			"MoreAltars",
			"SacredDanger",
			"FailedCamp",
			"Residential2",
			"Residential3",
			"Military2",
			"Sacred2",
		},

	})

print("Loaded underwater levels")
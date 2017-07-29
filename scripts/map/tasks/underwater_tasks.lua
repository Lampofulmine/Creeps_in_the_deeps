local require = GLOBAL.require
require("map/tasks")

KEYS = GLOBAL.KEYS
LOCKS = GLOBAL.LOCKS
GROUND = GLOBAL.GROUND

AddTask("UnderwaterStart", {
	locks = LOCKS.NONE,
	keys_given = KEYS.LIGHT,
	
	room_choices = {
		["SandyBottom"] = math.random(2),
		["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
	},
	room_bg = GROUND.UNDERWATER_SANDY,
	background_room = "bg_SandyBottom",
	colour={r=0,g=0,b=0,a=0},
})

AddTask("SandyBiome", {
	locks = LOCKS.LIGHT,
	keys_given = KEYS.CAVE,
	
	room_choices = {
		["SandyBottom"] = math.random(2),
		["SandyBottomTreasureTrove"] = (math.random() > 0.5 and 1) or 0,
		["SandyBottomCoralPatch"] = 1,
	},
	room_bg = GROUND.UNDERWATER_SANDY,
	background_room = "bg_SandyBottom",
	colour={r=0,g=0,b=0,a=0},
})

AddTask("ReefBiome", {
	locks = LOCKS.LIGHT,
	keys_given = KEYS.CAVE,
	
	room_choices = {
		["CoralReef"] = math.random(2),
		["CoralReefLight"] = (math.random() > 0.5 and 1) or 0,
		["CoralReefJunked"] = 1,
	},
	room_bg = GROUND.UNDERWATER_SANDY,
	background_room = "bg_CoralReef",
	colour={r=0,g=0,b=0,a=0},
})

AddTask("KelpBiome", {
	locks = LOCKS.CAVE,
	keys_given = KEYS.NONE,
	
	room_choices = {
		["KelpForest"] = math.random(2),
		["KelpForestInfested"] = (math.random() > 0.5 and 1) or 0,
		["KelpForestLight"] = 1,
	},
	room_bg = GROUND.UNDERWATER_SANDY,
	background_room = "bg_KelpForest",
	colour={r=0,g=0,b=0,a=0},
})
	
AddTask("RockyBiome", {
	locks = LOCKS.CAVE,
	keys_given = KEYS.NONE,
	
	room_choices = {
		["RockyBottom"] = math.random(2),
		["RockyBottomBroken"] = 1,
	},
	room_bg = GROUND.UNDERWATER_ROCKY,
	background_room = "bg_RockyBottom",
	colour={r=0,g=0,b=0,a=0},
})

AddTask("OpenWaterBiome", {
	locks = LOCKS.LIGHT,
	keys_given = KEYS.CAVE,
	
	entrance_room = "TidalZoneEntrance",
	room_choices = {
		["TidalZone"] = math.random(2),
	},
	room_bg = GROUND.UNDERWATER_SANDY,
	background_room = "bg_TidalZone",
	colour={r=0,g=0,b=0,a=0},
})

-- Add the underwater entrance

AddTask("EntranceToReef", {
	locks = LOCKS.CAVE,
	keys_given = KEYS.NONE,
	
	room_choices = {
		["UnderwaterEntrance"] = 1,
	},
	room_bg = GROUND.FOREST,
	background_room = "BGGrass",
	colour={r=0,g=0,b=0,a=0},
})
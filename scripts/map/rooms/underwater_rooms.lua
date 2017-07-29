local require = GLOBAL.require
require("map/rooms")

local GROUND = GLOBAL.GROUND
local NODE_INTERNAL_CONNECTION_TYPE = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE
local RUNCA = GLOBAL.RUNCA
local CA_SEED_MODE = GLOBAL.CA_SEED_MODE

------------------------------------------------------------------------------------------
-- Sandy rooms
------------------------------------------------------------------------------------------	

AddRoom("SandyBottom", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			seagrass = 0.35,
			sandstone_boulder = 0.01,
			bubble_vent = 0.03,
			kelp = 0.2,
			squid = 0.001,
			flower_sea = 0.1,
			decorative_shell = 0.05,
			wormplant = 0.1,
			sea_eel = 0.01,
			clam = 0.06,
			sponge = 0.25,
			sea_cucumber = 0.1,
			commonfish = 0.1,
			shrimp = 0.2,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
			uw_flowers = 0.1,
		},
		--[[prefabdata = {
			crab = function() 
				if math.random() < 0.1 then
					return { growable={stage=4}}
				elseif  math.random() < 0.3 then
					return { growable={stage=3}}
				else
					return { growable={stage=2}}
				end
			end,
		},]]--		
	},
})

AddRoom("SandyBottomTreasureTrove", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2) - 1) end,
			sunken_chest = 1,
		},
		
		distributepercent = 0.3,
		distributeprefabs = {
			seagrass = 0.35,
			sandstone_boulder = 0.01,
			uw_coral = 0.4,
			uw_coral_blue = 0.3,
			uw_coral_green = 0.3,
			seatentacle = 0.01,
			rotting_trunk = 0.2,
			bubble_vent = 0.03,
			kelp = 0.5,
			squid = 0.001,
			flower_sea = 0.1,
			decorative_shell = 0.05,
			wormplant = 0.1,
			sea_eel = 0.2,
			clam = 0.06,
			sponge = 0.25,
			sea_cucumber = 0.1,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
			uw_flowers = 0.1,
		},
	},
})

AddRoom("SandyBottomCoralPatch", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2) - 1) end,
		},
		
		distributepercent = 0.3,
		distributeprefabs = {
			seagrass = 0.01,
			sandstone_boulder = 0.1,
			uw_coral = 0.25,
			uw_coral_blue = 0.25,
			uw_coral_green = 0.25,
			reef_jellyfish = 0.1,
			bubble_vent = 0.03,
			kelp = 0.2,
			squid = 0.001,
			flower_sea = 0.1,
			decorative_shell = 0.2,
			wormplant = 0.1,
			clam = 0.06,
			sponge = 0.25,
			sea_cucumber = 0.3,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
			uw_flowers = 0.1,
		},
		--[[prefabdata = {
			crab = function() 
				if math.random() < 0.1 then
					return { growable={stage=4}}
				elseif  math.random() < 0.3 then
					return { growable={stage=3}}
				else
					return { growable={stage=2}}
				end
			end,
		},]]--
	},
})

------------------------------------------------------------------------------------------
-- Reef rooms
------------------------------------------------------------------------------------------	

AddRoom("CoralReef", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2) - 1) end,
		},
		
		distributepercent = 0.6,
		distributeprefabs = {
			sandstone_boulder = 0.01,
			uw_coral = 1.5,
			uw_coral_blue = 1.5,
			uw_coral_green = 1,	
			reef_jellyfish = 0.4,
			seatentacle = 0.5,
			bubble_vent = 0.03,
			squid = 0.001,
			decorative_shell = 0.2,
			sea_eel = 0.2,
			sponge = 0.15,
			commonfish = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("CoralReefJunked", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2) - 1) end,
		},
		
		distributepercent = 0.3,
		distributeprefabs = {
			sandstone_boulder = 0.01,
			uw_coral = 1.3,
			uw_coral_blue = 1.3,
			uw_coral_green = 1.3,	
			reef_jellyfish = 0.4,
			seatentacle = 0.5,
			bubble_vent = 0.03,
			squid = 0.01,
			cut_orange_coral = 1,
			decorative_shell = 0.05,
			sea_eel = 0.2,
			sponge = 0.15,
			commonfish = 0.2,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("CoralReefLight", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2) - 1) end,
		},
		
		distributepercent = 0.3,
		distributeprefabs = {
			sandstone_boulder = 0.05,
			uw_coral = 1,
			uw_coral_blue = 1,
			uw_coral_green = 1,
			iron_boulder = 0.01,
			bubble_vent = 0.03,		
			rotting_trunk = 0.1,
			reef_jellyfish = 0.4,
			squid = 0.01,
			decorative_shell = 0.1,
			wormplant = 0.1,
			sponge = 0.15,
			commonfish = 0.2,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

------------------------------------------------------------------------------------------
-- Kelp rooms
------------------------------------------------------------------------------------------

AddRoom("KelpForest", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {	
		distributepercent = 0.6,
		distributeprefabs = {
			kelp = 2.5,
			rotting_trunk = 0.01,
			seagrass = 0.005,
			sandstone_boulder = 0.0008,	
			squid = 0.001,
			flower_sea = 0.1,
			sea_eel = 0.001,
			bubble_vent = 0.03,
			commonfish = 0.2,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("KelpForestLight", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {	
		distributepercent = 0.6,
		distributeprefabs = {
			kelp = 0.5,
			rotting_trunk = 0.05,
			seagrass = 0.005,
			sandstone_boulder = 0.0008,
			mermworkerhouse = 0.02,
			squid = 0.0001,
			seatentacle = 0.0001,
			flower_sea = 0.1,
			sea_eel = 0.002,
			bubble_vent = 0.03,
			commonfish = 0.05,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("KelpForestInfested", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {	
		distributepercent = 0.6,
		distributeprefabs = {
			kelp = 2.5,
			rotting_trunk = 0.01,
			seagrass = 0.005,
			sandstone_boulder = 0.008,
			reef_jellyfish = 0.2,
			squid = 0.005,
			flower_sea = 0.1,
			sea_eel = 0.001,
			bubble_vent = 0.03,
			commonfish = 0.15,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})


------------------------------------------------------------------------------------------
-- Rocky rooms
------------------------------------------------------------------------------------------	

AddRoom("RockyBottom", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_ROCKY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2)) end,
		},
		
		distributepercent = 0.225,
		distributeprefabs = {
			rock1 = 0.1,
			rock2 = 0.05,
			iron_boulder = 0.03,
			squid = 0.002,
			lava_stone = 0.005,
			sponge = 0.001,
			bubble_vent = 0.01,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("RockyBottomBroken", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_ROCKY,
	contents = {
		countprefabs={
			geothermal_vent = function () return (math.random(2)) end,
		},
		
		distributepercent = 0.15,
		distributeprefabs = {
			rocks = 0.1,
			rock1 = 0.1,
			rock2 = 0.05,
			iron_ore = 0.03,
			iron_boulder = 0.01,
			squid = 0.002,
			lava_stone = 0.005,
			sponge = 0.001,
			bubble_vent = 0.01,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})


------------------------------------------------------------------------------------------
-- Open water rooms
------------------------------------------------------------------------------------------	

AddRoom("TidalZoneEntrance", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		distributepercent = 0.7,
		distributeprefabs = {
			seagrass = 0.05,
			sandstone = 0.35,
			uw_coral = 0.01,
			uw_coral_blue = 0.01,
			uw_coral_green = 0.01,
			cut_orange_coral = 0.1,
			tidal_node = 5,
			sponge = 0.01,
			bubble_vent = 0.03,
			commonfish = 0.05,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("TidalZone", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	contents = {
		distributepercent = 0.7,
		distributeprefabs = {
			seagrass = 0.25,
			sandstone = 0.45,
			uw_coral = 0.04,
			uw_coral_blue = 0.04,
			uw_coral_green = 0.04,
			cut_orange_coral = 0.3,
			tidal_node = 5,
			squid = 0.008,
			sponge = 0.03,
			bubble_vent = 0.03,
			commonfish = 0.05,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

	
------------------------------------------------------------------------------------------
-- Background rooms
------------------------------------------------------------------------------------------	

AddRoom("bg_SandyBottom", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	tags = {},
	contents = {
		distributepercent = 0.25,
		distributeprefabs = {
			seagrass = 0.15,
			uw_coral = 0.02,
			uw_coral_blue = 0.03,
			uw_coral_green = 0.03,
			kelp = 0.01,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
			uw_flowers = 0.1,
		},
	},
})
	
AddRoom("bg_CoralReef", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	tags = {},
	contents = {
		distributepercent = 0.8,
		distributeprefabs = {
			sandstone_boulder = 0.01,
			uw_coral = 2,
			uw_coral_blue = 2.5,
			uw_coral_green = 2,
			reef_jellyfish = 0.3,
			kelp = 1,	
			bubble_vent = 0.1,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("bg_KelpForest", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	tags = {},
	contents = {
		distributepercent = 0.8,
		distributeprefabs = {
			kelp = 2.5,
			rotting_trunk = 0.01,
			seagrass = 0.005,
			sandstone_boulder = 0.0008,	
			flower_sea = 0.1,
			commonfish = 0.1,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("bg_RockyBottom", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_ROCKY,
	tags = {},
	contents = {
		distributepercent = 0.15,
		distributeprefabs = {
			rock1 = 0.05,
			rocks = 0.05,
			commonfish = 0.05,
			shrimp = 0.2,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})

AddRoom("bg_TidalZone", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	tags = {},
	contents = {
		distributepercent = 0.9,
		distributeprefabs = {
			seagrass = 0.25,
			sandstone = 0.45,
			uw_coral = 0.1,
			uw_coral_blue = 0.1,
			uw_coral_green = 0.1,
			cut_orange_coral = 0.3,
			tidal_node = 5,
			commonfish = 0.05,
			shrimp = 0.1,
			reeflight_small = 0.2,
			reeflight_tiny = 0.2,
		},
	},
})


------------------------------------------------------------------------------------------
-- Abyss bridges
------------------------------------------------------------------------------------------	
	
AddRoom("AbyssBridge", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.IMPASSABLE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	contents = {},
})

AddRoom("AbyssBridgeEdge", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.IMPASSABLE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeEdgeRight,
	custom_tiles={
		GeneratorFunction = RUNCA.GeneratorFunction,
		data = {iterations=2, seed_mode=CA_SEED_MODE.SEED_WALLS, num_random_points=1, 
				translate={	{tile=GROUND.IMPASSABLE, items={"stalagmite"}, 	item_count=0},
							{tile=GROUND.IMPASSABLE, items={"stalagmite"}, 	item_count=0},
							{tile=GROUND.CAVE, items={"stalagmite"}, 	item_count=0},
							{tile=GROUND.CAVE,  items={"stalagmite"},	item_count=0},
							{tile=GROUND.CAVE,  items={"stalagmite"},	item_count=0},
						},
			},
		},
	})
	
	
------------------------------------------------------------------------------------------
-- Merm villages
------------------------------------------------------------------------------------------

AddRoom("MermTown", {
	colour={r=0,g=0,b=0,a=0.9},
	value = GROUND.UNDERWATER_SANDY,
	contents =  {
		countstaticlayouts={
			--["MermTown"]=1,
		},
		distributepercent = .2,
		distributeprefabs =
		{
			mermworkerhouse = 0.5,
			mermguardhouse = 0.25,
		}
	}
})
	
AddRoom("MermCity", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.UNDERWATER_SANDY,
	tags = {"Town"},
	contents =  {
		countstaticlayouts=
		{
			--["MermCity"]=function () return 1 + math.random(2) end,
			--["MermKing"]=function () return 1 + math.random(2) end,
		},
	}
})

------------------------------------------------------------------------------------------
-- Underwater Entrance
------------------------------------------------------------------------------------------

AddRoom("UnderwaterEntrance", { 
					colour={r=1,g=0,b=0,a=0.3},
					value = GROUND.FOREST,
					contents =  {
									countprefabs = {
										underwater_entrance = 1,
									},
									distributepercent = 0.25,
					                distributeprefabs= {
					                    grass = 2,
					                    sapling = 2,
					                    green_mushroom = 3,
					                    blue_mushroom = 3,
					                    flower = 1,
					                    houndbone = 1,
					                    --reeds = 1,
					                    --evergreen_sparse = .5,
					                }
					            }
					})
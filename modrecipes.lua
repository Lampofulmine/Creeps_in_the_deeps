
-- Globals
local Recipe = GLOBAL.Recipe
--local Recipes = GLOBAL.Recipes
--local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local RECIPE_GAME_TYPE = GLOBAL.RECIPE_GAME_TYPE


local RecipeData = {
	-- Sample Recipe
	-- {"product_prefab",
		-- {Ingredient("basegame_prefab",1), Ingredient("basegame_prefab",4), Ingredient("mod_prefab",1,"images/inventoryimages/icon_name.xml")},
		-- RECIPETABS.SURVIVAL,
		-- TECH.NONE,
		-- "placer_prefab", --only for structured, use 'nil,' instead of ' "placer",' for items
		-- 4, --min spacing
		-- false, --no unlock (requires research station, e.g. ancient pseudoscience altar)
		-- 1, --num to give
		-- RECIPE_GAME_TYPE.COMMON --gametype
		-- false, --aquatic?
		-- 2, --allowed distance
	-- },
	
	-- Light Tab
	{"flare",
		{Ingredient("iron_ore",1, "images/inventoryimages/iron_ore.xml"), Ingredient("twigs",2)},
		RECIPETABS.LIGHT,
		TECH.SCIENCE_ONE,
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,
	},

	{"jelly_lantern", 
		{Ingredient("twigs", 3), Ingredient("rope", 2),Ingredient("jelly_cap", 1, "images/inventoryimages/jelly_cap.xml")}, 
		RECIPETABS.LIGHT, 
		TECH.SCIENCE_TWO,
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},

	-- Survival tab

	{"snorkel", 
		{Ingredient("tentaclespots", 2),Ingredient("silk", 2), Ingredient("mosquitosack", 4)}, 
		RECIPETABS.SURVIVAL, 
		TECH.SCIENCE_ONE,	
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},

	-- Magic tab
	{"pearl_amulet", 
		{Ingredient("pearl", 3, "images/inventoryimages/pearl.xml"),Ingredient("coral_cluster", 3, "images/inventoryimages/coral_cluster.xml")}, 
		RECIPETABS.MAGIC, 
		TECH.MAGIC_TWO,	
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},

	-- Dress tab
	{"diving_suit_summer", 
		{Ingredient("trunk_summer", 1),Ingredient("silk", 8),Ingredient("sponge_piece", 4, "images/inventoryimages/sponge_piece.xml")}, 
		RECIPETABS.DRESS, 
		TECH.SCIENCE_ONE,	
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},

	{"diving_suit_winter", 
		{Ingredient("trunk_winter", 1),Ingredient("silk", 8),Ingredient("sponge_piece", 4, "images/inventoryimages/sponge_piece.xml")},
		RECIPETABS.DRESS, 
		TECH.SCIENCE_TWO,	
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},

	{"coral_cluster", 
		{Ingredient("cut_orange_coral", 3, "images/inventoryimages/cut_orange_coral.xml"),Ingredient("cut_blue_coral", 3, "images/inventoryimages/cut_blue_coral.xml"),Ingredient("cut_green_coral", 3, "images/inventoryimages/cut_green_coral.xml")},
		RECIPETABS.REFINE, 
		TECH.SCIENCE_ONE,	
		nil,
		nil,
		false,
		1,
		RECIPE_GAME_TYPE.COMMON,
		false,
		2,	
	},
}



-- This loop is not suitable for DST yet
if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
	for k, v in pairs(RecipeData) do
		local rec = Recipe(v[1], v[2], v[3], v[4], v[9], v[5], v[6], v[7], v[8], v[10], v[11])
		rec.atlas = "images/inventoryimages/".. v[1] ..".xml"
	end
else
	for k, v in pairs(RecipeData) do
		local rec = Recipe(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
		rec.atlas = "images/inventoryimages/".. v[1] ..".xml"
	end
end

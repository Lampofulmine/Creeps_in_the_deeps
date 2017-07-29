-- Add mod ingredients
-- AddIngredientValues({names}, {tags}, cancook, candry)
AddIngredientValues({"fish_fillet"}, {fish=1, meat=0.5}, true, false)
AddIngredientValues({"sponge_piece"}, {sponge=1}, false, false)
AddIngredientValues({"seagrass_chunk"}, {sea_veggie=1, veggie=0.5}, false, false)
AddIngredientValues({"trinket_12"}, {tentacle=1, meat=0.5}, false, false)
AddIngredientValues({"petals"}, {flower=1}, false, false)
AddIngredientValues({"jelly_cap"}, {sea_jelly=1}, false, false)
AddIngredientValues({"salt"}, {salt=1}, false, false)

-- Mod recipes

-- Base cook time is 20 sec
-- PERISH_ONE_DAY = 1
-- PERISH_TWO_DAY = 2
-- PERISH_SUPERFAST = 3
-- PERISH_FAST = 6
-- PERISH_MED = 10
-- PERISH_SLOW = 15
-- PERISH_PRESERVED = 20
-- PERISH_SUPERSLOW = 40

local function restorescarytoprey(eater)
	eater:AddTag("scarytoprey")
	eater.scarytopreytask = nil
	eater.scarytopreytime = nil
end

-- Makes prey (e.g. shrimplets) not scared of Wilson for [duration] seconds
local function oneat_hunting(duration)
	duration = duration or 30
	return function(inst, eater)
		if eater:HasTag("scarytoprey") then
			eater:RemoveTag("scarytoprey")
			eater.scarytopreytask = eater:DoTaskInTime(duration, restorescarytoprey)
			eater.scarytopreytime = GetTime() + duration
		elseif eater.scarytopreytask and eater.scarytopreytime then
			eater.scarytopreytime = eater.scarytopreytime + duration
			local newdur = eater.scarytopreytime - GetTime()
			eater.scarytopreytask:Cancel()
			eater.scarytopreytask = eater:DoTaskInTime(newdur, restorescarytoprey)
		end
	end
end


-- Makes Wilson faster... yeah.
local function oneat_runspeed(duration, bonus)
	duration = duration or 30
	bonus = bonus or 1
	return function(inst, eater)
		eater.components.locomotor.walkspeed = eater.components.locomotor.walkspeed + bonus
		eater:DoTaskInTime(duration, function()
			eater.components.locomotor.walkspeed = eater.components.locomotor.walkspeed - bonus
		end)
	end
end


local foods = 
{
	
	fish_gazpacho = 
	{
		test = function(cooker, names, tags) return tags.frozen and tags.frozen >= 2 and tags.veggie and tags.veggie >= 2 and not tags.meat end,
		priority = 10,
		weight = 1,
		health = 3,
		hunger = 20,
		sanity = 5,
		perishtime = TUNING.PERISH_FAST,
		cooktime = 1,
	},
	
	sponge_cake = 
	{
		test = function(cooker, names, tags) return tags.dairy and tags.sweetener and tags.sponge and tags.sponge and not tags.meat end,
		priority = 0,
		weight = 1,
		health = 0,
		hunger = 25,
		sanity = 50,
		perishtime = TUNING.PERISH_SUPERFAST,
		cooktime = .5,
		oneaten = oneat_hunting(480),
	},
	
	fish_n_chips = 
	{
		test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.veggie and tags.veggie >= 2 end,
		priority = 10,
		weight = 1,
		health = 25,
		hunger = 42.5,
		sanity = 10,
		perishtime = TUNING.PERISH_FAST,
		cooktime = 1,
	},
	
	tuna_muffin = 
	{
		test = function(cooker, names, tags) return tags.fish and tags.fish >= 1 and tags.sponge and tags.sponge >= 1 and not tags.twigs end,
		priority = 5,
		weight = 1,
		health = 0,
		hunger = 32.5,
		sanity = 10,
		perishtime = TUNING.PERISH_MED,
		cooktime = 2,
	},

	tentacle_sushi = 
	{
		test = function(cooker, names, tags) return tags.tentacle and tags.tentacle and tags.sea_veggie and tags.fish >= 0.5 and not tags.twigs end,
		priority = 0,
		weight = 1,
		health = 35,
		hunger = 5,
		sanity = 5,
		perishtime = TUNING.PERISH_MED,
		cooktime = 2,
	},

	flower_sushi = 
	{
		test = function(cooker, names, tags) return tags.flower and tags.sea_veggie and tags.fish and tags.fish >= 1 and not tags.twigs end,
		priority = 0,
		weight = 1,
		health = 10,
		hunger = 5,
		sanity = 30,
		perishtime = TUNING.PERISH_MED,
		cooktime = 2,
	},

	fish_sushi = 
	{
		test = function(cooker, names, tags) return tags.tentacle and tags.veggie >= 1 and tags.fish and tags.fish >= 1 and not tags.twigs end,
		priority = 0,
		weight = 1,
		health = 5,
		hunger = 50,
		sanity = 0,
		perishtime = TUNING.PERISH_MED,
		cooktime = 2,
	},

	seajelly = 
	{
		test = function(cooker, names, tags) return tags.sea_jelly and tags.sea_jelly > 1 and tags.salt and tags.salt > 1 and not tags.meat end,
		priority = 0,
		weight = 1,
		health = 20,
		hunger = 40,
		sanity = 3,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 2,
		oneaten = oneat_runspeed(120, 2),
	},
}

-- Add mod recipes to cooker
for k, recipe in pairs(foods) do
	recipe.name = k
	recipe.weight = recipe.weight or 1
	recipe.priority = recipe.priority or 0
	
	AddCookerRecipe("cookpot", recipe)
	--AddCookerRecipe("steamer", recipe)
end

return foods
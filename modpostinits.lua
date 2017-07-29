-- folder is called "postinits_citd" to stay unique, since all "scripts" contents can get overridden by other mods

local prefabpostinitfiles = {
	"world",
	"trinket_12",
}

local componentpostinitfiles = {
	"builder",
	"burnable",
	"clock",
	"dynamicmusic",
	"health",
	"locomotor",
	"lootdropper",
	"moisture",
	"playeractionpicker",
	"seasonmanager",
}

local classpostinitfiles = {
	"bloodover",
	"loadgamescreen",
	"mainscreen",
	"slotdetailsscreen",
	"worldgenscreen",
}

--special case for the game
local game_postfn = GLOBAL.require("postinits_citd/game")
if game_postfn then
	AddGamePostInit(game_postfn)
end

--special case for TheSim
local sim_postfn = GLOBAL.require("postinits_citd/sim")
if sim_postfn then
	AddSimPostInit(sim_postfn)
end

--special case for the player
local player_postfn = GLOBAL.require("postinits_citd/player")
if player_postfn then
	for k, name in ipairs(CHARACTERLIST) do
		AddPrefabPostInit(name, player_postfn)
	end
end

--any prefab in the game
local any_postfn = GLOBAL.require("postinits_citd/any")
if any_postfn then
	AddPrefabPostInitAny(any_postfn)
end

--other prefabs
for _, name in ipairs(prefabpostinitfiles) do 
	local file_postfns = GLOBAL.require("postinits_citd/prefabs/"..name)
	for prefab, fn in pairs(file_postfns) do
		if prefab and fn then
			AddPrefabPostInit(prefab, fn)
		end
	end
end

--components
for k, component in ipairs(componentpostinitfiles) do
	local fn = GLOBAL.require("postinits_citd/components/"..component)
	if fn then
		AddComponentPostInit(component, fn)
	end
end

--classes
for k, class in ipairs(classpostinitfiles) do
	local data = GLOBAL.require("postinits_citd/classes/"..class)
	if data.fullname and data.fn then
		AddClassPostConstruct(data.fullname, data.fn)
	end
end
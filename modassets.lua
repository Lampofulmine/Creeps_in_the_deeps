Assets = {

	-- Anim
	Asset( "ANIM", "anim/corner_dude.zip"),
	Asset( "ANIM", "anim/wx78.zip"),
	Asset( "ANIM", "anim/oxygen_meter_player.zip"),
	Asset( "ANIM", "anim/hunger_ghost.zip"),
	Asset( "ANIM", "anim/squid.zip"),
	Asset( "ANIM", "anim/jellyfish.zip"),
	Asset( "ANIM", "anim/sandstone_boulder.zip"),
	Asset( "ANIM", "anim/vent.zip"),
	Asset( "ANIM", "anim/fish_fillet.zip"),
	Asset( "ANIM", "anim/commonfish.zip"),
	Asset( "ANIM", "anim/sand.zip"),
	Asset( "ANIM", "anim/pearl.zip"),
	Asset( "ANIM", "anim/iron_ore.zip"),
	Asset( "ANIM", "anim/lavastone.zip"),
	Asset( "ANIM", "anim/clam.zip"),
	Asset( "ANIM", "anim/sea_eel.zip"),
	Asset( "ANIM", "anim/sunken_chest.zip"),
	Asset( "ANIM", "anim/kelp.zip"),
	Asset( "ANIM", "anim/wormplant.zip"),
	Asset( "ANIM", "anim/decorative_shell.zip"),
	Asset( "ANIM", "anim/coral_orange.zip"),
	Asset( "ANIM", "anim/sponge.zip"),
	Asset( "ANIM", "anim/fish_n_chips.zip"),
	Asset( "ANIM", "anim/fish_gazpacho.zip"),
	Asset( "ANIM", "anim/sponge_cake.zip"),
	Asset( "ANIM", "anim/tuna_muffin.zip"),
	Asset( "ANIM", "anim/sea_cucumber.zip"),
	Asset( "ANIM", "anim/jelly_cap.zip"),
	Asset( "ANIM", "anim/salt.zip"),
	Asset( "ANIM", "anim/shrimp.zip"),
	Asset( "ANIM", "anim/diving_suit_summer.zip"),
	Asset( "ANIM", "anim/diving_suit_winter.zip"),
	Asset( "ANIM", "anim/tentacle_sushi.zip"),
	Asset( "ANIM", "anim/flower_sushi.zip"),
	Asset( "ANIM", "anim/fish_sushi.zip"),
	Asset( "ANIM", "anim/shrimp_tail.zip"),
	Asset( "ANIM", "anim/jelly_lantern.zip"),
	Asset( "ANIM", "anim/seagrass_chunk.zip"),
	Asset( "ANIM", "anim/underwater_entrance.zip"),
	Asset( "ANIM", "anim/underwater_exit.zip"),
	Asset( "ANIM", "anim/generating_reefs.zip"),
	Asset( "ANIM", "anim/coral_orange_ground.zip"),
	Asset( "ANIM", "anim/coral_blue_ground.zip"),
	Asset( "ANIM", "anim/coral_green_ground.zip"),
	Asset( "ANIM", "anim/snorkel.zip"),
	Asset( "ANIM", "anim/seajelly.zip"),
	Asset( "ANIM", "anim/coral_cluster.zip"),
	Asset( "ANIM", "anim/uw_flowers.zip"),
	Asset( "ANIM", "anim/sea_petals.zip"),
	---
	
	-- Inventory images
	-- Handled below
	
	-- Screens
	Asset( "ATLAS", "images/screens/main_menu.xml" ),

	-- Minimap Icons
	Asset("IMAGE", "images/minimap/iron_boulder.tex"),
	Asset("ATLAS", "images/minimap/iron_boulder.xml"),
	Asset("IMAGE", "images/minimap/seagrass.tex"),
	Asset("ATLAS", "images/minimap/seagrass.xml"),
	Asset("IMAGE", "images/minimap/kelp.tex"),
	Asset("ATLAS", "images/minimap/kelp.xml"),
	Asset("IMAGE", "images/minimap/vent.tex"),
	Asset("ATLAS", "images/minimap/vent.xml"),
	Asset("IMAGE", "images/minimap/entrance_open.tex"),
	Asset("ATLAS", "images/minimap/entrance_open.xml"),
	Asset("IMAGE", "images/minimap/entrance_closed.tex"),
	Asset("ATLAS", "images/minimap/entrance_closed.xml"),
	Asset("IMAGE", "images/minimap/orange_coral.tex"),
	Asset("ATLAS", "images/minimap/orange_coral.xml"),
	Asset("IMAGE", "images/minimap/clam.tex"),
	Asset("ATLAS", "images/minimap/clam.xml"),
	Asset("IMAGE", "images/minimap/sponge.tex"),
	Asset("ATLAS", "images/minimap/sponge.xml"),
	Asset("IMAGE", "images/minimap/wormplant.tex"),
	Asset("ATLAS", "images/minimap/wormplant.xml"),
	
	-- Ground tiles
	Asset( "IMAGE", "levels/textures/underwater_sandy.tex" ),
	Asset( "ATLAS", "levels/textures/underwater_sandy.xml" ),
	Asset( "IMAGE", "levels/textures/underwater_rocky.tex" ),
	Asset( "ATLAS", "levels/textures/underwater_rocky.xml" ),

	-- Sounds
	Asset("SOUNDPACKAGE", "sound/citd.fev"),
	Asset("SOUND", "sound/citd.fsb"),
}

-- Inventory image assets
local inventory_images = {
	"images/inventoryimages/placeholder",
	"images/inventoryimages/diving_suit_summer",
	"images/inventoryimages/diving_suit_winter",
	"images/inventoryimages/snorkel",
	"images/inventoryimages/sponge_piece",
	"images/inventoryimages/fish_fillet",
	"images/inventoryimages/fish_fillet_cooked",
	"images/inventoryimages/bubble_item",
	"images/inventoryimages/sand",
	"images/inventoryimages/pearl",
	"images/inventoryimages/iron_ore",
	"images/inventoryimages/lavastone",	
	"images/inventoryimages/food/fish_n_chips",
	"images/inventoryimages/food/sponge_cake",
	"images/inventoryimages/food/fish_gazpacho",
	"images/inventoryimages/food/tuna_muffin",
	"images/inventoryimages/sea_cucumber",
	"images/inventoryimages/jelly_cap",
	"images/inventoryimages/salt",
	"images/inventoryimages/food/tentacle_sushi",
	"images/inventoryimages/food/fish_sushi",
	"images/inventoryimages/food/flower_sushi",
	"images/inventoryimages/shrimp_tail",
	"images/inventoryimages/jelly_lantern",
	"images/inventoryimages/seagrass_chunk",
	"images/inventoryimages/cut_orange_coral",
	"images/inventoryimages/cut_blue_coral",
	"images/inventoryimages/cut_green_coral",
	"images/inventoryimages/food/seajelly",
	"images/inventoryimages/coral_cluster",
	"images/inventoryimages/pearl_amulet",
	"images/inventoryimages/flare",
	"images/inventoryimages/sea_petals",

}

-- Add the inventory images
for k,v in pairs(inventory_images) do
	table.insert(Assets, Asset( "ATLAS", v..".xml"))
	table.insert(Assets, Asset( "IMAGE", v..".tex"))
end

-- Add minimap atlas
AddMinimapAtlas("images/minimap/iron_boulder.xml")
AddMinimapAtlas("images/minimap/seagrass.xml")
AddMinimapAtlas("images/minimap/kelp.xml")
AddMinimapAtlas("images/minimap/vent.xml")
AddMinimapAtlas("images/minimap/entrance_open.xml")
AddMinimapAtlas("images/minimap/entrance_closed.xml")
AddMinimapAtlas("images/minimap/orange_coral.xml")
AddMinimapAtlas("images/minimap/clam.xml")
AddMinimapAtlas("images/minimap/sponge.xml")
AddMinimapAtlas("images/minimap/wormplant.xml")
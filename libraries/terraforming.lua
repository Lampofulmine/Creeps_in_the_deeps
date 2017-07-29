-- This library was created by Simplex
-- Modifies the terraformer component so tiles can be make undiggable

-- Syntax: 'local Terraforming = use "libraries.terraforming"
-- Terraforming.MakeTileUndiggable(GROUND.TILE_NAME)'


local undiggable_tiles = {
	[GLOBAL.GROUND.IMPASSABLE] = true,
	[GLOBAL.GROUND.DIRT] = true,
}


function IsDiggableTile(tile)
	return tile and not undiggable_tiles[tile] and tile < GLOBAL.GROUND.UNDERGROUND
end
local IsDiggableTile = IsDiggableTile

function IsDiggablePoint(x, y, z)
	local pt = Game.ToPoint(x, y, z)
	local world = GLOBAL.GetWorld()
	if world then
		return IsDiggableTile(world.Map:GetTileAtPoint(pt:Get()))
	end
end
local IsDiggablePoint = IsDiggablePoint


function MakeTileUndiggable(tile)
	assert( Pred.IsNumber(tile), "Number expected as tile parameter." )
	undiggable_tiles[tile] = true
end
local MakeTileUndiggable = MakeTileUndiggable


do
	local Terraformer = GLOBAL.require "components/terraformer"

	Terraformer.CanTerraformPoint = (function()
		local CanTerraformPoint = Terraformer.CanTerraformPoint

		return function(self, pt, ...)
			return CanTerraformPoint(self, pt, ...) and IsDiggablePoint(pt)
		end
	end)()
end

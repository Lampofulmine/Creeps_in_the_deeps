-- Can't build non-underwater items under water
local function fn(inst)
	inst.CanBuildAtPoint_pre = inst.CanBuildAtPoint
	
	inst.CanBuildAtPoint = function(self, pt, recipe)
		if GetWorld():IsUnderwater() and recipe.placer and not recipe.underwater then
			return false
		end

		return self:CanBuildAtPoint_pre(pt, recipe)
	end
end

return fn
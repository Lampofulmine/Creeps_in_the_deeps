-- World is underwater
local function worldfn(inst)
	inst.IsUnderwater = function() return inst:HasTag("underwater") end
end

return {world = worldfn}
-- New components for prefabs
function fn(inst)
	
	-- Blow bubble underwater
	if inst:HasTag("character") and not inst:HasTag("robot") then
		inst:AddComponent("bubbleblower")
	end
	
	-- Add bubbles on destruction
	if inst.components and (inst.components.workable or inst.components.health) then
		inst:AddComponent("deathbubbles")
	end
end

return fn
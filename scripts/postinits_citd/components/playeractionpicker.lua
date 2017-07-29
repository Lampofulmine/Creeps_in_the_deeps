-- Player action picker post init
local function fn(inst)
	inst.DoGetMouseActions_pre = inst.DoGetMouseActions
	inst.DoGetMouseActions = function(self, force_target)
		local left_action, right_action = self:DoGetMouseActions_pre(force_target)

		if not left_action and not right_action and self.inst and self.inst.sg then

			local ground = GetWorld()
			local pt = TheInput:GetWorldPosition()
			
			if ground and pt and self.inst.components.thirst and not self.inst.sg:HasStateTag("busy") then
				local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
				if tile == GROUND.WATER_RIVER then
					right_action = BufferedAction(self.inst, nil, ACTIONS.DRINK_HANDFUL, nil, pt)
				end
			end
		end
		
		return left_action, right_action
	end
end

return fn
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local OxygenBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "oxygen_meter_player", owner)
	
	self.oxygenarrow = self.underNumber:AddChild(UIAnim())
	self.oxygenarrow:GetAnimState():SetBank("sanity_arrow")
	self.oxygenarrow:GetAnimState():SetBuild("sanity_arrow")
	self.oxygenarrow:GetAnimState():PlayAnimation("neutral")
	self.oxygenarrow:SetClickable(false)

	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("effigy_topper")
	self.topperanim:GetAnimState():SetBuild("effigy_topper")
	self.topperanim:GetAnimState():PlayAnimation("anim")
	self.topperanim:SetClickable(false)
	
	if not (GetWorld() and GetWorld():IsUnderwater()) then
		self:Hide()
	end

	self:StartUpdating()
end)

function OxygenBadge:SetPercent(val, max, penaltypercent)
	Badge.SetPercent(self, val, max)

	penaltypercent = penaltypercent or 0
	self.topperanim:GetAnimState():SetPercent("anim", penaltypercent)
end

function OxygenBadge:OnUpdate(dt)
	local rate = self.owner.components.oxygen:GetRate()
	
	local small_down = .02
	local med_down = .1
	local large_down = .3
	local small_up = .01
	local med_up = .1
	local large_up = .2
	local anim = nil
	anim = "neutral"
	
	if rate > 0 and self.owner.components.oxygen:GetPercent(true) < 1 then
		if rate > large_up then
			anim = "arrow_loop_increase_most"
		elseif rate > med_up then
			anim = "arrow_loop_increase_more"
		elseif rate > small_up then
			anim = "arrow_loop_increase"
		end
		
	elseif rate < 0 and self.owner.components.oxygen:GetPercent(true) > 0 then
		if rate < -large_down then
			anim = "arrow_loop_decrease_most"
		elseif rate < -med_down then
			anim = "arrow_loop_decrease_more"
		elseif rate < -small_down then
			anim = "arrow_loop_decrease"
		end
	end
	
	if anim and self.arrowdir ~= anim then
		self.arrowdir = anim
		self.oxygenarrow:GetAnimState():PlayAnimation(anim, true)
	end
	
end

return OxygenBadge
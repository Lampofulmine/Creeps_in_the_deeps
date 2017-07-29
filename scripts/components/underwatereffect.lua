local easing = require("easing")

local UnderWaterEffect = Class(function(self, inst)
    self.inst = inst
	self.fxtime = 0
	self.fxvalue = 0.1
	self.inst:StartUpdatingComponent(self)
end)

function UnderWaterEffect:OnUpdate(dt)	
	print("wavey")
	local speed = easing.outQuad(1, 0, .05, 1) 
	self.fxtime = self.fxtime + dt*speed
	
	PostProcessor:SetEffectTime(self.fxtime)
	
	local distortion_value = easing.outQuad(1, 0, 1, 1) 

	PostProcessor:SetDistortionFactor(distortion_value)
	PostProcessor:SetDistortionRadii(0.6, 1)
	--PostProcessor:SetDistortionRadii(0.685, 0.72)
end

return UnderWaterEffect

local TidalManager = Class(function(self, inst)
    self.inst = inst

	self.max_wave_power = 4
	self.next_wave_time = 3
	self.wave_power_duration = 2;
	
	self.wave_angle = 0
	self.next_wave_angle = 0
	
	self.wave_duration = 0
	
	self.inst:StartUpdatingComponent(self)
end)

function TidalManager:SetMaxPower(n)
	self.max_wave_power = n
end

function TidalManager:SetNextWaveTime(n)
	self.next_wave_time = n
end

function TidalManager:SetWaveDuration(n)
	self.wave_power_duration = n
end

function TidalManager:GetWaveDirection()
	return self.wave_angle
end

function TidalManager:WavePowerPercentage()
	local power_percent = (math.cos(self.wave_duration*PI/self.wave_power_duration)+1)*0.5
	
	if self.wave_duration >= self.wave_power_duration then
		return 0
	else
		return power_percent
	end
end

function TidalManager:OnUpdate(dt)
	self.wave_duration = self.wave_duration + dt
	
	if self.wave_duration >= self.next_wave_time then
		--print("Tidal change")

		self.wave_angle = self.wave_angle + 180
		if self.wave_angle > 360 then
			self.wave_angle = self.wave_angle - 360
		end
		
		self.inst:PushEvent("tidal_change", {wave_angle = self.wave_angle, wave_power = self.max_wave_power})
		self.wave_duration = 0
	end
	
	--print("Wave power: "..self:WavePowerPercentage())
end

return TidalManager
local BubbleBlower = Class(function(self, inst)
    self.inst = inst
	
	-- Set outside component
	self.bubble_rate = 1
	self.y_offset = 160
	self.xz_offset = 60
	self.max_bubbles = nil
	self.remove_on_finish = false
	
	-- Set inside component
	self.bubble_base_size = 1
	self.time_since_bubble = 0
	self.time_til_bubble = nil
	
	self.inst:StartUpdatingComponent(self)
end)

function BubbleBlower:GetXZOffset()
    return math.random(-self.xz_offset, self.xz_offset)*0.01
end

function BubbleBlower:GetYOffset()
    return math.random(self.y_offset, self.y_offset + 20)*0.01
end

function BubbleBlower:SetXZOffset(xz_off)
	self.xz_offset = xz_off
end

function BubbleBlower:SetYOffset(y_off)
	self.y_offset = y_off
end

function BubbleBlower:SetBubbleRate(rate)
	self.bubble_rate = rate
end

function BubbleBlower:SetMaxBubbles(max_bubbles)
	self.max_bubbles = max_bubbles
end

function BubbleBlower:RemoveOnFinish(bool)
	self.remove_on_finish = bool
end

function BubbleBlower:OnUpdate(dt)
	
	-- First bubble
	if not self.time_til_bubble then
		self.time_til_bubble = math.random()/self.bubble_rate
	end

	-- Large creatures blow bigger bubbles
	if self.inst:HasTag("largecreature") or self.large_ripples then
		self.bubble_base_size = 1.5
	end

	-- Increment timer
	self.time_since_bubble = self.time_since_bubble + dt
	
	-- Blow bubbles underwater
	if (self.time_since_bubble > self.time_til_bubble) and GetWorld():IsUnderwater() then
		
		-- Create bubble
		local pt = Vector3(self.inst.Transform:GetWorldPosition())  
		local bubble = SpawnPrefab("bubble_fx_small")

		-- Randomly change the size of the bubble a little
		local bubble_size = (math.random(5, 10)/10)*self.bubble_base_size	
		if bubble_size then
			bubble.AnimState:SetScale(bubble_size,bubble_size,bubble_size)	
		end
		
		-- Set the bubble position
		bubble.Transform:SetPosition(pt:Get())	
		bubble.Transform:SetPosition(self.inst:GetPosition().x + self:GetXZOffset(), self.inst:GetPosition().y + self:GetYOffset(), self.inst:GetPosition().z + self:GetXZOffset())		

		-- Reset timer
		self.time_since_bubble = 0
		self.time_til_bubble = math.random()/self.bubble_rate

		-- Stop blowing bubbles after a maximum is reached (if set)
		if self.max_bubbles then

			self.max_bubbles = self.max_bubbles - 1
			
			if self.max_bubbles <= 0 then
				self.inst:StopUpdatingComponent(self)
			end
			
			if self.max_bubbles <= 0 and self.remove_on_finish then
				self.inst:Remove()
			end
		end
	end
end

return BubbleBlower
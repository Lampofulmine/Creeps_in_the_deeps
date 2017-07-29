return function(inst)

	local _LongUpdate = inst.LongUpdate
	function inst:LongUpdate(...)
		if GetWorld():IsUnderwater() then
			GetWorld():RemoveTag("cave")
			_LongUpdate(self, ...)
			GetWorld():AddTag("cave")
		end
		_LongUpdate(self, ...)
	end
	local _OnUpdate = inst.OnUpdate
	function inst:OnUpdate(...)
		if GetWorld():IsUnderwater() then
			GetWorld():RemoveTag("cave")
			_OnUpdate(self, ...)
			GetWorld():AddTag("cave")
		end
		_OnUpdate(self, ...)
	end
	local _LerpAmbientColour = inst.LerpAmbientColour
	function inst:LerpAmbientColour(...)
		if GetWorld():IsUnderwater() then
			GetWorld():RemoveTag("cave")
			_LerpAmbientColour(self, ...)
			GetWorld():AddTag("cave")
		end
		_LerpAmbientColour(self, ...)
	end
	
end
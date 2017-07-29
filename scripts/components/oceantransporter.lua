local OceanTransporter = Class(function(self, inst, activcb)
    self.inst = inst
    self.OnActivate = activcb
    self.inactive = true
end)

function OceanTransporter:CollectSceneActions(doer, actions)
	if self.inactive then 
		table.insert(actions, ACTIONS.DIVEDEEP)
	end
end

function OceanTransporter:DoActivate(doer)
	if self.OnActivate ~= nil then
		self.inactive = false
		self.OnActivate(self.inst, doer)
	end
end

return OceanTransporter

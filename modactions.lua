
local act_divedeep = GLOBAL.Action(1, nil, nil, 4)
act_divedeep.str = "Dive in"
act_divedeep.id = "DIVEDEEP"
act_divedeep.fn = function(act)
	if act.target and act.target.components.oceantransporter then
		act.target.components.oceantransporter:DoActivate(act.doer)		
		return true
	end
end
AddAction(act_divedeep)

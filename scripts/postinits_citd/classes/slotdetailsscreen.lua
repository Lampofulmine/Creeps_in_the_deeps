-- Slot details update
local function fn(inst)

	inst.BuildMenu_pre = inst.BuildMenu	
	inst.BuildMenu = function(self)
		self:BuildMenu_pre()

		local slotnum = self.saveslot
		local day = SaveGameIndex:GetSlotDay(slotnum)
		
		local level = SaveGameIndex:GetCurrentCaveLevel(slotnum)
		local levels = require("map/levels")
		
		if not (slotnum and day and level and levels) then
			return
		end
		
		if SaveGameIndex.data.slots[slotnum].current_mode == "cave" and levels and levels.cave_levels then
			if levels.cave_levels[level].id == "UNDERWATER_LEVEL_1" then
				self.text:SetString((STRINGS.UI.LOADGAMESCREEN.UW):format(1, day))
			elseif levels.cave_levels[level].id == "UNDERWATER_LEVEL_2" then
				self.text:SetString((STRINGS.UI.LOADGAMESCREEN.UW):format(2, day))
			end
		end
	end
end

return {fullname = "screens/slotdetailsscreen", fn = fn}
local function fn(inst)

	inst.MakeSaveTile_pre = inst.MakeSaveTile
	inst.MakeSaveTile = function(self, slotnum)
		local widget = self:MakeSaveTile_pre(slotnum)
		local day = SaveGameIndex:GetSlotDay(slotnum)
		
		local level = SaveGameIndex:GetCurrentCaveLevel(slotnum)
		local levels = require("map/levels")
		
		if not (slotnum and day and level and levels and widget) then
			return
		end
		
		if SaveGameIndex.data.slots[slotnum].current_mode == "cave" and levels and levels.cave_levels then
			if levels.cave_levels[level].id == "UNDERWATER_LEVEL_1" then
				widget.text:SetString((STRINGS.UI.LOADGAMESCREEN.UW_SHORT):format(1))
			elseif levels.cave_levels[level].id == "UNDERWATER_LEVEL_2" then
				widget.text:SetString((STRINGS.UI.LOADGAMESCREEN.UW_SHORT):format(2))
			end
		end
		
		return widget
	end
end

return {fullname = "screens/loadgamescreen", fn = fn}
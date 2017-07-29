-- Including a function to add certain loot to a prefab
--if not IsDLCEnabled(GLOBAL.CAPY_DLC) then

local function fn(inst)

    inst.AddLoot = function(self, loot)

        if not self.loot then
            self.loot = {}
        end
        if type(loot) == "table" then
        for k,v in pairs(loot) do
            table.insert(self.loot, v)
        end
else
            table.insert(self.loot, loot)
end
    end
end

return fn

--end
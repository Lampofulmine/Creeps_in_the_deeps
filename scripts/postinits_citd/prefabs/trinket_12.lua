-- Dessicated tentacle becomes edible
local function trinket_12fn(inst)
inst:AddTag("edible") 

end

return {trinket_12 = trinket_12fn}


-- Debugman version causes MOD to crash...?
--AddPrefabPostInit("trinket_12", function(inst)
    --inst:AddTag("edible")
--end)
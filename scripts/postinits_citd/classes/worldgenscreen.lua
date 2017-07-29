-- Ocean generation screen

local function fn(inst, profile, cb, world_gen_options)

	local cave_level = world_gen_options.level_type == "cave" and world_gen_options.level_world

	if cave_level == 3 or cave_level == 4 then
		TheSim:LoadPrefabs {"MOD_"..UW_GLOBALS.MODNAME}
		
		inst.bg:SetTint(UW_TUNING.CITD_BGCOLOURS[1],UW_TUNING.CITD_BGCOLOURS[2],UW_TUNING.CITD_BGCOLOURS[3], 1)
		inst.worldanim:GetAnimState():SetBuild("generating_reefs")
		inst.worldanim:GetAnimState():SetBank("generating_reefs")
		inst.worldanim:GetAnimState():PlayAnimation("idle", true)
		
		inst.worldgentext:SetString(STRINGS.UI.WORLDGEN.UWTITLE)
	
		inst.verbs = shuffleArray(STRINGS.UI.WORLDGEN.UW_VERBS) 
		inst.nouns = shuffleArray(STRINGS.UI.WORLDGEN.UW_NOUNS)
	
    	inst.verbidx = 1
    	inst.nounidx = 1

    	TheFrontEnd:GetSound():KillSound("worldgensound")
    	--TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/uwGen", "worldgensound") --@LSZ I'm working on it
    	TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/caveGen", "worldgensound") 
	end

end

return {fullname = "screens/worldgenscreen", fn = fn}
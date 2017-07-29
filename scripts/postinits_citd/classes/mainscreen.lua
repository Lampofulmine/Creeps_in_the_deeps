-- Menu shield
local function fn(inst)

	local Text = require("widgets/text")
	inst.shield:Kill()
	inst.shield = inst.fixed_root:AddChild(Image("images/screens/main_menu.xml", "main_menu.tex"))
	inst.banner = inst.shield:AddChild(Image("images/ui.xml", "update_banner.tex"))
    inst.banner:SetVRegPoint(ANCHOR_MIDDLE)
    inst.banner:SetHRegPoint(ANCHOR_MIDDLE)
    inst.banner:SetPosition(25, -130, 0)
    inst.updatename = inst.banner:AddChild(Text(BUTTONFONT, 30))
    inst.updatename:SetPosition(0,8,0)
	inst.updatename:SetString(STRINGS.UI.MAINSCREEN.UW_UPDATENAME)
    inst.updatename:SetColour(0,0,0,1)

	inst.bg:SetTint(UW_TUNING.CITD_BGCOLOURS[1],UW_TUNING.CITD_BGCOLOURS[2],UW_TUNING.CITD_BGCOLOURS[3], 1)
	if inst.chester_upsell then
		inst.chester_upsell:Kill()
		local UIAnim = require("widgets/uianim")
		inst.cornerdude = inst.left_col:AddChild(UIAnim())
		inst.cornerdude:SetPosition(0, -280, 0)
		inst.cornerdude:SetScale(0.7, 0.7, 1)
		inst.cornerdude:GetAnimState():SetBank("corner_dude")
		inst.cornerdude:GetAnimState():SetBuild("wx78")
		inst.cornerdude:GetAnimState():Hide("ARM_carry")
		inst.cornerdude:GetAnimState():PlayAnimation("idle", true)
		local time_left = (10+math.random(10))
		local anims = {"eat", "scratch", "scratch"}
		function inst.cornerdude:OnUpdate(dt)
			if time_left <= 0 then
				inst.cornerdude:GetAnimState():PlayAnimation(anims[math.random(#anims)])
				inst.cornerdude:GetAnimState():PushAnimation("idle", true)
				time_left = (10+math.random(30))
			else
				time_left = time_left - dt
			end
		end
		inst.cornerdude:StartUpdating()
	end
	
	
	-- Theme music switcher
	inst.OriginalSoundPlaying = true
	
	function inst:OnUpdate(dt)
		if inst.OriginalSoundPlaying then
			print("Killing original theme music")
			
			TheFrontEnd:GetSound():KillSound("FEMusic")
			TheFrontEnd:GetSound():PlaySound("citd/music/music_FE", "FEMusic")
			inst.OriginalSoundPlaying = false
			
			inst:StopUpdating()
		end
	end
	
	inst:StartUpdating()
end

return {fullname = "screens/mainscreen", fn = fn}
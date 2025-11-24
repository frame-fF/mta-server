
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy

local NegoAnim = {
	
	ifp = {},
	
	anims = {

		"run_1armed",
		"run_armed",
		"run_civi",
		"run_csaw",
		"run_fat",
		"run_fatold",
		"run_gang1",
		"run_left",
		"run_old",
		"run_player",
		"run_right",
		"run_rocket",
		"Run_stop",
		"Run_stopR",
		"Run_Wuzi",
		"WALK_armed",
		"WALK_civi",
		"WALK_csaw",
		"Walk_DoorPartial",
		"WALK_drunk",
		"WALK_fat",
		"WALK_fatold",
		"WALK_gang1",
		"WALK_gang2",
		"WALK_old",
		"WALK_player",
		"WALK_rocket",
		"WALK_shuffle",
		"WALK_start",
		"WALK_start_armed",
		"WALK_start_csaw",
		"WALK_start_rocket",
		"Walk_Wuzi",
		"WEAPON_crouch",
		"woman_idlestance",
		"woman_run",
		"WOMAN_runbusy",
		"WOMAN_runfatold",
		"woman_runpanic",
		"WOMAN_runsexy",
		"WOMAN_walkbusy",
		"WOMAN_walkfatold",
		"WOMAN_walknorm",
		"WOMAN_walkold",
		"WOMAN_walkpro",
		"WOMAN_walksexy",
		"WOMAN_walkshop",
	}
	
}

-- ฟังก์ชันสำหรับเปิดใช้งานท่าทาง (เมื่อกดวิ่ง)
function enableNegoAnims()
    for _, animName in ipairs(NegoAnim.anims) do
        -- แทนที่ท่าทางสำหรับ Local Player เท่านั้น
        engineReplaceAnimation(localPlayer, "ped", animName, NegoAnim.ifp["block"], animName)
        engineReplaceAnimation(localPlayer, "bikep", animName, NegoAnim.ifp["block2"], animName)
        engineReplaceAnimation(localPlayer, "crack", animName, NegoAnim.ifp["block3"], animName)
    end
end

-- ฟังก์ชันสำหรับคืนค่าท่าทางเดิม (เมื่อปล่อยปุ่มวิ่ง)
function disableNegoAnims()
    for _, animName in ipairs(NegoAnim.anims) do
        -- คืนค่าท่าทางเดิม
        engineRestoreAnimation(localPlayer, "ped", animName)
        engineRestoreAnimation(localPlayer, "bikep", animName)
        engineRestoreAnimation(localPlayer, "crack", animName)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()

    NegoAnim.ifp["block"] = "NegoPedBlock" 
    NegoAnim.ifp["block2"] = "NegoBikeBlock"
    NegoAnim.ifp["block3"] = "NegoCrackBlock"
    
    -- โหลดไฟล์ IFP เข้ามาใน Block ที่เราตั้งชื่อใหม่
    local ifp1 = engineLoadIFP("ped.ifp", NegoAnim.ifp["block"])
    local ifp2 = engineLoadIFP("bikep.ifp", NegoAnim.ifp["block2"])
    local ifp3 = engineLoadIFP("crack.ifp", NegoAnim.ifp["block3"])
end)

-- ผูกปุ่ม (Bind Key) กับฟังก์ชัน
-- "sprint" คือปุ่มวิ่ง (ค่าเริ่มต้นคือ Shift หรือ Spacebar บนบางเครื่อง)
bindKey("sprint", "down", enableNegoAnims) -- กดลง -> เปิดใช้งาน
bindKey("sprint", "up", disableNegoAnims)   -- ปล่อยมือ -> ปิดใช้งาน

-- addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function()
--     -- เมื่อเปลี่ยนอาวุธ ให้คืนค่าเดิมก่อนเสมอ เพื่อล้างสถานะที่อาจจะค้าง
--     disableNegoAnims()
-- end)

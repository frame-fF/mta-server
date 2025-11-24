
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

addEventHandler("onClientResourceStart", resourceRoot,function()

	NegoAnim.ifp["block"] = "ped"
	NegoAnim.ifp["block2"] = "bikep"
	NegoAnim.ifp["block3"] = "crack"
	
	NegoAnim.ifp["ifp"] = engineLoadIFP("ped.ifp", NegoAnim.ifp["block"])
	NegoAnim.ifp["ifp"] = engineLoadIFP("bikep.ifp", NegoAnim.ifp["block2"])
	NegoAnim.ifp["ifp"] = engineLoadIFP("crack.ifp", NegoAnim.ifp["block3"])

	for _, v in ipairs(NegoAnim.anims) do
		for _, p in ipairs(getElementsByType("player")) do
			engineReplaceAnimation(p, "ped", v, NegoAnim.ifp["block"], v)
			engineReplaceAnimation(p, "bikep", v, NegoAnim.ifp["block2"], v)
			engineReplaceAnimation(p, "crack", v, NegoAnim.ifp["block3"], v)
		end
	end
end)

-- NEGOZ
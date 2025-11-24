local animTable = {"RIFLE_crouchload","RIFLE_load"}

addEventHandler("onClientResourceStart", resourceRoot, function()
	engineLoadIFP("rifle.ifp", "rifle")

	for _, v in ipairs(animTable) do
		engineReplaceAnimation(localPlayer, "rifle", v, "rifle", v)
	end
end)

local animTable = {"python_crouchreload","python_reload"}

addEventHandler("onClientResourceStart", resourceRoot, function()
	engineLoadIFP("python.ifp", "python")

	for _, v in ipairs(animTable) do
		engineReplaceAnimation(localPlayer, "python", v, "python", v)
	end
end)


-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy  
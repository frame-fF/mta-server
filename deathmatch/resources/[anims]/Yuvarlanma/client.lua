addEventHandler("onClientResourceStart", resourceRoot, function()
	AugustoIFP = engineLoadIFP("files/anim.ifp", "Rolling")
	if AugustoIFP then
		outputDebugString("[GTADev]Animação De Rolamento Processada Com Sucesso")
	else
		outputDebugString("[GTADev]Erro No Processamento Da Animação De Rolamento")
	end
end)

addEvent("startAnim",true)
addEventHandler("startAnim", getRootElement(), function(element, typeroll)
	local animBlock, animName = getPedAnimation(element)
	if animBlock ~= false and animName ~= false then return end
	if tonumber(typeroll) == 1 then
		setPedAnimation(element, "Rolling", "VRolling_Front", -1, false, true, false, false)
	elseif tonumber(typeroll) == 2 then
		setPedAnimation(element, "Rolling", "VRolling_Back", -1, false, true, false, false)
	elseif tonumber(typeroll) == 3 then
		setPedAnimation(element, "Rolling", "VRolling_Right", -1, false, true, false, false)
	elseif tonumber(typeroll) == 4 then
		setPedAnimation(element, "Rolling", "VRolling_Left", -1, false, true, false, false)
	end
end)

-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy    <--- 1.790 Kişi Olduk Sende Gel :)
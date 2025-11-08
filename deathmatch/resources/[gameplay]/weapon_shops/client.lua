function createWeaponShopGUI()
    outputChatBox("open", player)
    -- GUI creation code here

end

function hideGUI()
    outputChatBox("close", player)
    -- GUI hiding code here

end


addEvent("weapon_shops_open", true)
addEventHandler("weapon_shops_open", root, createWeaponShopGUI)


addEvent("weapon_shops_close", true)
addEventHandler("weapon_shops_close", root, hideGUI)
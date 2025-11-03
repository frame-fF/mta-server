local function onPlayerJoin()
    outputChatBox("Welcome to the server! Please login or register.", source)
    -- ซ่อน HUD และแสดงเคอร์เซอร์
    triggerClientEvent(source, "showLoginPanel", source)
end

addEventHandler("onPlayerJoin", root, onPlayerJoin)
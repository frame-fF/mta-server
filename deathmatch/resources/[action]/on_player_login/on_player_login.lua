local function onPlayerLogin()
    local result = exports.api_player:get_player_account(source)
end

addEventHandler("onPlayerLogin", root, onPlayerLogin)
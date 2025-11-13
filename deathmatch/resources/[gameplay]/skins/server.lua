local function addBackpack(player)
    local x, y, z = getElementPosition(player)
    
    local backpack = createObject(371, x, y, z)
    exports.pAttach:attach(backpack, player, "backpack", 0, -0.16, 0.05, 270, 0, 180)
end

addEventHandler("onPlayerResourceStart", root, function()
    addBackpack(source)
end)

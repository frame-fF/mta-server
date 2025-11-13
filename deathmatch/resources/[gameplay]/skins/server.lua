local function addBackpack(player)
    local x,y,z = getElementPosition(player)
    local backpack = createObject(371, x,y,z)
    exports.pAttach:attach(backpack, player, "backpack", 0,-0.225,0.05,90,0,0)
end

addEventHandler("onPlayerJoin", root, function()
    addBackpack(source)
end)

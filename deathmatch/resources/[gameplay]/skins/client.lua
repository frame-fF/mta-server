local function onClientResourceStart()
    -- items
    local dff = engineLoadDFF("items/backpack_british.dff")
    engineReplaceModel(dff, 1318)
    local txd = engineLoadTXD("items/backpack_british.txd")
    engineImportTXD(txd, 1318)
    local dff = engineLoadDFF("items/backpack_patrol.dff")
    engineReplaceModel(dff, 3026)
    local txd = engineLoadTXD("items/backpack_patrol.txd")
    engineImportTXD(txd, 3026)

    -- skin skins
    local dff = engineLoadDFF("skins/male01.dff")
    engineReplaceModel(dff, 7)
    local txd = engineLoadTXD("skins/male01.txd")
    engineImportTXD(txd, 7)

    -- clothes skins
    local dff = engineLoadDFF("clothes/hockeymask.dff")
    engineReplaceModel(dff, 30091)
    local txd = engineLoadTXD("clothes/hockey.txd")
    engineImportTXD(txd, 30376)

    -- weapons skins
    -- parachute
    -- local dff = engineLoadDFF("weapons/gun_para.dff")
    -- engineReplaceModel(dff, 371)
    -- local txd = engineLoadTXD("weapons/gun_para.txd")
    -- engineImportTXD(txd, 371)
    -- desert eagle
    local dff = engineLoadDFF("weapons/desert_eagle.dff")
    engineReplaceModel(dff, 348)
    local txd = engineLoadTXD("weapons/desert_eagle.txd")
    engineImportTXD(txd, 348)
    -- ak47
    local dff = engineLoadDFF("weapons/ak47.dff")
    engineReplaceModel(dff, 355)
    local txd = engineLoadTXD("weapons/ak47.txd")
    engineImportTXD(txd, 355)
    -- m4
    local dff = engineLoadDFF("weapons/m4.dff")
    engineReplaceModel(dff, 356)
    local txd = engineLoadTXD("weapons/m4.txd")
    engineImportTXD(txd, 356)
    -- sniper
    local dff = engineLoadDFF("weapons/sniper.dff")
    engineReplaceModel(dff, 358)
    local txd = engineLoadTXD("weapons/sniper.txd")
    engineImportTXD(txd, 358)

    -- vehicle skins
    local dff = engineLoadDFF("vehicles/buffalo.dff")
    engineReplaceModel(dff, 402)
    local txd = engineLoadTXD("vehicles/buffalo.txd")
    engineImportTXD(txd, 402)
end

-- Event Handlers

addEventHandler("onClientResourceStart", getRootElement(), onClientResourceStart)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local dff = engineLoadDFF("files/hockeymask.dff")
        engineReplaceModel(dff, 30091)
        local txd = engineLoadTXD("files/hockey.txd")
        engineImportTXD(txd, 30376)
    end
)
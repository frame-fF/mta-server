local weapons = {
   {fileName="ak47", model=355},
   {fileName="colt", model=346},
   {fileName="m4", model=356},
   {fileName="magnum", model=348},
   {fileName="shotgun", model=349},
   {fileName="sniper", model=358},
   {fileName="uzi", model=352},
   {fileName="silen", model=347},
   {fileName="spaz", model=351},
   {fileName="off", model=350},
   {fileName="tec9", model=372},
   {fileName="spray", model=365}
}

function replaceWeapons()
    for i, weapon in pairs(weapons) do
        txd = engineLoadTXD ("models/weap/"..weapon.fileName.. ".txd", weapon.model)
        engineImportTXD (txd, weapon.model)
        dff = engineLoadDFF ("models/weap/"..weapon.fileName.. ".dff", weapon.model)
        engineReplaceModel (dff, weapon.model)
    end
end

addEventHandler("onClientResourceStart",resourceRoot,
function ()
        setTimer (replaceWeapons, 1000, 1)
end)
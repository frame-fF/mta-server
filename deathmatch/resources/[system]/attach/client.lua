local ak47 = createObject(355, 0, 0, 0)
local sni = createObject(358, 0, 0, 0)

exports.pAttach:attach(ak47, getLocalPlayer(), "spine", 0, -0.15, 0, 0, 0, 0)
exports.pAttach:attach(sni, getLocalPlayer(), "spine",  0, -0.15, 0, 0, 0, 0)

exports.pAttach:setPositionOffset(ak47, 0, -0.15, 0)
exports.pAttach:setPositionOffset(sni, 0, -0.15, 0)
local soundsOn = true -- change to 'false' if you want modded sounds to be off by default and make the /togsound command opt-in

function toggleSound()
	soundsOn = not soundsOn
	outputChatBox("Weapon sounds have been successfully toggled!")
end
addCommandHandler("togsound",toggleSound)

function playGunfireSound(weaponID)
	if not soundsOn then return false end
	setAmbientSoundEnabled ("gunfire", false)
	--setWorldSoundEnabled (5, false) // would disable ALL default weapon sounds to avoid double sound.. use only if you are sure that you got custom weapon sound for all weapons.. also knife etcetera. Tricky
	local muzzleX, muzzleY, muzzleZ = getPedWeaponMuzzlePosition(source)
	local dim = getElementDimension(source)
	local int = getElementInterior(source)

	local weaponSounds = {
		[22] = "sounds/weap/colt45.ogg",
		[23] = "sounds/weap/silenced.ogg",
		[24] = "sounds/weap/deagle.ogg",
		[25] = "sounds/weap/shotgun.ogg",
		[26] = "sounds/weap/sawed-off.ogg",
		[27] = "sounds/weap/combat_shotgun.ogg",
		[28] = "sounds/weap/uzi.ogg",
		[30] = "sounds/weap/ak-47.ogg",
		[31] = "sounds/weap/m4.ogg",
		[32] = "sounds/weap/tec9.ogg",
		[34] = "sounds/weap/sniper.ogg",
	}

	if weaponSounds[weaponID] then
		sound = playSound3D(weaponSounds[weaponID], muzzleX, muzzleY, muzzleZ)
		setSoundMaxDistance(sound, 90)
		setElementDimension(sound, dim)
		setElementInterior(sound, int)
		setSoundVolume(sound, 0.6)
		end
end
addEventHandler("onClientPlayerWeaponFire", root, playGunfireSound)


addEventHandler("onClientResourceStart",resourceRoot,
function ()
        outputChatBox("use /togsound to toggle modded weapon sounds on/off!");
end)
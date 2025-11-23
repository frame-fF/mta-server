--SCRIPT SETTINGS START HERE--
local noPVP = true
--SCRIPT SETTINGS END HERE

local sw,sh = guiGetScreenSize()
local tx = sw/2
local ty = sh/10
local color = tocolor(75,0,0,255)
local colshape
local ids = {13,22,56,67,68,69,70,84,92,97,105,107,108,111,126,127,128,152,162,167,188,192,195,206,209,212,229,230,258,264,274,277,280,287}
local maxSoundID = 10

local _getElementsWithinColShape = getElementsWithinColShape
local _isElementWithinColShape = isElementWithinColShape

local playersDead = {}
local zombies = {}
local zombiesDoomed = {}
local aliveZombies = {}
local headshotsHandled = {}
local playerStats = {}
local zombieKillSounds = {}
local playerDeathCheckTimers = {}

local texts = {"Headshots","Kills","Player name"}
local boardX = sw-200
local boardY = 0.6*sh
local boardCW = 100
local boardCH = 20

local minPlayerIDToShow = 1
local maxPlayersToShow = 8
local maxPlayersToShow = 8

local playersDamaged = {}

local function preCheckPlayer(player,colshape)

	if not player then return false end
	if not colshape then return false end
	if not isElement(player) then return false end
	if not isElement(colshape) then return false end
	if player.type ~= "player" then return false end
	if player.interior ~= colshape.interior then return false end
	if player.dimension ~= colshape.dimension then return false end
	if isPedDead(player) then return false end
	
	return true

end

local function getElementsWithinColShape()

	local players = _getElementsWithinColShape(colshape,"player")
	local ret = {}
	
	for index,player in ipairs(players) do
		if preCheckPlayer(player,colshape) then
			table.insert(ret,player)
		end
	end
	
	return ret

end

local function isElementWithinColShape()

	if _isElementWithinColShape(localPlayer,colshape) then
		if preCheckPlayer(localPlayer,colshape) then
			return true
		end
	end
	
	return false

end

local function resetDamage(player)

	if playersDamaged[player] then playersDamaged[player] = nil end

end

local function checkPVP(attacker)

	if source == localPlayer then
		if isElementWithinColShape() then
			return cancelEvent()
		end
	end
	
	if attacker == localPlayer and source ~= localPlayer and isElementWithinColShape() and not playersDamaged[source] then
		playersDamaged[source] = true
		setTimer(resetDamage,5000,1,source)
	end

end

local function rot( x1, y1, x2, y2 )
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

local function getNearestPlayer(zombie,checkZ)

	if not zombie then return false end
	if not isElement(zombie) then return false end

	local players = getElementsWithinColShape()
	local shortestDistance = 10000
	local shortestPlayer = false
	for index,player in ipairs(players) do
		local distance = getDistanceBetweenPoints3D(zombie.position,player.position)
		if distance < shortestDistance then
			local playerOnGround = true
			if checkZ then
				playerOnGround = (player.position.z > 127 and player.position.z < 131)
			end
			if playerOnGround then
				shortestDistance = distance
				shortestPlayer = player
			end
		end
	end
	
	return shortestPlayer,shortestDistance

end

local function dxDrawBox(x,y,w,h,c)

	local x1 = x+w
	local y1 = y+h

	dxDrawLine(x,y,x1,y,-1,2)
	dxDrawLine(x,y,x,y1,-1,2)
	dxDrawLine(x,y1,x1,y1,-1,2)
	dxDrawLine(x1,y,x1,y1,-1,2)
	
end

local function renderZombies()
	
	if not isElementWithinColShape() then return end
	dxDrawText("Zombies (Alive/Total): "..tostring(#aliveZombies).."/"..tostring(#zombies),tx,ty,tx,ty,color,3,"pricedown","center","center")
	local playerID = 0
	local playerCount = 0
	local width = dxGetTextWidth("Player name")+40
	local drawedStats = {}
	for player,stats in pairs(playerStats) do
		local nameWidth = dxGetTextWidth(player.name)
		if nameWidth+40 > width then
			width = nameWidth+40
		end
		playerCount = playerCount + 1
		if playerCount > maxPlayersToShow-1 then playerCount = maxPlayersToShow-1 end
		table.insert(drawedStats,{stats[2],stats[1],player.name})
	end
	dxDrawRectangle(boardX-width,boardY,width+2*boardCW,playerCount*boardCH+boardCH,tocolor(0,0,0,100))
	for playerID,stats in ipairs(drawedStats) do
		for statID,statValue in ipairs(stats) do
			local w = (statID == 3 and width or boardCW)
			local x = (statID == 3 and boardX-width or sw-statID*boardCW)
			local y = boardY+(playerID-minPlayerIDToShow+1)*boardCH
			if playerID >= minPlayerIDToShow and playerID < minPlayerIDToShow+maxPlayersToShow-1 then
				local r,g,b = getPlayerNametagColor(getPlayerFromName(stats[3]))
				local color = tocolor(r,g,b)
				dxDrawBox(x,y,w,boardCH)
				dxDrawText(tostring(statValue),x+10,y+4,x+10,y+4,color)
			end
			if playerID == 1 then
				local x2 = sw-2*boardCW-width
				local y2 = boardY-15
				dxDrawBox(x,boardY,w,boardCH)
				dxDrawText(texts[statID],x+10,boardY+4)
				dxDrawText("Hold lctrl and scroll mouse to scroll the scoreboard",x2,y2)
			end
		end
	end
	if noPVP then
		for playerDamaged,_ in pairs(playersDamaged) do
			if playerDamaged and isElement(playerDamaged) then
				local x,y,z = getPedBonePosition(playerDamaged,6)
				if x and y and z then
					local sx,sy = getScreenFromWorldPosition(x,y,z)
					if sx and sy then
						local cx,cy,cz = getCameraMatrix()
						local dist = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
						local isClear = isLineOfSightClear(cx,cy,cz,x,y,z,true,true,false,true,false,false,false,localPlayer)
						if isClear and dist < 50 then
							dxDrawText("You can not harm fellow humans!",sx,sy-30,sx,sy-30,tocolor(255,0,0),1.1,"default-bold","center","center")
						end
					end
				end
			end
		end
	end

end

local function headshotZombie(killer,_,bodypart,loss)

	local player,distance = getNearestPlayer(source)

	if distance < 2 then
		cancelEvent()
	end
	
	if killer == localPlayer and colshape and isElement(colshape) and preCheckPlayer(localPlayer,colshape) then
		triggerServerEvent("Zombies:damageZombie",source,bodypart,loss)
	end

end

local function sendDeletionRequest(zombie)

	if not isElement(zombie) then return end

	if not zombiesDoomed[zombie] then
		triggerLatentServerEvent("Zombies:destroyZombie",4000,zombie)
		zombiesDoomed[zombie]=nil
	end

end

local function destroyZombie()

	zombiesDoomed[source] = true
	setTimer(sendDeletionRequest,6000,1,source)

end

local function unhandleZombie()

	headshotsHandled[source] = nil
	
end

local function resetPlayer()

	setPedAnimation(source)
	playersDead[source] = nil
	removeEventHandler("onClientPlayerSpawn",source,resetPlayer)

end

local function checkPlayerDeath(zombie,victim)

	if not isPedDead(victim) then
		setPedAnimation(victim,"KNIFE","KILL_Knife_Ped_Damage",-1,false,true,false,true,250)
		setPedAnimation(zombie,"KNIFE","KILL_Knife_Player",-1,false,true,false,false,250)
		setTimer(setPedAnimation,2000,1,victim,"KNIFE","KILL_Knife_Ped_Die",-1,false,true,false,true,250)
	end

end

local function updateZombies()

	if not (colshape or isElement(colshape)) then
		colshape = getElementByID("ZombieZone")
		return
	end
	
	zombies = getElementsByType("ped",resourceRoot,true)
	aliveZombies = {}

	for index,zombie in ipairs(zombies) do
		if not headshotsHandled[zombie] then
			addEventHandler("onClientPedWasted",zombie,destroyZombie)
			addEventHandler("onClientPedDamage",zombie,headshotZombie)
			addEventHandler("onClientElementDestroy",zombie,unhandleZombie)
			headshotsHandled[zombie] = true
		end
		local zx,zy,zz = getElementPosition(zombie)
		if not isPedDead(zombie) then
			table.insert(aliveZombies,zombie)
		end
		local player,distance = getNearestPlayer(zombie,true)
		if player then
			if distance < 1 and isPedDead(zombie) == false and not playersDead[player] then
				playersDead[player] = true
				if not isElement(zombieKillSounds[zombie]) then
					zombieKillSounds[zombie] = playSound3D("sounds/mgroan"..tostring(math.random(1,maxSoundID))..".ogg",zombie.position)
					playerDeathCheckTimers[player] = setTimer(checkPlayerDeath,getPlayerPing(player)+50,1,zombie,player)
					addEventHandler("onClientPlayerSpawn",player,resetPlayer)
				end
				if player == localPlayer then
					triggerServerEvent("Zombies:murderPlayer",localPlayer,zombie)
				end
			end
			local px,py,pz = getElementPosition(player)
			local angle = rot(zx,zy,px,py)
			setPedCameraRotation(zombie,-angle)
			setPedControlState(zombie,"forwards",true)
		else
			setPedControlState(zombie,"forwards",false)
		end
		if math.random(1,10) == 5 then
			playSound3D("sounds/mgroan"..tostring(math.random(1,maxSoundID))..".ogg",zombie.position)
		end
	end

end

local function tableCount(t)

	local c = 0

	for k,v in pairs(t) do
		c=c+1
	end
	
	return c

end

local function scroll(_,_,scroller)

	local playerCount = tableCount(playerStats)

	if playerCount < maxPlayersToShow then return end

	minPlayerIDToShow = minPlayerIDToShow + scroller
	
	if minPlayerIDToShow < 1 then minPlayerIDToShow = 1 end
	if minPlayerIDToShow > tableCount(playerStats)-maxPlayersToShow then minPlayerIDToShow = playerCount-maxPlayersToShow end

end

local function toggleScrolling(_,state)

	if state == "down" then
		bindKey("mouse_wheel_down","down",scroll,1)
		bindKey("mouse_wheel_up","down",scroll,-1)
		toggleControl("previous_weapon",false)
		toggleControl("next_weapon",false)
	elseif state == "up" then
		unbindKey("mouse_wheel_down","down",scroll)
		unbindKey("mouse_wheel_up","down",scroll)
		toggleControl("previous_weapon",true)
		toggleControl("next_weapon",true)
	end

end

local function resetStats()

	if playerStats[source] then playerStats[source] = nil end

end

local function updateStats(stats)

	if not playerStats[source] and source ~= localPlayer and stats~=nil then
		addEventHandler("onClientPlayerQuit",source,resetStats)
	elseif playerStats[source] and stats == nil and source ~= localPlayer then
		removeEventHandler("onClientPlayerQuit",source,resetStats)
	end
	
	playerStats[source] = stats

end

local function resetDamageOnQuit()

	if playersDamaged[source] then playersDamaged[source] = nil end

end

local function initScript()

	colshape = getElementByID("ZombieZone")
	
	for index,id in ipairs(ids) do
		local txd = engineLoadTXD("skins/"..tostring(id)..".txd")
		engineImportTXD(txd,id)
	end
	
	setTimer(updateZombies,100,0)
	addEventHandler("onClientRender",root,renderZombies)
	bindKey("lctrl","down",toggleScrolling)
	bindKey("lctrl","up",toggleScrolling)
	if noPVP then
		addEventHandler("onClientPlayerDamage",root,checkPVP)
		addEventHandler("onClientPlayerQuit",root,resetDamageOnQuit)
	end

	addEvent("Zombies:updateStats",true)
	addEventHandler("Zombies:updateStats",root,updateStats)
	
end

addEventHandler("onClientResourceStart",resourceRoot,initScript)
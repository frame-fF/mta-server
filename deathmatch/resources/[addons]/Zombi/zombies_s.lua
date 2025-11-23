--SCRIPT SETTINGS START HERE
local maxZombies = 25 --Maximum amount of zombies in the zombie area. Be careful, setting this too high can cause lagging to clients with bad videocard/memory.
local minSpawnDistance = 30 --Minium distance that zombies can spawn from player
local maxSpawnDistance = 70 --Maximum distance that zombies can spawn from player ::NOTE: Dont set any higher than 70 or you'll run into a script error and it wont work anymore (limitation due to field size/width/height)
local maxSyncDistance = 100 --Distance what zombies HAVE TO have to another player, do not set this above 140 or syncing will start bugging. Recommended to keep below or exact to 120
local zombieHealth = 60
local zombieWalkingStyle = 126 --Change walking style of zombies with one ID from this list: https://wiki.multitheftauto.com/wiki/SetPedWalkingStyle
local minSpawnAtOnce = 3 --Amount of zombies spawning at once when the spawninterval decides to spawn zombies.
local maxSpawnAtOnce = 6
local minSpawnInterval = 3000 --Milliseconds it takes before script spawns a new heap of zombies.
local maxSpawnInterval = 6000
local zombieSkins = {13,22,56,67,68,69,70,84,92,97,105,107,108,111,126,127,128,152,162,167,188,192,195,206,209,212,229,230,258,264,274,277,280,287}
local respawnToField = true -- Makes players respawn to the zombiefield if they die there by a zombie attack
local setSyncerByLowestPing = false
local adminACL = aclGetGroup("Admin") -- For commands such as /populate and /wipefield
--SCRIPT SETTINGS END HERE

local connection
local _getElementsWithinColShape = getElementsWithinColShape

local colshape
local cx,cy,cz,cw,cd,ch = -1214,-1065,120,208,150,60

local playerCount = 0
local skinCount = #zombieSkins

local players = {}
local zombies = {}

local spawnZombieTimers = {}
local zombieSyncerTimers = {}
local zombieDestroyTimer = {}

local zombieColshapes = {}
local colshapeZombies = {}
local temporaryPlayerStats = {}

local playerWipeSpawnPositions = -- Only for /wipefield admin command, don't mistake it for area coords.
{
	{-1076,-1115,129},
	{-1108,-1115,129},
	{-1140,-1115,129},
	{-1177,-1115,129},
	{-1209,-1113,129},
	{-1169,-1134,130},
	{-1104,-1137,130}
}

local function preCheckPlayer(player,col)

	if not player then return false end
	if not isElement(player) then return false end
	if player.type ~= "player" then return false end
	if getElementID(col) ~= "ZombieZone" then return false end
	if player.interior ~= col.interior then return false end
	if player.dimension ~= col.dimension then return false end
	if isPedDead(player) then return false end
	
	return true

end

local function getElementsWithinColShape(col,playersAsKeys)

	local players = _getElementsWithinColShape(col,"player")
	local ret = {}
	
	for index,player in ipairs(players) do
		if preCheckPlayer(player,col) then
			if playersAsKeys then
				ret[player] = true
			else
				table.insert(ret,player)
			end
		end
	end
	
	return ret

end

local function getPlayerWithLowestPing(col)

	local players = getElementsWithinColShape(col)
	local lowestPing = false
	local returnPlayer = false
	for index,player in ipairs(players) do
		if lowestPing == false or player.ping < lowestPing then
			lowestPing = player.ping
			returnPlayer = player
		end
	end

	return returnPlayer
	
end

local function getNearestPlayer(zombie)

	if not zombie then return false end
	if not zombies[zombie] then return false end

	local players = getElementsWithinColShape()
	local shortestDistance = 10000
	local shortestPlayer = false
	for index,player in ipairs(players) do
		local distance = getDistanceBetweenPoints3D(zombie.position,player.position)
		if distance < shortestDistance then
			shortestDistance = distance
			shortestPlayer = player
		end
	end
	
	return shortestPlayer,shortestDistance

end

local function tableCount(t)

	local c = 0

	for k,v in pairs(t) do
		c=c+1
	end
	
	return c

end

local function checkPlayer(player,colshape)
	
	if not preCheckPlayer(player,colshape) then return false end
	
	players = getElementsWithinColShape(colshape)
	playerCount = #players
	
	return true
	
end

local function destroyZombie(zombie)

	local col = zombieColshapes[zombie]
	if colshapeZombies[col] then colshapeZombies[col] = nil end
	if zombieColshapes[zombie] then zombieColshapes[zombie] = nil end
	if col and isElement(col) then destroyElement(col) end
	if zombieDestroyTimer[zombie] and isTimer(zombieDestroyTimer[zombie]) then killTimer(zombieDestroyTimer[zombie]) end
	if zombieSyncerTimers[zombie] and isTimer(zombieSyncerTimers[zombie]) then killTimer(zombieSyncerTimers[zombie]) end
	if zombies[zombie] then zombies[zombie] = nil end
	if isElement(zombie) then destroyElement(zombie) end

end

local function getPlayerStats(player)

	if not player then return false end
	if not isElement(player) then return false end
	if player.type ~= "player" then return false end

	local stats = {0,0}
	
	if player.account and not isGuestAccount(player.account) then
		local account = player.account.name
		local handle = dbQuery(connection,"SELECT * FROM stats")
		local result = dbPoll(handle,-1)
		for index,data in ipairs(result) do
			if data["account"] == account then
				stats = {data["kills"],data["headshots"]}
				return stats
			end
		end
		return stats
	else
		if temporaryPlayerStats[player] then
			return temporaryPlayerStats[player]
		else
			temporaryPlayerStats[player] = stats
		end
	end
	
	return stats

end

local function setPlayerStats(player,stats)

	if not player then return false end
	if not isElement(player) then return false end
	if player.type ~= "player" then return false end

	if player.account and not isGuestAccount(player.account) then
		local account = player.account.name
		local handle = dbQuery(connection,"SELECT * FROM stats")
		local result = dbPoll(handle,-1)
		for index,data in ipairs(result) do
			if data["account"] == account then
				dbExec(connection,"UPDATE stats SET kills=?,headshots=? WHERE account=?",stats[1],stats[2],account)
				return true
			end
		end
		dbExec(connection,"INSERT INTO stats(account,kills,headshots) VALUES(?,?,?)",account,stats[1],stats[2])
		return true
	else
		temporaryPlayerStats[player] = stats
		return true
	end

end

local function updatePlayerStats(player)

	local stats = getPlayerStats(player)
	triggerClientEvent("Zombies:updateStats",player,stats)

end

local function removePlayerStats(player)

	triggerClientEvent("Zombies:updateStats",player)

end

local function addPlayerKill(player,headshot)

	local stats = getPlayerStats(player)
	local kills = stats[1] + 1
	local headshots = stats[2] + (headshot and 1 or 0)
	stats = {kills,headshots}
	setPlayerStats(player,stats)
	updatePlayerStats(player)
	
end

local function despawnZombie(ammo,killer,weapon,bodypart,stealth)

	local headshot = (bodypart == 9)

	if headshot then
		setPedHeadless(source,true)
	end

	if killer and killer.type == "player" then
		addPlayerKill(killer,headshot)
		givePlayerMoney(killer,1000)
	end

	zombieDestroyTimer[source] = setTimer(destroyZombie,5000,1,source)

end

local function damageZombie(bodypart,loss)

	if not client then return end
	if not zombies[source] then return end
	
	if (source.health - loss) < 0 then
		killPed(source,client,getPedWeapon(client),bodypart)
	end
	
	source.health = source.health - loss
	
	if bodypart == 9 then
		killPed(source,client,getPedWeapon(client),9)
	end

end

local function findNewSyncer2(zombie)

	if not zombies[zombie] then return end
	
	local col = zombieColshapes[zombie]
	local playerWithLowestPing = getPlayerWithLowestPing(col)
	local playerNearest = getNearestPlayer(zombie)
	local newSyncer = false
	if setSyncerByLowestPing and playerWithLowestPing then
		newSyncer = playerWithLowestPing
	elseif not setSyncerByLowestPing and playerNearest then
		newSyncer = playerNearest
	end
	
	if newSyncer then
		zombie.syncer = newSyncer
		addEventHandler("onPlayerQuit",newSyncer,removeSyncer)
	else
		destroyZombie(zombie)
	end

end

function removeSyncer()

	if zombieSyncers[source] then
		for zombie,_ in pairs(zombieSyncers[source]) do
			findNewSyncer2(zombie)
		end
	end
	
	zombieSyncers[source] = nil

end

local function setSyncer(player)

	if not preCheckPlayer(player,source) then return end
	local zombie = colshapeZombies[source]
	if not zombies[zombie] then return end
	
	local currentSyncer = getElementSyncer(zombie)
	local hasLowerPing = (currentSyncer.ping > player.ping)
	local isCloser = (getDistanceBetweenPoints3D(zombie.position,currentSyncer.position) > getDistanceBetweenPoints3D(zombie.position,player.position))
	local changeSyncer = false
	if setSyncerByLowestPing and hasLowerPing then
		changeSyncer = true
	elseif not setSyncerByLowestPing and isCloser then
		changeSyncer = true
	end
	if currentSyncer == false or changeSyncer then
		zombie.syncer = player
		addEventHandler("onPlayerQuit",player,removeSyncer)
		if not zombieSyncers[player] then
			zombieSyncers[player] = {}
		end
		zombieSyncers[player][zombie] = true
		if currentSyncer and player ~= currentSyncer and zombieSyncers[currentSyncer][zombie] then
			if zombieSyncers[currentSyncer][zombie] then
				zombieSyncers[currentSyncer][zombie] = nil
				if next(zombieSyncers[currentSyncer]) == nil then
					zombieSyncers[currentSyncer] = nil
				end
			end
		end
	end

end

local function findNewSyncer(oldSyncer)

	if not preCheckPlayer(oldSyncer,source) then return end
	if zombieSyncers[oldSyncer] then removeEventHandler("onPlayerQuit",oldSyncer,removeSyncer) end
	local zombie = colshapeZombies[source]
	
	findNewSyncer2(zombie)

end

local function getPointFromDistanceRotation(x, y, dist, angle)

    local a = math.rad(90 - angle);

    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;

    return x+dx, y+dy;

end

local function forceDestroyZombie()

	if isElement(source) then
		destroyElement(source)
	end

end

local function spawnZombie()
	
	local x,y = getPointFromDistanceRotation(math.random(cx+maxSpawnDistance,cx+cw-maxSpawnDistance),math.random(cy+maxSpawnDistance,cy+cd-maxSpawnDistance),math.random(minSpawnDistance,maxSpawnDistance),math.random(1,360))
	local s,z,r = zombieSkins[math.random(1,skinCount)],135,math.random(0,360)
	
	local zombie = Ped(s,x,y,z,r,true)
	zombie.health = zombieHealth
	zombie.walkingStyle = zombieWalkingStyle
	
	zombieColshapes[zombie] = createColSphere(zombie.position,maxSyncDistance)
	colshapeZombies[zombieColshapes[zombie]] = zombie
	
	addEventHandler("onColShapeHit",zombieColshapes[zombie],setSyncer)
	addEventHandler("onColShapeLeave",zombieColshapes[zombie],findNewSyncer)
	addEventHandler("onPedWasted",zombie,despawnZombie)
	addEventHandler("Zombies:damageZombie",zombie,damageZombie)
	addEventHandler("Zombies:destroyZombie",zombie,forceDestroyZombie)
	
	zombies[zombie] = true
	
end

function spawnZombieHeap()

	if playerCount > 0 then
		for i = 1,math.random(minSpawnAtOnce,maxSpawnAtOnce) do
			if tableCount(zombies) < maxZombies then
				spawnZombie()
			else
				break
			end
		end
	end

	if spawnZombieTimers and isTimer(spawnZombieTimers) then killTimer(spawnZombieTimers) end
	spawnZombieTimers = setTimer(spawnZombieHeap,math.random(minSpawnInterval,maxSpawnInterval),1)

end

local function murderPlayerByZombie(zombie)

	if not client then return end
	if client ~= source then return end
	if not checkPlayer(client,colshape) then return end
	if not zombies[zombie] then return end
	
	setPedHeadless(client,true)
	killPed(client,zombie,55,9,true)

end

local function updatePlayer()

	updatePlayerStats(source)

end

local function respawn()

	if respawnToField then
		setElementPosition(source,math.random(cx,cx+cw), math.random(cy,cy+cd),130)
	end
	
	setPedHeadless(source,false)

end

local function enterZombies(player)
	
	local element = player
	
	if player.vehicle and player.vehicle.controller == player then
		element = player.vehicle
	elseif player.vehicle then
		player.vehicle = nil
	end
	
	element.position = Vector3.create(math.random(cx,cx+cw), math.random(cy,cy+cd),130)
	element.interior = 0
	element.dimension = 0
	
end

local function playerQuit()

	players = getElementsWithinColShape(colshape)
	playerCount = #players
	if playerCount <= 1 then
		if spawnZombieTimers and isTimer(spawnZombieTimers) then killTimer(spawnZombieTimers) end
		for zombie,_ in pairs(zombies) do
			destroyZombie(zombie)
		end
	end
	
	removePlayerStats(source)

end

local function onEnter(player)

	if not checkPlayer(player,source) then return end
	
	if tableCount(zombies) == 0 then
		spawnZombieHeap()
	end
	
	updatePlayerStats(player)
	addEventHandler("onPlayerSpawn",player,respawn)
	addEventHandler("Zombies:murderPlayer",player,murderPlayerByZombie)
	addEventHandler("onPlayerLogin",player,updatePlayer)
	addEventHandler("onPlayerLogout",player,updatePlayer)
	addEventHandler("onPlayerQuit",player,playerQuit)
	
	
end

local function onExit(player)

	if not checkPlayer(player,source) then return end
	
	if playerCount == 0 then
		if spawnZombieTimers and isTimer(spawnZombieTimers) then killTimer(spawnZombieTimers) end
		for zombie,_ in pairs(zombies) do
			destroyZombie(zombie)
		end
	end
	
	removePlayerStats(player)
	removeEventHandler("onPlayerSpawn",player,respawn)
	removeEventHandler("Zombies:murderPlayer",player,murderPlayerByZombie)
	removeEventHandler("onPlayerLogin",player,updatePlayer)
	removeEventHandler("onPlayerLogout",player,updatePlayer)
	removeEventHandler("onPlayerQuit",player,playerQuit)

end

local function cleanField(player)

	for zombie,_ in pairs(zombies) do
		if isPedDead(zombie) or zombie.health <= 1 then
			destroyZombie(zombie)
		end
	end

end

local function isAdmin(player)

	local account = player.account
	if not account then return false end
	if isGuestAccount(account) then return false end
	if not isObjectInACLGroup("user."..account.name,adminACL) then return false end
	
	return true

end

local function wipeField(player)

	if not isAdmin(player) then return end

	if spawnZombieTimers and isTimer(spawnZombieTimers) then killTimer(spawnZombieTimers) end
	for zombie,_ in pairs(zombies) do
		destroyZombie(zombie)
	end
	
	local players = getElementsWithinColShape(colshape,false)
	for index,player in ipairs(players) do
		local x,y,z = unpack(playerWipeSpawnPositions[math.random(1,#playerWipeSpawnPositions)])
		setElementPosition(player,x+math.random(-3,3),y+math.random(-3,3),z)
	end

end

local function randomPlayersToField(player)

	if not isAdmin(player) then return end
	
	local playersOnline = getElementsByType("player")
	local amount = #playersOnline
	
	if amount == 0 then return end
	
	for index = 1,(amount > 5 and 5 or amount) do
		local player = playersOnline[index]
		enterZombies(player)
	end

end

local function initScript()

	connection = dbConnect("sqlite","zombie_stats.db")
	
	dbExec(connection,"CREATE TABLE IF NOT EXISTS stats (account TEXT, kills NUMBER,headshots NUMBER)")

	colshape = createColCuboid(cx,cy,cz,cw,cd,ch)
	setElementID(colshape,"ZombieZone")
	players = getElementsWithinColShape(colshape)
	playerCount = #players
	
	addEvent("Zombies:murderPlayer",true)
	addEvent("Zombies:damageZombie",true)
	addEvent("Zombies:destroyZombie",true)
	
	spawnZombieHeap()
	
	setTimer(cleanField,10000,0)
	
	addEventHandler("onColShapeHit",colshape,onEnter)
	addEventHandler("onColShapeLeave",colshape,onExit)
	addCommandHandler("zombies",enterZombies)
	
	addCommandHandler("wipefield",wipeField)
	addCommandHandler("populate",randomPlayersToField)

end

addEventHandler("onResourceStart",resourceRoot,initScript)
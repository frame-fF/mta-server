--[[
    Resource: Neons
	You can use this resource but please don't delete this information, It may be useful.
	Developer: Yolos
	Q&A:
	Q: Can i edit this resource? 
	A: Yes.
	Q: How to set neons?
	A: Use setElementData(vehicle, "neon", ID) where ID type number 1-6 :)
	This resource use objects from grand theft auto san andreas multiplayer.
]]

--///////////////////////////////////// Settings ////////////////////////////////////////

local NID={
	3962,2113,1784,2054,2428,2352
}
local postion={-1,0,-0.5}

--///////////////////////////////////// Other /////////////////////////////////
function bindHoron4(veh)
	if not veh then return end
	local OBJECTID=tonumber(getElementData(veh,"neony"))
	if not OBJECTID then return end
	if OBJECTID==0 then return end
	local zalozone=getElementData(veh,"zalozone")
	if (zalozone and type(zalozone)=="table") then
		destroyElement(zalozone[1])
		destroyElement(zalozone[2])
		removeElementData(veh,"zalozone")
	else
		neon1=createObject(NID[OBJECTID],0,0,0)
		neon2=createObject(NID[OBJECTID],0,0,0)
		setElementData(veh,"zalozone", {neon1, neon2})
		attachElements(neon1,veh,postion[1],postion[2],postion[3])
		attachElements(neon2,veh,-postion[1],postion[2],postion[3])
		setElementVelocity(veh,0, 0, 0.01)
	end
end

addEventHandler("onElementDestroy", getRootElement(), function ()
  if getElementType(source) == "vehicle" then
  	local zalozone=getElementData(source,"zalozone")
	if (zalozone and type(zalozone)=="table") then
		destroyElement(zalozone[1])
		destroyElement(zalozone[2])
		removeElementData(source,"zalozone")
		end
	end
end)


function outputChange(dataName,oldValue)
	if getElementType(source) == "vehicle" then
		if dataName == "neony" then
		  	local zalozone=getElementData(source,"zalozone")
			if (zalozone and type(zalozone)=="table") then
				destroyElement(zalozone[1])
				destroyElement(zalozone[2])
				removeElementData(source,"zalozone")
			end
			bindHoron4(source)
		end
	end
end
addEventHandler("onElementDataChange",getRootElement(),outputChange)


function togglepanel(player)
local seat = getPedOccupiedVehicleSeat(player)
local vehicle = getPedOccupiedVehicle(player)
if vehicle and seat == 0 then
triggerClientEvent(player,"showWindow", player)
setElementVelocity(vehicle, 0, 0 ,0)
else
outputChatBox("*Araçta olmadığınız için neon paneli açamazsınız!", player, 255 ,0 ,0)
return end
end
addCommandHandler ( "neon", togglepanel )

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
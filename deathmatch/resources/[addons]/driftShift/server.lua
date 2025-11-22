local actualHandling = { };
addEventHandler("onResourceStart", getRootElement(), function(res)
	if (res ~= getThisResource()) then
		return false;
	end
	
	actualHandling = {
		["mass"] = 100000,
		["turnMass"] = 300000,
		["dragCoeff"] = 1.5,
		["centerOfMass"] = { 0, -0.15, -0.3 },
		["percentSubmerged"] = 70,
		["tractionMultiplier"] = 0.85,
		["tractionLoss"] = 0.7,
		["tractionBias"] = 0.45,
		["numberOfGears"] = 5,
		["maxVelocity"] = 370,
		["engineAcceleration"] = 55,
		["engineInertia"] = -1000,
		["driveType"] = "petrol",
		["driveType"] = "rwd",
		["brakeDeceleration"] = 100000,
		["brakeBias"] = 0.45,
		["ABS"] = false,
	}

	if (config["Handling"]["UseCustom"]) then
		actualHandling = config["Handling"]["Custom"]
	end
end);

local oldHandling = { }

function SetVehicleReduceGripOn(vehicle)
    if not (vehicle) then return end
    if (vehicle:getType() ~= "vehicle") then return end
    if (oldHandling[vehicle]) then return end
    
    oldHandling[vehicle] = {}
    for property, value in pairs(actualHandling) do
        oldHandling[vehicle][property] = vehicle:getHandling()[property]
        setVehicleHandling(vehicle, property, value)
    end
end
addEvent("mst:SetVehicleReduceGripOn", true)
addEventHandler("mst:SetVehicleReduceGripOn", getRootElement(), SetVehicleReduceGripOn)

function SetVehicleReduceGripOff(vehicle)
    if not (vehicle) then return end
    if not (oldHandling[vehicle]) then return end

    for property, value in pairs(oldHandling[vehicle]) do
        setVehicleHandling(vehicle, property, value)
    end

    oldHandling[vehicle] = nil
end
addEvent("mst:SetVehicleReduceGripOff", true)
addEventHandler("mst:SetVehicleReduceGripOff", getRootElement(), SetVehicleReduceGripOff)

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
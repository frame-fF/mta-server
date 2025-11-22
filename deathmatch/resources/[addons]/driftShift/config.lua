config = {
    KeyStart = "lshift", -- Botão para iniciar e parar o drift
    RenderText = true, -- Texto no centro inferiror da tela que mostra se está ou não fazendo drift

    MaxVelocity = 200, -- Velocidade máxima para poder fazer drift
    MinVelocity = 30, --  Velocidade minima para poder fazer drift

	BlockVehiclesType = { -- Tipo dos veiculos que deseja bloquear. Lista de tipos: https://media.discordapp.net/attachments/654783986400493580/915261044723707904/unknown.png
		["Bike"] = true,
		["Helicopter"] = true,
		["Plane"] = true,
		["Trailer"] = true,
	},

	BlockVehicles = { -- ID dos veiculos que deseja bloquear. Lista de ID's: https://wiki.multitheftauto.com/wiki/Vehicle_IDs
		[443] = true,
	},

    Handling = {
        UseCustom = true, -- Se deseja utilizar a handling padrão do sitema, ou uma propria 
        Custom = { -- Sua handling
            ["driveType"] = "rwd",
		    ["engineAcceleration"] = 200,
		    ["dragCoeff"] = 1.5,
		    ["maxVelocity"] = 300,
		    ["tractionMultiplier"] = 0.7,
		    ["tractionLoss"] = 0.8,
		    ["collisionDamageMultiplier"] = 0.4,
		    ["engineInertia"] = -175,
		    ["steeringLock"] = 75,
		    ["numberOfGears"] = 4,
		    ["suspensionForceLevel"] = 0.8,
		    ["suspensionDamping"] = 0.8,
		    ["suspensionUpperLimit"] = 0.33,
		    ["suspensionFrontRearBias"] = 0.3,
		    ["mass"] = 1800,
		    ["turnMass"] = 3000,
		    ["centerOfMass"] = { 0, -0.2, -0.5 }
        },
    }
}

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
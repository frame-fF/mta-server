
function disableClouds ()
    setCloudsEnabled ( true )    -- Hide the clouds for all players when the resource starts
	setFarClipDistance( 300 )
	setFogDistance(30)
	outputChatBox ( "вкл" )
end
addCommandHandler("555",disableClouds)
--addEventHandler ( "onResourceStart", getResourceRootElement(), disableClouds )

--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy
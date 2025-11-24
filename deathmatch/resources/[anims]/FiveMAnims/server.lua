addEvent ("onCustomAnimationSet", true )
addEventHandler ("onCustomAnimationSet", root,
    function ( player, blockName, animationName )
        SetAnimation ( player, blockName, animationName )
        triggerClientEvent ( synchronizationPlayers, "onClientCustomAnimationSet", player, blockName, animationName ) 
    end 
)

function SetAnimation ( player, blockName, animationName )
    if not playerAnimations[ player ] then playerAnimations[ player ] = {} end 
    if blockName == false then
        playerAnimations[ player ].current = nil
    else
        playerAnimations[ player ].current = { blockName, animationName }
    end 
end 


-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy
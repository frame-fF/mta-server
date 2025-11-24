
-- Her gün yeni scriptler paylaşıyoruzsitemizi takipte kalın.

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy

local ifp = engineLoadIFP( "lean-anim.ifp", "lean" )

addEvent( "lean", true )
addEventHandler( "lean", root,
	function(enable)
		if (enable) then setPedAnimation(source, "lean", "leanIDLE", -1, false, false)
		else setPedAnimation(source)
		end		
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent("onClientSync", resourceRoot)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if ifp then
			for _,player in ipairs(getElementsByType("player")) do
				local _, lean = getPedAnimation(player)
				if (lean == "leanIDLE") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
	end
)


-- Her gün yeni scriptler paylaşıyoruzsitemizi takipte kalın.

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy
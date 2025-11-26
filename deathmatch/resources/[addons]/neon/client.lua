-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy


GUIEditor = {
    button = {},
    window = {},
    label = {}
}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        GUIEditor.window[1] = guiCreateWindow(0.41, 0.17, 0.19, 0.60, "Neon Panel", true)
        guiWindowSetMovable(GUIEditor.window[1], false)
        guiWindowSetSizable(GUIEditor.window[1], false)
        guiSetAlpha(GUIEditor.window[1], 0.85)
        guiSetProperty(GUIEditor.window[1], "CloseButtonEnabled", "False")
        guiSetProperty(GUIEditor.window[1], "CaptionColour", "FF1EB8AF")

        GUIEditor.button[1] = guiCreateButton(0.07, 0.19, 0.86, 0.06, "Kırmızı", true, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(0.07, 0.48, 0.86, 0.06, "Altın", true, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(0.07, 0.58, 0.86, 0.06, "Pembe", true, GUIEditor.window[1])
        GUIEditor.button[4] = guiCreateButton(0.07, 0.90, 0.86, 0.06, "Neon Kaldır", true, GUIEditor.window[1])
        GUIEditor.button[5] = guiCreateButton(0.07, 0.29, 0.86, 0.06, "Mavi", true, GUIEditor.window[1])
        GUIEditor.button[6] = guiCreateButton(0.07, 0.38, 0.86, 0.06, "Yeşil", true, GUIEditor.window[1])
        GUIEditor.button[7] = guiCreateButton(0.07, 0.68, 0.86, 0.06, "Beyaz", true, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(0.23, 0.07, 0.62, 0.04, "Renk Seçin!", true, GUIEditor.window[1])
        guiSetFont(GUIEditor.label[1], "clear-normal")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
		guiSetVisible(GUIEditor.window[1], false)
    end
)


function showWindow()
	guiSetVisible(GUIEditor.window[1], true)
	showCursor(true)
end
addEvent("showWindow", true)
addEventHandler("showWindow", getRootElement(), showWindow)



function onClickRegister(button,state)
	if(button == "left" and state == "up") then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (source == GUIEditor.button[1]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 1)
		end
		if (source == GUIEditor.button[2]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 4)
		end
		if (source == GUIEditor.button[3]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 5)
		end
		if (source == GUIEditor.button[7]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 6)
		end
		if (source == GUIEditor.button[5]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 2)
		end
		if (source == GUIEditor.button[6]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", 3)
		end
		if (source == GUIEditor.button[4]) then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			setElementData(vehicle,"neony", false)
		end
	end
end
addEventHandler("onClientGUIClick",resourceRoot,onClickRegister)

-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
local function onResourceStartPlay()
    resetMapInfo()
    iprint("-------------Resource started-------------")
end

addEventHandler("onResourceStart", resourceRoot, onResourceStartPlay)


-- สร้างตัวแปรสำหรับเก็บ GUI elements
local loginWindow, usernameEdit, passwordEdit, loginButton, registerButton
local usernameLabel, passwordLabel

local function createLoginGUI()
    -- ถ้าหน้าต่างถูกสร้างไว้แล้ว ไม่ต้องสร้างซ้ำ
    if loginWindow and isElement(loginWindow) then return end

    -- คำนวณตำแหน่งกลางจอ
    local sWidth, sHeight = guiGetScreenSize()
    local winWidth, winHeight = 350, 250 
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2

    -- สร้างหน้าต่าง
    loginWindow = guiCreateWindow(winX, winY, winWidth, winHeight, "Login", false)
    
    -- Username
    usernameLabel = guiCreateLabel(35, 30, 280, 20, "Username:", false, loginWindow) 
    guiLabelSetHorizontalAlign(usernameLabel, "center", false) -- จัดข้อความให้อยู่กึ่งกลาง
    
    usernameEdit = guiCreateEdit(35, 55, 280, 25, "", false, loginWindow) 

    -- Password
    passwordLabel = guiCreateLabel(35, 85, 280, 20, "Password:", false, loginWindow)
    guiLabelSetHorizontalAlign(passwordLabel, "center", false) -- จัดข้อความให้อยู่กึ่งกลาง
    
    passwordEdit = guiCreateEdit(35, 110, 280, 25, "", false, loginWindow)
    guiEditSetMasked(passwordEdit, true) -- ซ่อนรหัสผ่าน

    -- Buttons (ปรับตำแหน่ง Y ลงมา)
    loginButton = guiCreateButton(35, 175, 135, 25, "Login", false, loginWindow) 
    
    registerButton = guiCreateButton(180, 175, 135, 25, "Register", false, loginWindow) 

    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Login (ใช้ onGuiClick)
    addEventHandler("onClientGUIClick", loginButton,
        function()
            local username = guiGetText(usernameEdit)
            local password = guiGetText(passwordEdit)

            if username ~= "" and password ~= "" then
                triggerServerEvent("guiLoginAttempt", localPlayer, username, password)
            else
                outputChatBox("กรุณากรอกชื่อผู้ใช้และรหัสผ่าน")
            end
        end,
    false)
    
    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Register (ใช้ onGuiClick)
    addEventHandler("onClientGUIClick", registerButton,
        function()
            local username = guiGetText(usernameEdit)
            local password = guiGetText(passwordEdit)

            if username ~= "" and password ~= "" then
                triggerServerEvent("guiRegisterAttempt", localPlayer, username, password)
            else
                
            end
        end,
    false)

    -- แสดงเมาส์
    showCursor(true)
end

local function hideLoginGUI()
    if loginWindow and isElement(loginWindow) then
        destroyElement(loginWindow) 
        loginWindow = nil 
    end
    showCursor(false) 
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        createLoginGUI()
    end
)

addEventHandler("onClientPlayerSpawn", localPlayer,
    function()
        hideLoginGUI()
    end
)
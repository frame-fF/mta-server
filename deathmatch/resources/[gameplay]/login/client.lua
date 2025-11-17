loadstring(exports.dgs:dgsImportFunction())()

-- สร้างตัวแปรสำหรับเก็บ GUI elements
local loginWindow, usernameEdit, passwordEdit, loginButton, registerButton, errorLabel
local usernameLabel, passwordLabel

local function createLoginGUI()
    -- ถ้าหน้าต่างถูกสร้างไว้แล้ว ไม่ต้องสร้างซ้ำ
    if loginWindow and isElement(loginWindow) then return end

    -- คำนวณตำแหน่งกลางจอ
    local sWidth, sHeight = guiGetScreenSize()
    local winWidth, winHeight = 350, 220
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2

    -- สร้างหน้าต่าง
    loginWindow = dgsCreateWindow(winX, winY, winWidth, winHeight, "Login", false)
    
    usernameLabel = dgsCreateLabel(35, 20, 280, 20, "Username:", false, loginWindow) 
    dgsSetProperty(usernameLabel, "horizontalAlign", "center") 
    
    usernameEdit = dgsCreateEdit(35, 40, 280, 25, "", false, loginWindow) 


    passwordLabel = dgsCreateLabel(35, 70, 280, 20, "Password:", false, loginWindow)
    dgsSetProperty(passwordLabel, "horizontalAlign", "center")
    
    passwordEdit = dgsCreateEdit(35, 90, 280, 25, "", false, loginWindow)
    dgsEditSetMasked(passwordEdit, true) -- ซ่อนรหัสผ่าน

    loginButton = dgsCreateButton(35, 145, 135, 25, "Login", false, loginWindow) 
    
    registerButton = dgsCreateButton(180, 145, 135, 25, "Register", false, loginWindow) 

    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Login
    addEventHandler("onDgsMouseClick", loginButton,
        function(button, state)
            if button == "left" and state == "up" then
                local username = dgsGetText(usernameEdit)
                local password = dgsGetText(passwordEdit)

                if username ~= "" and password ~= "" then
                    triggerServerEvent("guiLoginAttempt", localPlayer, username, password)
                else
                    outputChatBox("Please enter both username and password.")
                end
            end
        end,
    false)
    
    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Register
    addEventHandler("onDgsMouseClick", registerButton,
        function(button, state)
            if button == "left" and state == "up" then
                local username = dgsGetText(usernameEdit)
                local password = dgsGetText(passwordEdit)

                if username ~= "" and password ~= "" then
                    dgsSetText(errorLabel, "") 
                    triggerServerEvent("guiRegisterAttempt", localPlayer, username, password)
                else
                    dgsSetText(errorLabel, "กรุณากรอกชื่อผู้ใช้และรหัสผ่าน")
                end
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
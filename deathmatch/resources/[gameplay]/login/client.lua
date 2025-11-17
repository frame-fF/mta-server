loadstring(exports.dgs:dgsImportFunction())()

-- สร้างตัวแปรสำหรับเก็บ GUI elements
local loginWindow, usernameEdit, passwordEdit, loginButton

local function createLoginGUI()
    -- ถ้าหน้าต่างถูกสร้างไว้แล้ว ไม่ต้องสร้างซ้ำ
    if loginWindow and isElement(loginWindow) then return end

    -- คำนวณตำแหน่งกลางจอ
    local sWidth, sHeight = guiGetScreenSize()
    local winWidth, winHeight = 300, 160
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2

    -- สร้างหน้าต่าง
    loginWindow = dgsCreateWindow(winX, winY, winWidth, winHeight, "Login", false)
    dgsCreateLabel(10, 20, 280, 20, "Username:", false, loginWindow)
    usernameEdit = dgsCreateEdit(10, 40, 280, 25, "", false, loginWindow)

    dgsCreateLabel(10, 70, 280, 20, "Password:", false, loginWindow)
    passwordEdit = dgsCreateEdit(10, 90, 280, 25, "", false, loginWindow)
    dgsEditSetMasked(passwordEdit, true) -- ซ่อนรหัสผ่าน

    loginButton = dgsCreateButton(10, 125, 280, 25, "Login", false, loginWindow)

    -- เพิ่มอีเวนต์เมื่อกดปุ่ม
    addEventHandler("onDgsMouseClick", loginButton,
        function(button, state)
            if button == "left" and state == "up" then
                local username = dgsGetText(usernameEdit)
                local password = dgsGetText(passwordEdit)

                if username ~= "" and password ~= "" then
                    -- ส่งข้อมูลไปที่เซิร์ฟเวอร์
                    triggerServerEvent("guiLoginAttempt", localPlayer, username, password)
                else
                    outputChatBox("กรุณากรอกชื่อผู้ใช้และรหัสผ่าน", 255, 100, 100)
                end
            end
        end,
    false)

    -- แสดงเมาส์
    showCursor(true)
end

local function hideLoginGUI()
    if loginWindow and isElement(loginWindow) then
        destroyElement(loginWindow) -- ทำลายหน้าต่าง
        loginWindow = nil -- ล้างค่าตัวแปร
    end
    showCursor(false) -- ซ่อนเมาส์
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        -- สร้าง GUI สำหรับล็อกอิน
        createLoginGUI()
    end
)

-- ซ่อน GUI เมื่อผู้เล่นเกิด (แสดงว่าล็อกอินสำเร็จแล้ว)
addEventHandler("onClientPlayerSpawn", localPlayer,
    function()
        hideLoginGUI()
    end
)
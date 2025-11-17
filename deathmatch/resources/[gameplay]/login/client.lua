loadstring(exports.dgs:dgsImportFunction())()

-- สร้างตัวแปรสำหรับเก็บ GUI elements
local loginWindow, usernameEdit, passwordEdit, loginButton, registerButton, errorLabel

local function createLoginGUI()
    -- ถ้าหน้าต่างถูกสร้างไว้แล้ว ไม่ต้องสร้างซ้ำ
    if loginWindow and isElement(loginWindow) then return end

    -- คำนวณตำแหน่งกลางจอ
    local sWidth, sHeight = guiGetScreenSize()
    local winWidth, winHeight = 350, 220 -- เพิ่มความสูงเล็กน้อย
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2

    -- สร้างหน้าต่าง
    loginWindow = dgsCreateWindow(winX, winY, winWidth, winHeight, "Login", false)
    dgsCreateLabel(10, 20, 280, 20, "Username:", false, loginWindow)
    usernameEdit = dgsCreateEdit(10, 40, 280, 25, "", false, loginWindow)

    dgsCreateLabel(10, 70, 280, 20, "Password:", false, loginWindow)
    passwordEdit = dgsCreateEdit(10, 90, 280, 25, "", false, loginWindow)
    dgsEditSetMasked(passwordEdit, true) -- ซ่อนรหัสผ่าน

    -- สร้าง Label สำหรับแจ้งเตือน (ใหม่)
    errorLabel = dgsCreateLabel(10, 120, 280, 20, "", false, loginWindow)
    dgsSetProperty(errorLabel, "textColor", tocolor(255, 100, 100)) -- ตั้งค่าสี
    dgsSetProperty(errorLabel, "horizontalAlign", "center") -- จัดกึ่งกลาง

    -- สร้างปุ่ม Login (ขยับ Y ลงมา)
    loginButton = dgsCreateButton(10, 145, 135, 25, "Login", false, loginWindow)
    
    -- สร้างปุ่ม Register (ขยับ Y ลงมา)
    registerButton = dgsCreateButton(155, 145, 135, 25, "Register", false, loginWindow)

    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Login
    addEventHandler("onDgsMouseClick", loginButton,
        function(button, state)
            if button == "left" and state == "up" then
                local username = dgsGetText(usernameEdit)
                local password = dgsGetText(passwordEdit)

                if username ~= "" and password ~= "" then
                    dgsSetText(errorLabel, "") -- ล้างข้อความแจ้งเตือน
                    -- ส่งข้อมูลไปที่เซิร์ฟเวอร์
                    triggerServerEvent("guiLoginAttempt", localPlayer, username, password)
                else
                    -- แสดงข้อความแจ้งเตือนใน GUI แทน
                    dgsSetText(errorLabel, "กรุณากรอกชื่อผู้ใช้และรหัสผ่าน")
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
                    dgsSetText(errorLabel, "") -- ล้างข้อความแจ้งเตือน
                    -- ส่งข้อมูลการสมัครสมาชิกไปที่เซิร์ฟเวอร์
                    triggerServerEvent("guiRegisterAttempt", localPlayer, username, password)
                else
                    -- แสดงข้อความแจ้งเตือนใน GUI แทน
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
        destroyElement(loginWindow) -- ทำลายหน้าต่าง (errorLabel จะถูกทำลายไปด้วย)
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
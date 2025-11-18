local registerWindow, emailEdit, usernameEdit, passwordEdit, password2Edit, loginButton, registerButton 
local emailLabel, usernameLabel, passwordLabel, password2Label


local function hideRegisterGUI()
    if registerWindow and isElement(registerWindow) then
        destroyElement(registerWindow) 
        registerWindow = nil 
    end
    showCursor(false) 
end

local function createRegisterGUI()
    if registerWindow and isElement(registerWindow) then return end

    local sWidth, sHeight = guiGetScreenSize()
    
    -- ## 1. กำหนดค่าคงที่สำหรับขนาดและระยะห่าง ##
    local winWidth, winHeight = 350, 340 -- (เพิ่มความสูงหน้าต่างเล็กน้อย)
    local colWidth = 280 -- ความกว้างของช่องกรอกและปุ่ม
    local padding = 15  -- ระยะห่างระหว่างองค์ประกอบ
    local itemHeight = 28 -- ความสูงของช่องกรอก/ปุ่ม
    local labelHeight = 20 -- ความสูงของตัวหนังสือ

    -- คำนวณตำแหน่งกลางจอ
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2
    local colX = (winWidth - colWidth) / 2 -- คำนวณ X กึ่งกลางสำหรับองค์ประกอบ

    -- สร้างหน้าต่าง
    registerWindow = guiCreateWindow(winX, winY, winWidth, winHeight, "Register", false)

    -- ## 2. ใช้ตัวแปร 'currentY' เพื่อติดตามตำแหน่งแนวตั้ง ##
    local currentY = padding * 2 -- เริ่มต้นที่ระยะห่างจากขอบบน

    -- Email
    emailLabel = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Email:", false, registerWindow)
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    emailEdit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, registerWindow)
    currentY = currentY + itemHeight + padding -- ขยับ Y ลงมา (เว้นระยะห่าง)
    -- Username
    usernameLabel = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Username:", false, registerWindow)
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    usernameEdit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, registerWindow)
    currentY = currentY + itemHeight + padding -- ขยับ Y ลงมา (เว้นระยะห่าง)
    -- Password
    passwordLabel = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Password:", false, registerWindow)
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    passwordEdit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, registerWindow)
    guiEditSetMasked(passwordEdit, true)
    currentY = currentY + itemHeight + padding -- ขยับ Y ลงมา (เว้นระยะห่าง)
    -- Confirm PasswordOld
    password2Label = guiCreateLabel(colX, currentY, colWidth, labelHeight, "Confirm Password:", false, registerWindow)
    currentY = currentY + labelHeight + (padding / 2) -- ขยับ Y ลงมา
    password2Edit = guiCreateEdit(colX, currentY, colWidth, itemHeight, "", false, registerWindow)
    guiEditSetMasked(password2Edit, true)   
    currentY = currentY + itemHeight + (padding * 2) -- ขยับ Y ลงมา (เว้นระยะห่างเยอะหน่อย)

    -- Buttons
    local buttonWidth = (colWidth - padding) / 2 -- คำนวณความกว้างปุ่ม 2 ปุ่ม

    registerButton = guiCreateButton(colX, currentY, buttonWidth, itemHeight, "Register", false, registerWindow)
    -- เพิ่มอีเวนต์เมื่อกดปุ่ม Register
    addEventHandler("onClientGUIClick", registerButton,
        function()
            local email = guiGetText(emailEdit)
            local username = guiGetText(usernameEdit)
            local password = guiGetText(passwordEdit)
            local password2 = guiGetText(password2Edit)

            if email == "" or username == "" or password == "" or password2 == "" then
                outputChatBox("Please fill in all fields.")
                return
            end
            triggerServerEvent("guiRegisterAttempt", localPlayer, username, email, password, password2)
        end,
    false)

    -- แสดงเมาส์
    showCursor(true)
end



addEvent( "openRegisterGUI", true )
addEventHandler( "openRegisterGUI", localPlayer, createRegisterGUI)
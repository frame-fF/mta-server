local registerWindow, usernameEdit, passwordEdit, loginButton, registerButton
local usernameLabel, passwordLabel

local function createRegisterGUI()
    if registerWindow and isElement(registerWindow) then return end

    local sWidth, sHeight = guiGetScreenSize()
    
    -- ## 1. กำหนดค่าคงที่สำหรับขนาดและระยะห่าง ##
    local winWidth, winHeight = 350, 250 -- (เพิ่มความสูงหน้าต่างเล็กน้อย)
    local colWidth = 280 -- ความกว้างของช่องกรอกและปุ่ม
    local padding = 15  -- ระยะห่างระหว่างองค์ประกอบ
    local itemHeight = 28 -- ความสูงของช่องกรอก/ปุ่ม
    local labelHeight = 20 -- ความสูงของตัวหนังสือ

    -- คำนวณตำแหน่งกลางจอ
    local winX, winY = (sWidth - winWidth) / 2, (sHeight - winHeight) / 2
    local colX = (winWidth - colWidth) / 2 -- คำนวณ X กึ่งกลางสำหรับองค์ประกอบ

    -- สร้างหน้าต่าง
    registerWindow = guiCreateWindow(winX, winY, winWidth, winHeight, "Register", false)

end
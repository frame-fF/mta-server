function get_account(source, username, password)
    local url = get("base_url") .. '/api/player/login/'
    local sendOptions = {
        connectionAttempts = 3,
        connectTimeout = 5000,
        method = "POST",
        formFields = {
            username = username,
            password = password,
        }
    }
    fetchRemote(url, sendOptions, function(data, info)
        if info.statusCode == 200 then

            -- Parse JSON data
            local result = fromJSON(data)
            setElementData(source, "results", result)
            
            -- เช็คว่าเคยร์มีอยู่ในระบบหรือไม่
            local account = getAccount(username, password)
            if (account ~= false) then
                -- ถ้ามีแล้วให้ทำการล็อกอิน
                logIn(source, account, password)
            else
                -- ถ้าไม่มีให้สร้างบัญชีใหม่แล้วทำการล็อกอิน
                local new_account = addAccount(username, password)
                logIn(source, new_account, password)
            end
        else
            outputChatBox('Error: ' .. data, source, 255, 255, 0)
        end
    end)
end

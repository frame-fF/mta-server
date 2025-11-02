local function loginPlayer(thePlayer, command, username, password)
    local account = getAccount(username, password)                         -- Return the account
    if (account ~= false) then                                             -- If the account exists.
        logIn(thePlayer, account, password) 
    else
        outputChatBox("Wrong username or password!", thePlayer, 255, 255, 0) -- Output they got the details wrong.
    end
end

addCommandHandler("login", loginPlayer)

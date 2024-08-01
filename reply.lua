
local sampEvents = require("lib.samp.events")
local savedPhoneNumber = nil

function main()
    repeat
        wait(0)
    until isSampAvailable()

    sampAddChatMessage(" ", -1)
    sampAddChatMessage(" ", -1)
    sampAddChatMessage("{1867d3} Reply CMD {ffffff} by {1867d3} hApY.eNd", -1)
    sampAddChatMessage("{1867d3} -> {ffffff}Comenzi disponibile: {1867d3}[/reply]", -1)
    sampAddChatMessage(" ", -1)
    sampAddChatMessage(" ", -1)

    sampRegisterChatCommand("reply", cmdReply)

    while true do
        wait(0)
    end
end

function sendError(message)
    sampAddChatMessage("{1867d3}ReplyCMD: {FFFFFF} " .. message, -1)
end

function sendInfo(message)
    sampAddChatMessage("{00FF00}ReplyCMD: {FFFFFF} " .. message, -1)
end

function stripColorCodes(text)
    return text:gsub("{%x%x%x%x%x%x}", "")
end

function sampEvents.onServerMessage(color, message)
    if message:match("SMS from ") then
        message = stripColorCodes(message)
        local number = message:match("SMS from [%w%[%]_%.%@%(%)]+ %((%d+)%)")
        if number and #number >= 4 then
            savedPhoneNumber = number
            --sendInfo("Numărul de telefon a fost salvat: " .. savedPhoneNumber)
        end
    end
    return true
end

function cmdReply(args)
    if not savedPhoneNumber then
        sendError("Nu ai niciun numar salvat pentru a raspunde.")
        return 
    end

    if args == "" then
        sendError("/reply <mesaj>")
        return 
    end

    sampSendChat("/sms " .. savedPhoneNumber .. " " .. args)
    --sendInfo("SMS trimis la " .. savedPhoneNumber .. " cu mesajul: " .. args)
end

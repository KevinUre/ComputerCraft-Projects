MessageRegister = {}

function CheckRegisters()
    for key, message in pairs(MessageRegister) do
        if IsExpired(message) then
            MessageRegister[key].Expired = true
            MessageRegister[key].Data = "???"
        end
    end
end

function GetCurrentSeconds()
    return os.time() * 50
end

function IsExpired(message)
    return ((message.SentAt + message.ExpiresIn) % (23.999 * 50)) < GetCurrentSeconds()
end

function RegisterMessageListener(name)
    MessageRegister[name] = {}
    MessageRegister[name].Name = name
    MessageRegister[name].Data = "???"
    MessageRegister[name].SentAt = 0
    MessageRegister[name].ExpiresIn = 0
    MessageRegister[name].Expired = true
end

MessagingProtocol = "ReactorInternalNetwork"

function Listener()
    while true do
        local senderId, message, protocol = rednet.receive(MessagingProtocol)
        if MessageRegister[message.Name] ~= nil then
            MessageRegister[message.Name].Data = message.Data
            MessageRegister[message.Name].SentAt = message.SentAt
            MessageRegister[message.Name].ExpiresIn = message.ExpiresIn
            MessageRegister[message.Name].Expired = false
        end
        sleep(0)
    end
end

function InitMessageApi(side)
    rednet.open(side);
end

function SendMessage(name, data, expiresIn)
    local message = {}
    message.Name = name
    message.Data = data
    message.SentAt = GetCurrentSeconds()
    message.ExpiresIn = expiresIn
    rednet.broadcast(message,MessagingProtocol);
end
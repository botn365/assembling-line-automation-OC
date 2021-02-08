local component = require("component")
local Event = require("event")
local serialization = require("serialization")
local thread = require("thread")
local modem = component.modem
local gpu = component.gpu

REMOTE_PORT = 201
CHAT = {}
CHAT_SIZE = 40
CHAT_CURENT = 0
STATIC_MSG = ""
local w, h = gpu.getResolution()

modem.open(404)


function sndMSG(msg)
    modem.broadcast(REMOTE_PORT,table.unpack(msg))
    modem.broadcast(399,table.unpack(msg))
end

function recive()
    while true do
        local event = {Event.pull("modem_message")}
        table.remove(event,6)
        if event[6] == "print" then
            say(event[8])
        elseif event[6] == "set_static" then
            STATIC_MSG = event[8]
            Event.push("update")
        elseif event[6] == "print_table" then
            local table = serialization.unserialize(event[8])
            local printLine = ""
            for k,server in pairs(table) do
                local toPrint = ""
                local addSep = false
                for field,value in pairs(server) do
                    if addSep then
                        toPrint = toPrint.." | "
                    else
                        addSep = true
                    end
                    toPrint = toPrint..field ..": "..tostring(value)
                end
                local printLen = printLine:len()
                if (printLen + toPrint:len() + 5)> w then
                    say(printLine)
                    printLine = toPrint
                elseif printLen > 0 then
                    printLine = printLine.." <|> "..toPrint
                else
                    printLine = toPrint
                end
                --{k,v.address,v.name}
            end
            say(printLine)
        end
    end
end

function say(text,toTerminal)
    toTerminal = toTerminal or true
    gpu.set(1,20,""..CHAT_CURENT)
    CHAT[CHAT_CURENT] = text
    if toTerminal then
        local lineIndex = 0
        for i = 0, CHAT_SIZE-1 do
            lineIndex = CHAT_CURENT + i +1
            lineIndex = lineIndex%CHAT_SIZE
            gpu.fill(1,i+3,w,1," ")
            local line = CHAT[lineIndex]
            if line == nil then
                line = ""
            end
            gpu.set(1,i+3,line)
        end
    end
    CHAT_CURENT = (CHAT_CURENT+1)%CHAT_SIZE
end

function processCommand(msg)
    sndMSG({"command",4,msg})
end

function callSafe(recive)
    local a, b = pcall(recive)
    if not a then
        print(b)
    end
end


local msgThread = thread.create(callSafe,recive)

gpu.fill(1, 1, w, h, " ")
os.sleep(0.1)
Event.pull(0)

local loop = true
while loop do
    local selected = 0
    local name = ""
    gpu.fill(1,CHAT_SIZE +3, w, 1, " ")
    repeat
    local id,_,ch,arrow = Event.pull()
        if id == "key_down" and ch ~= 13 and ch > 31 then
            if ch < 200 then
                name = name..string.char(ch)
                gpu.set(1,CHAT_SIZE +3,STATIC_MSG..name)
            end
        elseif ch == 0 then
            if arrow == 200 then

            end
        elseif id == "key_down" and ch == 8 then
            name = string.sub(name, 0, #name - 1)
            gpu.set(#name+1+#STATIC_MSG,CHAT_SIZE +3," ")
        elseif id == "interrupted" then
            loop = false
            break
        elseif id == "update" then
            gpu.set(1,CHAT_SIZE +3,STATIC_MSG..name)
        end
    until ch == 13 and id == "key_up"
    --say(STATIC_MSG..name)
    if not loop then break end
    gpu.fill(1, 1, w, 1, " ")
    STATIC_MSG = ""
    processCommand(name)
end

msgThread:kill()

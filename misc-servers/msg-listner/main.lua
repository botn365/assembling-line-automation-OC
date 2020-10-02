component = require("component")
event = require("event")
thread = require("thread")
modem = component.modem

local driveLoc = "/mnt/672/log.txt"
local linesMax = 2000
local lines = 0
local events = {}
--modem.open(210)
--modem.open(200)
--modem.open(201)
--modem.open(404)
modem.open(399)
print("listening")




function t(...)
    print(...)
    local tb = {...}
    if tb[6] ~= "fluid_table" and tb[6] ~= "get_fluids" then
        events[#events+1] = {...}
    end
    --events[#events+1] = {...}
end

function toNilString(table)
    local string = ""
    for k,v in pairs(table) do
        string = string.."   "..nilString(v)
    end
    string = string.."\n"
    return string
end

function nilString(In)
    if In == nil then
        return "nil"
    else
        return tostring(In)
    end
end

function storeEvents()
    print("store")
    local ev = events
    events = {}
    local file 
    if lines > linesMax then
        file = io.open(driveLoc,"w")
    else
        file = io.open(driveLoc,"a")
    end
    for k,v in pairs(ev) do
        local toWrite = toNilString(v)
        file:write(toWrite)
    end
    file:close()
    print("done")
end

function printEvent()
    while true do
        local ev = {event.pull("modem_message")}
        thread.create(t,table.unpack(ev))
    end
end
event.listen("modem_message",t)
--thread.create(printEvent)
while true do
    os.sleep(30)
    storeEvents()
end
component = require("component")
event = require("event")
thread = require("thread")
filesystem =  require("filesystem")

modem = component.modem

local driveLoc1 = "/mnt/672/log1.txt"
local driveLoc2 = "/mnt/672/log2.txt"
local drive = {driveLoc1,driveLoc2}
local used = 1
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
    local fileName = drive[used]
    local size = filesystem.size(file)
    local reset = false
    if size > 2000000 then
        size = (used%2)+1
        file = drive[used]
        reset = true
    end

    if reset then
        filesystem.remove(fileName)
        file = io.open(fileName,"w")
    else
        file = io.open(fileName,"a")
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
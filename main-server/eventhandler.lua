local event = require("event")
local thread = require("thread")

local eventhandler = {}
eventhandler.defauld = 0
eventhandler.chanennels = {}
eventhandler.debug = false
--local listnerThread = thread.create(listner.run,sendBack)
function eventhandler.run(defauld,modem,...)
    eventhandler.chanennels[200] = defauld
    for k,v in pairs({...}) do
        print("add non change event",v[1],v[2])
        eventhandler.chanennels[v[1]] = v[2]
    end
    while true do
        local event = {event.pull("modem_message")}
        if modem.address == event[6] then
            table.remove(event,6)
            thread.create(eventhandler.sendEventSave,event)
        end
        if event[4] < 500 then
            thread.create(eventhandler.sendEventSave,event)
        end
    end
end

function eventhandler.sendEventSave(event)
    local a,b = pcall(eventhandler.sendEvent,event)
    if a == false then
        print(b)
    end
end

function eventhandler.sendEvent(event)
    if event[4] == 200 or event[7] == 0 then
        eventhandler.chanennels[200](event)
    else
        local eventFunc = eventhandler.chanennels[event[7]]
        if eventFunc ~= nil then
            eventFunc(event)
            return
        end
        return
    end
    eventhandler.chanennels[200](event)
end

function eventhandler.addChanelRandome(evenFunction)
    local msgId = 0
    repeat
        if msgId ~= 0 then
            os.sleep(0.05)
        end
        msgId = math.random(500, 10000)
    until eventhandler.addChannel(msgId,evenFunction)
    return msgId
end

function eventhandler.addChannel(channelNumber,evenFunction)
    if channelNumber < 500 then
        return false
    end
    if eventhandler.chanennels[channelNumber] == nil then
        eventhandler.chanennels[channelNumber] = evenFunction
        if eventhandler.debug then
            print("added channel",channelNumber,print(evenFunction),#eventhandler.chanennels)
        end
        return true
    end
    return false
end

function eventhandler.removeChannel(channelNumber)
    if channelNumber < 500 then
        return false
    end
    eventhandler.chanennels[channelNumber] = nil
    if eventhandler.debug then
        print("remove event",channelNumber,#eventhandler.chanennels)
    end
end

return eventhandler



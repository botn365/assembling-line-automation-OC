package.loaded.eventhandler=nil
local serialization = require("serialization")
local event = require("event")
local server = {}

LISTNER_ADDRESS = "3e2090dd-43cc-4454-b6bd-a9ad1c8abc79"

function server.newServer(name,address,port,index,func,eventHandler)
    local t = {}
    t.name = name or ""
    t.address = address or ""
    t.port = port or 0
    t.index = index or 0
    t.func = func or ""
    t.initialised = false
    t.access = true
    t.eventHandler =  eventHandler or nil
    function t.sendMSG(modem,msg)
        --modem.broadcast(t.port,table.unpack(msg))
        modem.send(t.address,t.port,t.address,table.unpack(msg))
        modem.broadcast(399,table.unpack(msg))
    end
    function t.checkWorking(modem,success)
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        local eventId = t.getEventID()
        t.sendMSG(modem, {"awake",msgId})
        local Event = {event.pull(5,eventId)}
        if Event[1] == eventId and Event[6] == "awake_conf" then
            success.s = true
        else
            success.s = false
            success.error = Event[8]
        end
        t.eventHandler.removeChannel(msgId)
    end
    function t.pullEvent(Event)
        local evetnId = t.getEventID()
        table.remove(Event,1)
        event.push(evetnId,table.unpack(Event))
    end
    function t.getEventID()
        return string.gsub(t.address,"-","_")
    end
    function t.toString()
        local valueTable = {name=t.name,address=t.address,port=t.port,index=t.index,func=t.func,initialised=t.initialised}
        return serialization.serialize(valueTable)
    end
    function t.fromString(input,eventHandler)
        local valueTable = serialization.unserialize(input)
        t.name = valueTable.name
        t.address = valueTable.address
        t.port = valueTable.port
        t.index = valueTable.index
        t.func = valueTable.func
        t.initialised = valueTable.initialised
        t.eventHandler = eventHandler
    end
    function t.fromStringSecure(string)
        local ran = pcall(t.fromString,string)
        if ran then
            return true
        else
            return false
        end
    end
    function t.events(event)
        t.access = false
        if t.event ~= nil then
            t.event[#t.event] = event
        else
            t.event = {event}
        end
        t.access = true
    end
    function t.loadDataBase(modem,mapItem,success)
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        local eventId = t.getEventID()
        t.sendMSG(modem,{"set_data",msgId,mapItem})
        local attemptsLoadData = 0
        while true do
            local Event = {event.pull(10,eventId)}
            if Event[6] == "load_data_failure" then
                if attemptsLoadData > 10 then
                    success.s = false
                    success.error = "load_data_failure"
                    t.eventHandler.removeChannel(msgId)
                    return
                else
                    attemptsLoadData= attemptsLoadData + 1
                    os.sleep(0.5)
                    t.sendMSG(modem,{"set_data",msgId,mapItem})
                end
            elseif Event[6] == "load_data_sucsses" then
                success.s = true
                t.eventHandler.removeChannel(msgId)
                return
            end
        end
    end
    function t.waitForeMsg(msgName)
        while true do
            while t.access == false do
                os.sleep(0.05)
            end
            if t.event ~= nil then
                for k,v in pairs(t.event) do
                    for L,E in pairs(msgName) do
                        if v[6] == E then
                            local msg = t.event[k]
                            t.event[k] = nil
                            return msg
                        end
                    end
                end
            end
            os.sleep(0.05)
        end
    end
    function t.load(modem,itemsPos,itemAmount,success)
        local msgId = t.eventHandler.addChanelRandome(t.events)
        t.sendMSG(modem, {"load_assline",msgId})
        local msg = t.waitForeMsg({"start_loading","not_configured"})
        if msg[6] == "not_configured" then
            success.s = false
            success.error = "not_configured"
            t.eventHandler.removeChannel(msgId)
            return
        end
        local itemPosSer = serialization.serialize(itemsPos)
        local itemAmountSer = serialization.serialize(itemAmount)
        t.sendMSG(modem, {"load_items",msgId,itemPosSer,itemAmountSer})
        msg = t.waitForeMsg({"load_items_sucsses","load_failure"})
        -- TODO add more details to load failure like which input bus
        if msg[6] == "load_failure" then
            success.s = false
            success.error = "load_failure"
            t.eventHandler.removeChannel(msgId)
            return
        else
            success.s = true
            t.eventHandler.removeChannel(msgId)
            return
        end
    end
    function t.runAssline(modem,success,msgIdPointer)
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        msgIdPointer.msgId = msgId
        local eventId = t.getEventID()
        t.sendMSG(modem,{"start_assline",msgId})
        local Event = {event.pull(eventId)}
        if Event[6] == "already_on" then
            success.s = true
        elseif Event[6] == "assline_on" then
            success.s = true
        elseif Event[6] == "load_failure" then
            success.s = false
        end
        msgIdPointer.msgId = msgId
    end
    function t.waitForDone(modem,msgId,success)
        local eventId = t.getEventID()
        while true do
            local Event = {event.pull(100,eventId)}
            if Event ~= nil and Event[6] == "crafting_done" then
                break
            end
        end
        t.eventHandler.removeChannel(msgId)
        success.s = true
    end
    return t
end
return server

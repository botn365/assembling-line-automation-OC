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
    function t.addId(modem,id,color)
        if color < 4 then
            return false
        end
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        local eventId = t.getEventID()
        t.sendMSG(modem, {"set_ID",msgId,id,color})
        local Event = {event.pull(eventId)}
        if Event[6] == "id_seted" and Event[8] == true then
            eventHandler.removeChannel(msgId)
            return true
        else
            eventHandler.removeChannel(msgId)
            return false
        end

    end
    function t.getIds(modem)
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        local eventId = t.getEventID()
        t.sendMSG(modem, {"get_IDs",msgId})
        local Event = {event.pull(eventId)}
        if Event[6] == "id_send" then
            return serialization.unserialize(Event[8])
        end
        return nil
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
    function t.load(modem,fluidName,fluidAmount,fluidId,success)
        if t.access == false then
            success.s = false
            return
        end
        t.access = false
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        local eventId = t.getEventID()
        local name = serialization.serialize(fluidName)
        local amount = serialization.serialize(fluidAmount)
        t.sendMSG(modem, {"test",msgId,name,amount,fluidId})
        while true do
            local Event = {event.pull(5,eventId)}
            if Event[6] == "success" then
                t.access = Event[8]
                break
            elseif Event[6] == "bad_id" then
                break
            elseif Event[6] == "bad_color"  then
                break
            elseif Event[6] == "fluids_missing"  then
                break
            elseif Event[6] == "transfer_failed"  then
            end
        end
        success.s = true
        t.eventHandler.removeChannel(msgId)
    end
    function t.getFluids(modem)
        local msgId = t.eventHandler.addChanelRandome(t.pullEvent)
        t.sendMSG(modem, {"get_fluids",msgId})
        local eventId = t.getEventID()
        local Event = {event.pull(eventId)}
        if Event[6] ~= "fluid_table" then
            return nil
        end
        if Event[8] == nil then
            return nil
        end
        local fluidTable = serialization.unserialize(Event[8])
        t.eventHandler.removeChannel(msgId)
        return fluidTable
    end
    return t
end
return server
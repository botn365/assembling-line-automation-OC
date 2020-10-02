component = require("component")
event = require("event")
modem = component.modem

LISTNER_ADDRESS = "3e2090dd-43cc-4454-b6bd-a9ad1c8abc79"
listner = {}
listner.events = {}
listner.canStore = true

function listner.run(aSendBack)
    local sendBack = aSendBack
    while true do
        local event = {event.pull(100)}
        if event[1] ~= nil then
            if event[1] ~= "modem_message" then
                listner.store(event)
            end
            if event[6] == modem.address then
                table.remove(event,6)
                if event[1] == "modem_message" and event[6] == "awake" then
                    sendBack(event)
                else
                    listner.store(event)
                end
            end
        end
    end
end

function listner.store(event)
    while listner.canStore == false do
        os.sleep(0.05)
    end
    listner.events[#listner.events+1] = event
end

function listner.getEvents()
    listner.canStore = false
    local events = listner.events
    listner.events = {}
    listner.canStore = true
    return events
end

function listner.hasEvents()
    if (#listner.events>0) then
        return true
    end
    return false
end

return listner



package.loaded.itemServer=nil
package.loaded.fluidServer=nil
local itemServer = require("itemServer")
local fluidServer = require("fluidServer")
local serialization = require("serialization")
local thread = require("thread")
local assline = {}

function assline.new(index,name,length,eventHandler,fluidId)
    local t = {}
    t.serverList = {}
    t.index = index or 0
    t.name = name or ""
    t.length = length or 0
    t.access = true 
    t.accessEvent = true
    t.initialized = false
    t.error = ""
    t.fluidId = fluidId or 0
    t.eventHandler = eventHandler or nil
    function t.checkWorking(modem)

        local function save(func,modem,success)
            local a,b = pcall(func,modem,success)
            if not a then
                print(b)
            end
        end
        local threads = {}
        local success = {}
        for k,list in pairs(t.serverList) do
            success[#success+1] = {s=false}
            local checkThread = thread.create(save,list.checkWorking,modem,success[#success])
            threads[#threads+1] = checkThread
        end
        thread.waitForAll(threads)
        for k,v in pairs(success) do
            if v.s == false then
                return false
            end
        end

        return true
    end
    function t.toString()
        local serverStringList = {}
        for k,server in pairs(t.serverList) do
            serverStringList[k] = server.toString()
        end
        print(table.unpack(serverStringList))
        local valueTable = {index=t.index,name=t.name,length=t.length,access=t.access,initialized=t.initialized,serverList=serverStringList,fluidId=t.fluidId}
        return serialization.serialize(valueTable)
    end
    function t.fromString(input,eventHandler)
        local valueTable = serialization.unserialize(input)
        t.index = valueTable.index
        t.name = valueTable.name
        t.length = valueTable.length
        t.access = valueTable.access
        t.initialized = valueTable.initialized
        t.eventHandler = eventHandler
        t.fluidId = valueTable.fluidId
        for k,serverString in pairs(valueTable.serverList) do
            local func = serialization.unserialize(serverString).func
            local newServer
            if func == "fluid_server" then
                newServer = fluidServer.newServer()
            elseif func == "item_server" then
                newServer = itemServer.newServer()
            end
            newServer.fromString(serverString,eventHandler)
            t.serverList[k] = newServer
        end
    end
    function t.event(event)
        if event[1] == "modem_message" then
            t.accessEvent = false
            if t.events ~= nil then
                t.events[#t.events+1] = event
            else
                t.events = {event}
            end
            t.accessEvent = true
        end
    end
    function t.waitForeMsg(msgName)
        while true do
            while t.accessEvent == false do
                os.sleep(0.05)
            end
            if t.events ~= nil then
                for k,v in pairs(t.events) do
                    for L,E in pairs(msgName) do
                        if v[6] == E then
                            local msg = t.events[k]
                            t.events[k] = nil
                            return msg
                        end
                    end
                end
            end
            os.sleep(0.05)
        end
    end
    function t.loadItems(modem,server,recipePos,recipeAmount,success)
        --maby use this
    end
    function t.seperateServers()
        local itemServers = {}
        local fluidServers = {}
        for k,v in pairs(t.serverList) do
            if v.func == "fluid_server" then
                fluidServers[#fluidServers+1] = v
            elseif v.func == "item_server" then
                itemServers[#itemServers+1] = v
            end
        end
        return itemServers,fluidServers
    end
    function t.loadFluids(modem,server,fluidNames,fluidAmounts,success)
        while not server.access do
            os.sleep(0.05)
        end
        server.load(modem,fluidNames,fluidAmounts,t.fluidId,success)
    end
    function t.createSafe(...)
        local ran,err = pcall(...)
        if not ran then
            print(err)
        end
    end
    function t.stringNil(In)
        if In == nil then
            return "nil"
        else
            return tostring(In)
        end
    end
    function t.load(recipe,amount,modem,success)
        os.sleep(0.5)
        if t.access == false then
            success.s = false
            success.error = "already accessed"
            t.error = success.error
            return
        end
        t.access = false
        -- genrate msgID
        local msgId = t.eventHandler.addChanelRandome(t.event)

        --get sevrers
        local itemServers,fluidServers = t.seperateServers()
        fluidServers = fluidServers[1]

        --check if servers are availble)
        local checkThreads = {}
        local checkSuccess = {}
        local order = {}
        for k,v in pairs(itemServers) do
            checkSuccess[#checkSuccess+1] = {s=false}
            checkThreads[#checkThreads+1] = thread.create(t.createSafe,v.checkWorking,modem,checkSuccess[#checkSuccess])
            order[#order+1] = v.address
        end
        -- not checking for the fluid one sisne multiple asslines use it
        thread.waitForAll(checkThreads)
        for k,v in pairs(checkSuccess) do
            if not v.s then
                print(order[k])
                success.s = false
                success.error = "bad_server : "..t.stringNil(v.error)
                t.error = success.error
                t.eventHandler.removeChannel(msgId)
                return
            end
        end
        -- genrate item and fluid maps
        --{{1.0,"Magnetic Samarium Rod"},{2.0,"Long HSS-S Rod"},{64.0,"Fine Ruridit Wire"},{64.0,"Fine Ruridit Wire"},{2.0,"1x Yttrium Barium Cuprate Cable"}}
        local mapItem = {}
        for k,v in pairs(recipe.ingredient) do
            mapItem[k] = {v[2],k}
        end
        local mapFluidName = {}
        local mapFluidAmmount = {}
        for k,v in pairs(recipe.fluid.recipy) do
            mapFluidAmmount[k] = v[1]*amount
            mapFluidName[k] = v[2]
        end

        --set the database to correct items
        local setDataServer = itemServers[1]

        mapItem = serialization.serialize(mapItem)
        local successData = {s=false}
        setDataServer.loadDataBase(modem,mapItem,successData)
        if successData.s == false then
            success.s = false
            success.error = t.stringNil(successData.error)
            t.error = success.error
            t.eventHandler.removeChannel(msgId)
            return
        end

        local threadsLoading = {}
        local successLoading = {}
        successLoading[#successLoading+1] = {s=false}
        -- create fluid loading thread
        threadsLoading[#threadsLoading+1] = thread.create(t.createSafe,t.loadFluids,modem,fluidServers,mapFluidName,mapFluidAmmount,successLoading[#successLoading])

        for i = 0,(math.ceil(#recipe.ingredient/4)-1) do
            local recipePos = {}
            local recipeAmount = {}
            local len = 4
            --(i*4) + 3
            if len > #recipe.ingredient-(i*4) then
                len = #recipe.ingredient-(i*4)
            end
            for j = 1,len do
                --j = ((i*4)+1),(len +1)
                local absPos = (i*4) + j
                recipePos[j] = absPos
                print(recipe.ingredient[absPos][1])
                recipeAmount[j] = recipe.ingredient[absPos][1] * amount
            end
            for k,v in pairs(itemServers) do
                local serverSelect = i+1
                if v.func == "item_server" and v.index == serverSelect then
                    successLoading[#successLoading+1] = {s=false}
                    threadsLoading[#threadsLoading+1] = thread.create(t.createSafe,v.load,modem,recipePos,recipeAmount,successLoading[#successLoading])
                end
            end
        end
        thread.waitForAll(threadsLoading)
        for k,v in pairs(successLoading) do
            if not v.s then
                success.s = false
                success.error = "loading_falure : "..t.stringNil(v.error)
                t.error = success.error
                t.eventHandler.removeChannel(msgId)
                return
            end
        end
        local onSuc = {s=false}
        local msgIdPointer = {}
        setDataServer.runAssline(modem,onSuc,msgIdPointer)
        if onSuc.s then
            local waitThread =  thread.create(t.waitForDone,msgIdPointer.msgId,setDataServer)
            waitThread:detach()
            success.s = true
        else
            t.eventHandler.removeChannel(msgIdPointer.msgId)
            success.s = false
            success.error = "turnOn_failure"
            t.error = "turnOn_failure"
        end
        t.eventHandler.removeChannel(msgId)
    end
    function t.waitForDone(msgId,server)
        local suc = {}
        server.waitForDone(modem,msgId,suc)
        t.access = true
    end
    return t
end

return assline
package.loaded.comps=nil
package.loaded.setings=nil
package.loaded.listner=nil


LISTNER_ADDRESS = "3e2090dd-43cc-4454-b6bd-a9ad1c8abc79"
PATH_FILE_SETINGS = "/setings.txt"
PATH_FILE_COMPS = "/comps.txt"
LOCAL_PORT = 210
BROADCAST_PORT = 200
SERVER_TYPE = "item_server"
SET = {}
STATUS = "off"

function run()
    local comps = require("comps")
    local setings = require("setings")
    local listner = require("listner")
    local thread = require("thread")
    local serialization = require("serialization")
    local computer = require("computer")
    local shell = require("shell")
    local modem = component.modem

    local compTP,compAEI






    ---@param mesage table
    function sendMsg(mesage)
        --modem.broadcast(SET.host_port,table.unpack(mesage))
        modem.send(SET.host_address,SET.host_port,SET.host_address,table.unpack(mesage))
        modem.broadcast(399,table.unpack(mesage))
    end

    function getEvents()
        if listner.hasEvents() then
            local events = listner.getEvents()
            for k,event in pairs(events) do
                if event[1] == "modem_message" then
                    local type = event[6]
                    if type == "turn_off" then
                        print("turn off event")
                        STATUS = "off"
                    end
                end
            end
            return events
        end
        return nil
    end

    --send baeck awake msg
    function sendBack(event)
        print("msg")
        if SET.host_configured then
            if STATUS == "on" then
                print("awake")
                sendMsg({"awake_conf",event[7]})
            elseif STATUS == "off" then
                print("off")
                sendMsg({"server_off",event[7]})
            elseif STATUS == "working" then
                print("working")
                sendMsg({"server_working",event[7]})
            end
        end
    end

    function getEventType(events,type)
        for  k,v in pairs(events) do
            if v[1] == "modem_message" then
                for L,M in pairs(type) do
                    if v[6] == M then
                        return events[k]
                    end
                end
            end
        end
        return nil
    end

    function sort(compList)
        local compTP = {}
        local compAEI = {}
        for k,v in pairs(compList) do
            local func = v.func
            if func == "transposer" then
                compTP[#compTP+1] = compList[k]
            elseif func == "interface" then
                compAEI[#compAEI+1] = compList[k]
            end
        end
        return compTP,compAEI
    end

    function getHost()
        while SET.host_configured  == false do
            modem.broadcast(BROADCAST_PORT,"get_host",SERVER_TYPE,LOCAL_PORT)
            os.sleep(1)
            if listner.hasEvents() then
                local events = listner.getEvents()
                local event = getEventType(events,{"accepted"})
                if event ~= nil then
                    SET.host_address = event[3]
                    SET.host_port = event[7]
                    SET.host_configured = true
                end
            end
        end
        setings.save()
    end

    --TO DO add time out incase it takes to long ~2 min
    function setUpConfiguration(msgId,size)
        compTP = {}
        compAEI = {}
        while SET.configured == false do
            if listner.hasEvents() then
                local events = listner.getEvents()
                for k,v in pairs(events) do
                    if v[1] == "component_added" then
                        if v[3] == "transposer" then
                            if #compTP <size then
                                local index = #compTP+1
                                compTP[index] = comps.newComp(v[2],"transposer",index)
                                sendMsg({"print",msgId,"added transposer address = "..v[2].."as transposer "..index})
                            else
                                sendMsg({"print",msgId,"added to many transposer"})
                            end
                        elseif v[3] == "me_interface" then
                            if #compAEI <size then
                                local index = #compAEI+1
                                local c = comps.newComp(v[2],"interface", index)
                                compAEI[index] = c
                                sendMsg({"print",msgId,"added me interface address = "..v[2].."as interface "..index})
                            else
                                sendMsg({"print",msgId,"added to many me interfaces"})
                            end
                        end
                    elseif v[1] == "modem_message" then
                        if v[6] == "reset" then
                            compTP = {}
                            compAEI = {}
                            sendMsg({"print",msgId,"reset_done"})
                        end
                    end
                end
            end
            if #compTP == size and #compAEI == size then
                SET.configured = true
                SET.size = size
                comps.storeComponents(compTP,PATH_FILE_COMPS,false)
                comps.storeComponents(compAEI,PATH_FILE_COMPS,true)
                setings.save()
            end
            if SET.configured == false then
                os.sleep(1)
            end
        end
        sendMsg({"configuration_finished",msgId})
    end

    function getConfiguration(event)
        if event ~= nil and event[6] == "set_configuration" then
            sendMsg({"runing_configuration",event[7]})
            STATUS = "working"
            setUpConfiguration(event[7],event[8])
            STATUS = "on"
            computer.shutdown(true)
        end
    end

    function pingHost()
        local pings = 0
        sendMsg({"awake",1,LOCAL_PORT})
        while true do
            if listner.hasEvents() then
                local events = listner.getEvents()
                local event = getEventType(events,{"awake_conf","accepted"})
                if event ~= nil then
                    if event[6] == "awake_conf" then
                        return
                    elseif event[6] == "accepted" then
                        SET.host_address = event[3]
                        SET.host_port = event[7]
                        SET.host_configured = true
                        return
                    end
                end
            end
            if pings > 10 then
                --modem.broadcast(BROADCAST_PORT,"get_host",SERVER_TYPE,LOCAL_PORT)
            end
            sendMsg({"awake",1,LOCAL_PORT})
            pings = pings + 1
            os.sleep(5)
        end
    end

    function loadItems(msgId,items,amounts,compTP,compAEI,database)
        STATUS = "working"
        if #items > SET.size then
            sendMsg({"bad_request",msgId})
            --return false
        end
        for k,v in pairs(items) do
            local amount = amounts[k]
            local transferSize = amount
            local itemStack = database.get(v)
            if itemStack == nil then
                sendMsg({"bad_database",msgId})
                STATUS = "on"
                return false
            end
            --print(table.unpack(compAEI))
            if transferSize > itemStack.maxSize then
                transferSize = itemStack.maxSize
            end
            local aeComp
            for L,W in pairs(compAEI) do
                if W.index == k then
                    aeComp = compAEI[L]
                end
            end
            local tpComp
            for L,W in pairs(compTP) do
                if W.index == k then
                    tpComp = compTP[L]
                    stack = tpComp.component.getStackInSlot(1,1)
                    if stack ~= nil then
                        sendMsg({"non_empty",msgId})
                        STATUS = "on"
                        return false
                    end
                end
            end
            local failCount = 0
            while not aeComp.component.setInterfaceConfiguration(1,database.address,v,transferSize) do
                os.sleep(0.05)
                if failCount > 3 then
                    sendMsg({"setInterface_Error",msgId,v})
                    STATUS = "on"
                    return false
                else
                    failCount = failCount + 1
                end
            end
            local index = 1
            local leftover = 0
            local loopcount = 0
            while amount > 0 do
                if transferSize > amount then
                    transferSize = amount
                end
                if leftover > 0 then
                    transferSize = leftover
                end
                local transferd = tpComp.component.transferItem(0,1,transferSize,1,index)
                amount = amount - transferd
                if transferd >= transferSize then
                    index = index+1
                else
                    leftover = transferSize - transferd
                end
                loopcount =  loopcount + 1
                if loopcount > 100 then
                    aeComp.component.setInterfaceConfiguration(1,database.address,81,0)
                    sendMsg({"transfer_error",msgId,v,index})
                    STATUS = "on"
                    return false
                end
            end
            aeComp.component.setInterfaceConfiguration(1,database.address,81,0)
        end
        STATUS = "on"
        return true
    end

    function getValidInterace()
        for k,v in pairs(component.list("me_interface")) do
            local prox = component.proxy(k)
            if prox.store ~= nil then
                return prox
            end
        end
        return nil
    end

    function setDataBase(msgId,positions,database)
        STATUS = "working"
        local store = getValidInterace().store
        if store == nil then
            sendMsg({"print",msgId,"no valid interface"})
            return false
        end
        for k,v in pairs(positions) do
            database.clear(v[2])
            local filter = {label = v[1]}
            print("filter",filter.label)
            print("storing",store(filter,database.address,v[2]))
            if database.get(v[2]) == nil then
                STATUS = "on"
                return false
            end
        end
        STATUS = "on"
        return true
    end

    function start_loading(oldEvents,msgId,compTP,compAEI)
        local loop = true
        local firstLoop = true
        local sucess = false
        STATUS = "working"
        while loop do
            local events = {}
            if firstLoop then
                events = oldEvents
                firstLoop = false
            else
                events = getEvents()
            end
            if events ~= nil then
                for k,v in pairs(events) do
                    if v[1] == "modem_message" then
                        local event = v
                        if event[6] == "load_items" then
                            local database = component.database
                            local items = serialization.unserialize(v[8])
                            local amounts = serialization.unserialize(v[9])
                            local sucsses = loadItems(msgId,items,amounts,compTP,compAEI,database)
                            if sucsses then
                                sendMsg({"load_items_sucsses",msgId})
                                loop = false
                            else
                                sendMsg({"load_failure",msgId})
                                loop = false
                            end
                        end
                    end
                end
            end
            os.sleep(0.05)
        end
        STATUS = "on"
    end

    function getGTMachine()
        local gt = component.gt_machine
        if gt.getSensorInformation == nil then
            print("look trough all")
            for k,v in pairs(component.list("gt_machine")) do
                gt = component.proxy(k)
                if gt.getSensorInformation ~= nil then
                    return gt
                end
            end
            return nil
        end
        return gt
    end

    function update(file)
        local loop = true
        local curName = "/"..file..".lua"
        local backName = "/"..file..".backup"
        local command = "cp "..curName.." "..backName
        shell.execute(command)
        SET.backup = file
        setings.save()
        while loop do
            local events = getEvents()
            local file = {}
            if events ~= nil then
                for k,Event in pairs(events) do
                    if Event[6] == "file_data" then
                        file[Event[8]] = Event[9]
                    elseif Event[6] == "transfer_done" then
                        loop = false
                    end
                end
            end
        end
        command = "rm "..backName
        shell.execute(command)
        local writeFile = io.open(backName,"w")
        for k,v in pairs(file) do
            writeFile:write(v)
        end
        writeFile:close()
        computer.shutdown(true)
    end

    function turnOn(msgId)
        STATUS = "working"
        local suc = false
        local gt = getGTMachine()
        gt.setWorkAllowed(false)
        if gt.isMachineActive() then
            sendMsg({"already_on",msgId})
            suc = true
        else
            local atempts = 0
            while atempts < 5 do
                gt.setWorkAllowed(true)
                os.sleep(0.05)
                if gt.isMachineActive() then
                    gt.setWorkAllowed(true)
                    sendMsg({"assline_on",msgId})
                    break
                    suc = true
                else
                    atempts = atempts+1
                    gt.setWorkAllowed(false)
                    os.sleep(0.05)
                    --sendMsg({"load_failure",msgId})
                end
            end
        end
        if not suc then
            sendMsg({"load_failure",msgId})
        end
        gt.setWorkAllowed(true)
        while gt.isMachineActive() do
            gt.setWorkAllowed(true)
            os.sleep(0.05)
        end
        sendMsg({"crafting_done",msgId})
        STATUS = "on"
    end

    local listnerThread = thread.create(listner.run,sendBack)
    setings.set(PATH_FILE_SETINGS,SET,"configured","host_address","host_port","host_configured","size","backup")
    setings.load()
    modem.open(LOCAL_PORT)
    local compList = comps.getComponnents(PATH_FILE_COMPS)

    if SET.host_configured == false or SET.host_address == false then
        SET.host_configured = false
        setings.save()
        getHost()
    end

    if  SET.configured == false or compList == nil then
        SET.configured = false
        setings.save()
    else
        compTP,compAEI = sort(compList)
        if compTP == nil or compAEI == nil then
            sendMsg({"bad_configuration",0})
            SET.configured = false
            compTP = {}
            compAEI = {}
            comps.storeComponents({},PATH_FILE_COMPS)
        end
    end

    pingHost()


    function main()
    while STATUS ~= "off" do
        local events = getEvents()
        if events ~= nil then
            for k,v in pairs(events) do
                print("process event in main",v[6])
                if v[1] == "modem_message" then
                    if v[6] == "load_assline" then
                        if SET.configured == true then
                            sendMsg({"start_loading",v[7]})
                            start_loading(events,v[7],compTP,compAEI)
                        else
                            sendMsg({"not_configured",v[7]})
                        end
                    elseif v[6] == "reset_configuration" then
                        SET.configured = false
                        setings.save()
                        compTP = {}
                        compAEI = {}
                        comps.storeComponents({},PATH_FILE_COMPS)
                        sendMsg({"configuration_reseted",v[7]})
                    elseif v[6] == "set_configuration" then
                        getConfiguration(v)
                    elseif v[6] == "set_data" then
                        local database = component.database
                        local positions = serialization.unserialize(v[8])
                        local sucsses = setDataBase(v[7],positions,database)
                        if sucsses then
                            sendMsg({"load_data_sucsses",v[7]})
                        else
                            sendMsg({"load_data_failure",v[7]})
                        end
                    elseif v[6] == "start_assline" then
                        local success = turnOn(v[7])
                    elseif v[6] == "is_runing" then
                        local gt = getGTMachine()
                        if gt.isMachineActive() then
                            sendMsg({"runing",v[7]})
                        else
                            sendMsg({"not_runing",v[7]})
                        end
                    elseif v[6] == "update" then

                    elseif v[6] == "get_info" then
                        sendMsg({"info_package",v[7],SET.configured,SERVER_TYPE})
                    end
                end
            end
        end
        os.sleep(0.05)
    end
    end

    STATUS = "on"
    print("run")
    local ran,err = pcall(main)
    if not ran then
        sendMsg({"error",0,"load server errord",err})
    end
    listnerThread:kill()
    computer.shutdown(true)
end

function recoverFile()
    local setings = require("setings")
    local shell =  require("shell")
    local computer = require("computer")
    setings.set(PATH_FILE_SETINGS,SET,"configured","host_address","host_port","host_configured","size","backup")
    setings.load()
    local backupName = "/"..SET.backup..".backup"
    local curFile = "/"..SET.backup..".lua"
    local command = "rm "..curFile
    shell.execute(command)
    command = "mv "..backupName.." "..curFile
    shell.execute(command)
    computer.shutdown(true)
end

local ran,err = pcall(run)
if not ran then
    sendMsg({"error",0,"load server errord",err})
    sendMsg({"error",0,"reverting to backup"})
    -- use pcall in case we can not the lass changed file broken
    local ranRec,err = pcall(recoverFile)
    if not ranRec then
        --if the recover File is broken then there is a big problem in autorun
        -- so we recover autorun
        local shell =  require("shell")
        local computer = require("computer")
        local fileName = "autorun"
        local backupName = "/"..fileName..".backup"
        local curFile = "/"..fileName..".lua"
        local command = "rm "..curFile
        shell.execute(command)
        command = "mv "..backupName.." "..curFile
        shell.execute(command)
        computer.shutdown(true)
    end
end
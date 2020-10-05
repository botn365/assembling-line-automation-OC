package.loaded.comps=nil
package.loaded.setings=nil
package.loaded.listner=nil

local comps = require("comps")
local setings = require("setings")
local listner = require("listner")
local thread = require("thread")
local serialization = require("serialization")
local computer = require("computer")
local modem = component.modem

LISTNER_ADDRESS = "3e2090dd-43cc-4454-b6bd-a9ad1c8abc79"
PATH_FILE_SETINGS = "/setings.txt"
PATH_FILE_COMPS = "/comps.txt"
LOCAL_PORT = 210
BROADCAST_PORT = 200
SERVER_TYPE = "fluid_server"
SET = {}
STATUS = "off"
compTP = {}
compRS = {}


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

function sort(compList)
    local compTP = {}
    local compRSI = {}
    for k,v in pairs(compList) do
        local func = v.func
        if func == "transposer" then
            print("transposer")
            compTP[#compTP+1] = compList[k]
        elseif func == "redstone" then
            print("redstone")
            compRSI[#compRSI+1] = compList[k]
        end
    end
    return compTP,compRSI
end

--TO DO add time out incase it takes to long ~2 min
function setUpConfiguration(msgId,dir)
    local direction = serialization.unserialize(dir)
    local multieTankSide = tonumber(direction[1])
    local p2pTunnelSide = tonumber(direction[2])
    local sideRedstone = tonumber(direction[3])

    if sideRedstone == nil or multieTankSide == nil or p2pTunnelSide == nil then
        sendMsg({"bad_sides_given",msgId})
    else
        compTP = {}
        compRS = {}
        while SET.configured == false do
            if listner.hasEvents() then
                local events = listner.getEvents()
                for k,v in pairs(events) do
                    if v[1] == "component_added" then
                        if v[3] == "transposer" then
                            if #compTP <1 then
                                local index = #compTP+1
                                
                                compTP[index] = comps.newComp(v[2],"transposer",multieTankSide+(p2pTunnelSide*10))
                                local tankCount1 = compTP[index].component.getTankCount(multieTankSide)
                                local tankCount2 = compTP[index].component.getTankCount(p2pTunnelSide)
                                if tankCount1 == 0 or tankCount2 == 0 then
                                    sendMsg({"print",msgId,"transposer with address "..v[2].."could not find tank in selected sides"})
                                    compTP[index] = nil 
                                else
                                    sendMsg({"print",msgId,"added transposer address = "..v[2].."as transposer "..index})
                                end
                            else
                                sendMsg({"print",msgId,"added to many transposer"})
                            end
                        elseif v[3] == "redstone" then
                            if #compRS <1 then
                                local index = #compRS +1
                                compRS[index] = comps.newComp(v[2],"redstone",sideRedstone)
                                sendMsg({"print",msgId,"added redstone address = "..v[2].."as redstone "..index})
                            else
                                sendMsg({"print",msgId,"added to many redstone"})
                            end
                        end
                    elseif v[1] == "modem_message" then
                        if v[6] == "reset" then
                            compTP = {}
                            compRS = {}
                            sendMsg({"print",msgId,"reset_done"})
                        end
                    end
                end
            end
            if #compTP == 1 and #compRS == 1 then
                SET.configured = true
                SET.size = 1
                comps.storeComponents(compTP,PATH_FILE_COMPS,false)
                comps.storeComponents(compRS,PATH_FILE_COMPS,true)
                setings.save()
            end
            if SET.configured == false then
                os.sleep(1)
            end
        end
        sendMsg({"configuration_finished",msgId})
    end
end

function getConfiguration(event)
    if event ~= nil and event[6] == "set_configuration" then
        sendMsg({"runing_configuration",event[7]})
        setUpConfiguration(event[7],event[8])
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

function getFluids(compTP)
    local transposer = compTP[1]
    if transposer == nil then
        return nil
    end
    return transposer.component.getFluidInTank(transposer.index%10)
end
--index ab -> a = p2pSide, b = multieTankSide
function transferFluids(label,amount,compTP)
    local fluids = getFluids(compTP)
    local pos = -1
    for k,v in pairs(fluids) do
        if type(v) == "table" and v.label == label then
            print(v.label ,label,k)
            pos = k-1
            break
        end
    end
    if pos == -1 then
        return 0
    else
        local transposer = compTP[1]
        if transposer ~= nil then
            local from = transposer.index%10
            local to = math.floor(transposer.index/10)%10
            local _,tr = transposer.component.transferFluid(from,to,amount,pos)
            while true do
                if tr == 0 or tr < amount then
                    return tr
                end
                local f = transposer.component.getFluidInTank(to)[1]
                if f.amount <1 or f.amount == nil then
                    break
                end
                os.sleep(0.05)
            end
            return tr
        end
    end
end


function loadFluids(msgId,fluidNames,fluidAmount,id,compTP,compRS)
    compRS = compRS[1]
    local cable = SET.IDs[id]
    if cable == nil then
        sendMsg({"bad_id",msgId})
        return false
    elseif cable < 4 then
        sendMsg({"bad_color",msgId})
    end
    local fluids = getFluids(compTP)
    local fluidPos = {}
    for k,v in pairs(fluids) do
        for l,w in pairs(fluidNames) do
            if type(v) == "table" and v.label == w then
                fluidPos[#fluidPos+1] = {label=w,amount=fluidAmount[l],bus=l}
            end
        end
    end
    if #fluidPos ~= #fluidNames then
        sendMsg({"fluids_missing",msgId})
        return false
    end
    local redstone = {}
    redstone[cable] = 255
    for k,v in pairs(compRS) do
        print(k,v)
    end
    compRS.component.setBundledOutput(compRS.index,redstone)
    for i = 1, #fluidNames do
        local transferd = 0
        local suc = false
        redstone[fluidPos[i].bus-1] = 255
        compRS.component.setBundledOutput(compRS.index,redstone)
        for I = 1,20 do
            local tr = transferFluids(fluidPos[i].label,fluidPos[i].amount-transferd,compTP)
            transferd = transferd + tr
            if transferd == fluidPos[i].amount then
                suc = true
                break
            end
        end
        if not suc then
            redstone[fluidPos[i].bus-1] = 0
            redstone[cable] = 0
            compRS.component.setBundledOutput(compRS.index,redstone)
            sendMsg({"transfer_failed",msgId})
            return false
        end
        redstone[fluidPos[i].bus-1] = 0
        compRS.component.setBundledOutput(compRS.index,redstone)
    end
    redstone[cable] = 0
    compRS.component.setBundledOutput(compRS.index,redstone)
    return true
end

function setID(msgId,id,color)
    if type(id) ~= "number" or type(color) ~= "number" then
        return false
    end
    for k,v in pairs(SET.IDs) do
        if k == id then
            sendMsg({"print",msgId,"ID already taken"})
            return false
        elseif v == color then
            sendMsg({"print",msgId,"color already taken"})
            return false
        end
    end
    SET.IDs[id] = color
    setings.save()
    return true
end



local listnerThread = thread.create(listner.run,sendBack)
setings.set(PATH_FILE_SETINGS,SET,"configured","host_address","host_port","host_configured","size","IDs")
setings.load()
modem.open(LOCAL_PORT)
local compList = comps.getComponnents(PATH_FILE_COMPS)
if not SET.IDs then
    SET.IDs = {}
    setings.save()
end

if SET.host_configured == false or SET.host_address == false then
    SET.host_configured = false
    setings.save()
    getHost()
end

if  SET.configured == false or compList == nil then
    SET.configured = false
    setings.save()
else
    compTP,compRS = sort(compList)
    if compTP == nil or compRS == nil then
        sendMsg({"bad_configuration",0})
        SET.configured = false
        compTP = {}
        compRS = {}
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
                    if v[6] == "reset_configuration" then
                        SET.configured = false
                        setings.save()
                        compTP = {}
                        compRS = {}
                        comps.storeComponents({},PATH_FILE_COMPS)
                        sendMsg({"configuration_reseted",v[7]})
                    elseif v[6] == "set_configuration" then
                        getConfiguration(v)
                    elseif v[6] == "get_fluids" then
                        local fluids = getFluids(compTP)
                        fluids = serialization.serialize(fluids)
                        sendMsg({"fluid_table",v[7],fluids})
                    elseif v[6] == "set_ID" then
                        local success = setID(v[7],v[8],v[9])
                        sendMsg({"id_seted",v[7],success,v[8],v[9]})
                    elseif v[6] == "get_IDs" then
                        local IDS = serialization.serialize(SET.IDs)
                        sendMsg({"id_send",v[7],IDS})
                    elseif v[6] == "test" then
                        local fluidName = serialization.unserialize(v[8])
                        local fluidAmount = serialization.unserialize(v[9])
                        print("load fluids",v[7], fluidName, fluidAmount, v[10], compTP, compRS)
                        local suc = loadFluids(v[7], fluidName, fluidAmount, v[10], compTP, compRS)
                        sendMsg({"success",v[7],suc})
                    elseif v[6] == "get_info" then
                        sendMsg({"info_package",v[7],SET.configured,SERVER_TYPE})
                    end
                end
            end
        end
        os.sleep(1)
    end
end

STATUS = "on"
print("run")
--print(nil..nil)
local ran,err = pcall(main)
if not ran then
    sendMsg({"error",0,"server errord",err})
end

listnerThread:kill()
computer.shutdown(true)
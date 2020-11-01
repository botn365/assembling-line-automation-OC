package.loaded.comps=nil
package.loaded.setings=nil
package.loaded.listner=nil
package.loaded.assline=nil
package.loaded.itemServer=nil
package.loaded.recipe=nil
package.loaded.Loadrecipy=nil
package.loaded.FindMatch=nil
package.loaded.eventhandler=nil
package.loaded.side=nil

local component = require("component")
local setings = require("setings")
local eventhandler = require("eventhandler")
local thread = require("thread")
local assline = require("assline")
local itemServer = require("itemServer")
local fluidServer = require("fluidServer")
local recipe = require("recipe")
local event = require("event")
local serialization = require("serialization")
local filesystem = require("filesystem")
local recipymap = require("Loadrecipy")
local recipePrioretyMap = require("LoadrecipePriorety")
local findMatch = require("FindMatch")
local computer = require("computer")
local side = require("side")
local colors = require("colors")
local modem = component.modem


SAVE_LOCATION = "/save.txt"
LOCAL_PORT = 201
REMOTE_PORT = 210
COMAND_PORT = 404
BROADCAST_PORT = 200
LISTNER_ADDRESS = "3e2090dd-43cc-4454-b6bd-a9ad1c8abc79"
SERVER_TYPE = "main"
FLUID_SERVERS = {}
ITEM_SERVERS = {}
SERVER_TEMP_LIST = {}
ASSLINES = {}
RUNTIME_VALUES = {}
SET = {}
COMMAND_FUNCIONS = {}

function sendMSGS(address,port,msg)
    --modem.send(address,port,...)
    --print("sendMSG",table.unpack(msg))
    modem.send(address,port,address,table.unpack(msg))
    modem.broadcast(399,address,table.unpack(msg))
end

--functions

local function msger(Event)
    local eventID,_ = string.gsub(Event[3],"-","_")
    table.remove(Event,1)
    event.push(eventID,table.unpack(Event))
end

function save()
    local file = io.open(SAVE_LOCATION,"w")
    for k,assline in pairs(ASSLINES) do
        local asslineString = "<"..assline.toString()..">"
        file:write(asslineString)
    end
    file:close()
end

function removeDupes()
    local tempList = {}
    for indexFluid,server in pairs(FLUID_SERVERS) do
        local found = false
        for indexTemp,temp in pairs(tempList) do
            if temp.address == server.address then
                FLUID_SERVERS[indexFluid] = nil
                found = true
                break
            end
        end
        if not found then
            tempList[#tempList+1] = server
        end
    end
    FLUID_SERVERS = tempList
    for assIn,assline in pairs(ASSLINES) do
        for serIn,server in pairs(assline.serverList) do
            if server.func == "fluid_server" then
                for FlIn,serverFluid in pairs(FLUID_SERVERS) do
                    if server.address == serverFluid.address then
                        assline.serverList[serIn] = serverFluid
                    end
                end
            end
        end
    end
end

function load()
    if not filesystem.exists(SAVE_LOCATION) then
    else
        local file = io.open(SAVE_LOCATION)
        local offset = 0
        while true do
            local read = file:read(1000)
            if read == nil then
                break
            end
            local startPos = string.find(read,"<")
            if startPos == nil then
                break
            end
            startPos = startPos + 1
            local endPos = string.find(read,">")
            if endPos == nil then
                break
            end
            endPos = endPos -1
            local asslineString = string.sub(read,startPos,endPos)
            local newAssline = assline.new()
            newAssline.fromString(asslineString,eventhandler)
            ASSLINES[#ASSLINES+1] = newAssline
            offset = offset + endPos+1
            file:seek("set",offset)
        end
        local invalidList = {}
        for k,assline in pairs(ASSLINES) do
            for L,server in pairs(assline.serverList) do
                local duble = false
                for J,serverIn in pairs(ITEM_SERVERS) do
                    if server.address == serverIn.address then
                        print("duble server found")
                        invalidList[#invalidList+1] = k
                        duble = true
                    end
                end
                if not duble then
                    if server.func == "fluid_server" then
                        print("add fluid server")
                        FLUID_SERVERS[#FLUID_SERVERS+1] = server
                    elseif server.func == "item_server" then
                        print("add item server")
                        ITEM_SERVERS[#ITEM_SERVERS+1] = server
                    end
                end
            end
        end
    end
    removeDupes()
end

function getWorkingAssline()
    local asslines = {}
    for k,asslineList in pairs(ASSLINES) do
        if asslineList.access then
            asslines[#asslines+1] = asslineList
        end
    end
    return asslines
end

function getFluids()
    local fluidServer = FLUID_SERVERS[1]
    if fluidServer == nil then
        return nil
    end
    -- make it compataple with old find match code
    local fluids = {}
    fluids.fluid = fluidServer.getFluids(modem)
    if fluids.fluid == nil then
    return nil    
    end
    fluids.length = #fluids.fluid 
    return fluids
end

function getItems()
    local interface = component.me_interface
    if interface == nil then
        return nil
    end
    local items = interface.getItemsInNetwork()
    if items == nil then
        return nil
    end
    items.length = items.n
    return items
end

function loadSafe(...)
    local ran,err = pcall(...)
    if not ran then
        print(err)
    end
end

function copyRecipe(recipe,circuitConverList)
    local recipeCopy = {ingredient={},fluid={recipy={}}}
    for k ,v in pairs(recipe.ingredient) do -- copy the items and conver circuit oredict
        if v[3] == nil then
            recipeCopy.ingredient[k] = {v[1],v[2]}
        else
            for L,N in pairs(circuitConverList) do
                if N[1] == v[2] then
                    recipeCopy.ingredient[k] = {v[1],N[2]}
                    break
                end
            end
        end
    end
    for k,v in pairs(recipe.fluid.recipy) do -- copy fluids
        recipeCopy.fluid.recipy[k] = {v[1],v[2]}
    end
    return recipeCopy
end

function copySimpleRecipe(recipe,circuitConverList)
    local simplerecipe = recipe.simplerecipy
    local copySimpleRecipe = {simplerecipe={length=simplerecipe.length},fluid={recipy={}}}
    for i = 1 , simplerecipe.length do
        if simplerecipe[i].C == 1 then
            for L,N in pairs(circuitConverList) do
                if N[1] == simplerecipe[i].label then
                    copySimpleRecipe.simplerecipe[i] = {size=simplerecipe[i].size,label=N[2]}
                    break
                end
            end
        else
            copySimpleRecipe.simplerecipe[i] = {size=simplerecipe[i].size,label=simplerecipe[i].label}
        end
    end
    for k,v in pairs(recipe.fluid.recipy) do -- copy fluids
        copySimpleRecipe.fluid.recipy[k] = {v[1],v[2]}
    end
    return copySimpleRecipe
end


function removeUsed(recipeCopy,items,fluids,amount)
    for indexI,itemI in pairs(items) do
        if type(itemI) == "table" then
            for indexR,itemR in pairs(recipeCopy.simplerecipe) do
                if  type(itemR) == "table" and itemI.label == itemR.label then
                    local amountR = itemR.size*amount
                    local amountI = itemI.size
                    if amountR < amountI then
                        items[indexI].size = amountI - amountR
                    else
                        items[indexI]=nil
                        items.length = items.length - 1
                    end
                    recipeCopy.simplerecipe[indexR] = nil
                    recipeCopy.simplerecipe.length =  recipeCopy.simplerecipe.length - 1
                end
            end
        end
        if recipeCopy.simplerecipe.lengt == 0 then
            break
        end
    end
    for indexI,fluidI in pairs(fluids.fluid) do
        if type(fluidI) == "table" then
            for indexR,fluidR in pairs(recipeCopy.fluid.recipy) do
                if type(fluidR) == "table" and fluidI.label == fluidR[2] then
                    local amountR = fluidR[1]*amount
                    local amountI =  fluidI.amount
                    if amountR < amountI then
                        fluids.fluid[indexI].amount = amountI - amountR
                    else
                        fluids.fluid[indexI] = nil
                    end
                    recipeCopy.fluid.recipy[indexR] = nil
                end
            end
        end
    end
end

function runAsslines()
    local asslines = getWorkingAssline()
    if asslines == {} then
        return
    end
    local successList = {}
    local loadThreads = {}
    local used = 0
    local items = getItems()
    local fluids = getFluids()
    local recipesOuts = {}
    local recipeNumber = 0
    if items == nil or fluids == nil then
        return    
    end
    while (#asslines-used)>0 do
        local oldUsed = used
        local isPriorety = false
        local prioretyMap, circuitConverList= findMatch.findMatch(recipePrioretyMap,items,fluids, 1)
        if prioretyMap then
            recipeNumber = prioretyMap
            isPriorety = true
        else
            recipeNumber,circuitConverList = findMatch.findMatch(recipymap,items,fluids, recipeNumber+1)
        end
        if recipeNumber then
            local recipe
            local amount
            if isPriorety then
                recipe = recipePrioretyMap.n[recipeNumber]
                amount = findMatch.getMax(recipePrioretyMap,recipeNumber,items,fluids,296000)
            else
                recipe = recipymap.n[recipeNumber]
                amount = findMatch.getMax(recipymap,recipeNumber,items,fluids,296000)
            end
             
            if amount > 0 then
                -- copy the recipe if there is circuit converion
                local amountPre = amount
                local recipeCopy = copyRecipe(recipe,circuitConverList)
                local copySimple = copySimpleRecipe(recipe,circuitConverList)
                local fullAmount = math.floor(amount/16) + used
                if fullAmount > #asslines then
                    fullAmount = #asslines
                end
                for i = 1 + used,fullAmount do
                    successList[#successList+1] = {s=false}
                    loadThreads[#loadThreads+1] = thread.create(asslines[i].load,recipeCopy,16,modem,successList[#successList])
                    asslines[i] = nil
                    recipesOuts[#recipesOuts+1] = {name=recipe.output,amount=amount}
                    used = used+1
                    amount =  amount - 16
                end
                if (amount/16)%1 > 0  and (#asslines-used)>0  then
                    successList[#successList+1] = {s=false}
                    print(asslines[used+1],used)
                    loadThreads[#loadThreads+1] = thread.create(loadSafe,asslines[used+1].load,recipeCopy,amount,modem,successList[#successList])
                    asslines[used+1] = nil
                    used = used+1
                    amount = 0
                end
                removeUsed(copySimple,items,fluids,amountPre-amount)
            end
        else
            break
        end
        if oldUsed == used then
            break
        end
    end
    if #loadThreads >0 then
        print("waiting for assline")
        for k,v in pairs(recipesOuts) do
            print(v.name,v.amount)
        end
        if #loadThreads > 0 then
            thread.waitForAll(loadThreads)
        end
        print("done waiting")
        for k,v in pairs(successList) do
            if not v.s then
                print(v.error,"asslien broke")
            end
        end
    end
end

function count(table,eventID)
    local Event = {event.pull(10,eventID)}
    table[1] = Event
end

function registerLoadServer(Event)
    for k,v in pairs(ITEM_SERVERS) do
        if v.address == Event[3] then
            sendMSGS(Event[3], Event[8],{"awake_conf"})
            return
        end
    end
    for k,v in pairs(FLUID_SERVERS) do
        if v.address == Event[3] then
            sendMSGS(Event[3], Event[8],{"awake_conf"})
            return
        end
    end
    for k,v in pairs(SERVER_TEMP_LIST) do
        if v.address == Event[3] then
            return
        end
    end
    local serverTemp = {address=Event[3],port=Event[8]}
    local indexServer = #SERVER_TEMP_LIST+1
    SERVER_TEMP_LIST[indexServer] = serverTemp
    print("new server registert")
    sendMSGS(serverTemp.address, serverTemp.port,{"accepted",LOCAL_PORT})
    local function msger(Event)
        local eventID,_ = string.gsub(Event[3],"-","_").."register"
        table.remove(Event,1)
        event.push(eventID,table.unpack(Event))
    end
    print("get initialies")
    local msgID = eventhandler.addChanelRandome(msger)
    local eventID,_ = string.gsub(Event[3],"-","_").."register"
    local timeOut = computer.uptime()
    while true do
        sendMSGS(serverTemp.address, serverTemp.port,{"awake",msgID})
        local Event1 = {}
        local t = thread.create(count,Event1,eventID)
        --Event = {event.pull(10,eventID)}
        local suc = thread.waitForAny({t},10)
        Event1 = Event1[1]
        local time = computer.uptime()
        if not suc or timeOut +10 < time then
            SERVER_TEMP_LIST[indexServer] = nil
            eventhandler.removeChannel(msgID)
            print("initialise fail")
            return
        end
        if Event1[6] == "awake_conf" then
            break
        else
            os.sleep(4)
        end
    end
    sendMSGS(serverTemp.address, serverTemp.port,{"get_info",msgID})
    local Event = {event.pull(eventID)}
    local server
    if Event[9] == "item_server" then
        local index = #ITEM_SERVERS+1
        server = itemServer.newServer("item server N="..index,serverTemp.address,serverTemp.port,index,Event[9],eventhandler)
        ITEM_SERVERS[index] = server
    elseif Event[9] ==  "fluid_server" then
        local index =  #FLUID_SERVERS + 1
        server = fluidServer.newServer("fluid server N="..index,serverTemp.address,serverTemp.port,index,Event[9],eventhandler)
        FLUID_SERVERS[index] = server
    end
    server.initialised = Event[8]
    print("goten inialised",server.initialised,server.func)
    eventhandler.removeChannel(msgID)
    SERVER_TEMP_LIST[indexServer] = nil
end

function processCommand(msg)
    local endPos = string.find(msg," ")
    if endPos == nil then
        return msg
    else
        local command = string.sub(msg,1,endPos-1)
        local arg = msg
        local args = {}
        local startPos = 0
        repeat
            local argIndex = #args+1
            startPos = endPos + 1
            endPos = string.find(arg," ",startPos)
            if endPos == nil then
                endPos = arg:len()+1
            end
            args[argIndex] = string.sub(arg,startPos,endPos-1)
        until endPos >= arg:len()
        return command,args
    end
end

function getAsslineName(Event,eventID)
    sendMSGS(Event[3],COMAND_PORT,{"set_static","name:"})
    local name = {event.pull(eventID)}
    name = name[8]
    sendMSGS(Event[3],COMAND_PORT,{"print","name:"..name})
    local length = 0
    while true do
        sendMSGS(Event[3],COMAND_PORT,{"set_static","length:"})
        length = {event.pull(eventID)}
        length = length[8]
        length = tonumber(length)
        if length == nil then
            sendMSGS(Event[3],COMAND_PORT,{"print","string recieved expected number"})
        else
            if length > 0 then
                break
            else
                sendMSGS(Event[3],COMAND_PORT,{"print","number needs to be grater then 0"})
            end
        end
    end
    sendMSGS(Event[3],COMAND_PORT,{"print","length:"..length})
    local index = #ASSLINES + 1
    local newAss = assline.new(index, name, length,eventhandler)
    ASSLINES[index] = newAss
    return newAss
end

function initialiseItemServer(server,length,offset,terminalAddress,assline,serverNumber)
    --get msgID
    local msgId = 0
    repeat
        if msgId ~= 0 then
            os.sleep(0.05)
        end
        msgId = math.random(500, 10000)
    until eventhandler.addChannel(msgId,msger)

    local eventIDS,_ = string.gsub(server.address,"-","_")
    local comandID,_ = string.gsub(terminalAddress,"-","_")

    --start server configure
    server.sendMSG(modem,{"set_configuration",msgId,length})
    while true do
        local returnEvent = {event.pull(eventIDS)}
        if returnEvent[6] == "runing_configuration" then
            break
        end
    end

    --start loop to report back print msges and look if congifure is done
    sendMSGS(terminalAddress, COMAND_PORT, {"print","place "..length.." transposers and interfaces form posistion "..(offset+1).." to posision "..offset+length})
    while true do
        local returnEvent = {event.pullMultiple(eventIDS,comandID)}
        print("recived event multi pull",returnEvent[1],returnEvent[6])
        if returnEvent[1] == eventIDS then
            if returnEvent[6] == "print" then
                sendMSGS(terminalAddress, COMAND_PORT, {"print",returnEvent[8]})
            elseif returnEvent[6] == "configuration_finished" then
                server.initialised = true
                server.index = serverNumber
                offset = offset + length
                assline.serverList[#assline.serverList+1] = server
                sendMSGS(terminalAddress, COMAND_PORT, {"print","configuration of server done"})
                break
            end
        else
            if returnEvent[6] == "command" and returnEvent[8] == "reset" then
                server.sendMSG(modem,{"reset",msgId})
            end
        end

    end
    -- make the msg ID slot free
    eventhandler.removeChannel(msgId)
    return offset
end

function getUnitialisedItemServer(Event,eventID,serverList)
    while true do
        local inactiveServers = {}
        for k,v in pairs(serverList) do
            if not v.initialised then
                inactiveServers[#inactiveServers+1] = {index=k,address=v.address,name=v.name}
            end
        end
        if #inactiveServers == 0 then
            sendMSGS(Event[3], COMAND_PORT, {"print","no empty load servers found enable them and press enter to re look for load servers"})
            event.pull(eventID)
        else
            local serverTable = serialization.serialize(inactiveServers)
            sendMSGS(Event[3], COMAND_PORT, {"print_table",serverTable})
            local number = 0
            while true do
                sendMSGS(Event[3], COMAND_PORT, {"set_static","serverNumber:"})
                number = {event.pull(eventID)}
                number = number[8]
                sendMSGS(Event[3], COMAND_PORT, {"print","serverNumber:"..number})
                number = tonumber(number)
                if number == nil  then
                    sendMSGS(Event[3], COMAND_PORT, {"print","given number is a not a number"})
                    break
                end
                for k,v in pairs(inactiveServers) do
                    if v.index == number then
                        return number
                    end
                end
                sendMSGS(Event[3], COMAND_PORT, {"print",number.." is a not a valid number"})
                break
            end
        end
    end
end

function initialiseFluidServer(commandAddress,eventID,server)
    sendMSGS(commandAddress,COMAND_PORT,{"print","need fluid import direction, fluid export direction, redstone I/O conection direction"})
    sendMSGS(commandAddress,COMAND_PORT,{"print","in format [fluid import,fluidexport,redstone] u=UP,d=DOWN,s=SOUTH,n=NORTH,e=EASTH,w=WEST"})
    sendMSGS(commandAddress,COMAND_PORT,{"print","example: [udn]  ([] need to be exluded)"})
    while true do
        sendMSGS(commandAddress, COMAND_PORT, {"set_static","input:"})
        local msg = {event.pull(eventID)}
        msg = string.lower(msg[8])
        sendMSGS(commandAddress,COMAND_PORT,{"print","input:"..msg})
        print(msg)
        local inF = side:get(string.sub(msg,1,1))       
        local outF = side:get(string.sub(msg,2,2))
        local red = side:get(string.sub(msg,3,3))
        print(stringNil(inF),stringNil(outF),stringNil(red))
        if inF == nil or outF == nil or red == nil then
            sendMSGS(commandAddress,COMAND_PORT,{"print","a value was not correct re eneter values"})
        else
            sendMSGS(commandAddress,COMAND_PORT,{"print","initializing fluid server"})
            local msgId = eventhandler.addChanelRandome(msger)
            local msgEventId,_ = string.gsub(server.address,"-","_")
            local dirSeri = serialization.serialize({inF,outF,red})
            server.sendMSG(modem,{"set_configuration",msgId,dirSeri})
            while true do
                local serverMsg = {event.pull(msgEventId)}
                if serverMsg[6] == "runing_configuration" then
                    break
                end
            end
            sendMSGS(commandAddress,COMAND_PORT,{"print","add the transposer and redstone I/O"})
            while true do
                local serverMsg = {event.pullMultiple(msgEventId,eventID)}
                if serverMsg[6] == "print" then
                    sendMSGS(commandAddress,COMAND_PORT,{"print",serverMsg[8]})
                elseif serverMsg[6] == "configuration_finished" then
                    sendMSGS(commandAddress,COMAND_PORT,{"print","initialisatione finished"})
                    break
                elseif serverMsg[6] == "command" then
                    if serverMsg[8] == "reset" then
                        server.sendMSG(modem,{"reset",msgId})
                    end
                end
            end
            break
        end
    end

end

function getFluidServer(commandAddress,eventID)
    sendMSGS(commandAddress,COMAND_PORT,{"print","select fluid server to fill fluids in assline"})
    while true do
        local shortServer = {}
        for k,v in pairs(FLUID_SERVERS) do
            shortServer[#shortServer+1] = {index=k,address=v.address,name=v.name}
        end
        sendMSGS(commandAddress, COMAND_PORT, {"print_table",serialization.serialize(shortServer)})
        sendMSGS(commandAddress, COMAND_PORT, {"set_static","server index:"})
        local selcted = {event.pull(eventID)}
        selcted = tonumber(selcted[8])
        if selcted ~= nil then
            for k,v in pairs(shortServer) do
                if v.index == selcted then
                    if not v.initialised then
                        sendMSGS(commandAddress, COMAND_PORT, {"print","server not initialised type y to initialise else press anything to select other server"})
                        local doInint = {event.pull(eventID)}
                        doInint = string.lower(doInint[8])
                        if string.find(doInint,"y") then
                           initialiseFluidServer(commandAddress,eventID,FLUID_SERVERS[selcted]) 
                        else
                            break
                        end
                    end
                    return FLUID_SERVERS[selcted]
                end
            end
            sendMSGS(commandAddress, COMAND_PORT, {"print",selcted.." is a not a valid number"})
        else
            sendMSGS(commandAddress, COMAND_PORT, {"print","given number is a not a number"})
        end
    end
end

function getColor(commandAddress,eventID,colrsId)
    sendMSGS(commandAddress,COMAND_PORT,{"print","give color of cable that enables assline"})
    while true do
        sendMSGS(commandAddress, COMAND_PORT,{"set_static","color number:"})
        local color = {event.pull(eventID)}
        if color[6] == "command" then
            color = tonumber(color[8])
            for k,v in pairs(colrsId) do
                if v == color then
                    color = nil
                    break
                end
            end
            if color ~= nil and color < 16 and color > -1 then
                sendMSGS(commandAddress,COMAND_PORT,{"print","sected color is "..colors[color].." enter y to confirm"})
                local doInint = {event.pull(eventID)}
                doInint = string.lower(doInint[8])
                if string.find(doInint,"y") then
                    return color
                end
            else
                sendMSGS(commandAddress,COMAND_PORT,{"print","not a valid number"})
            end
        end
    end
end

function getFluidId(commandAddress,eventID,fluidServer)
    local msgId = eventhandler.addChanelRandome(msger)
    local msgEventID = fluidServer.getEventID()
    fluidServer.sendMSG(modem,{"get_IDs",msgId})
    local msgEvent = {event.pull(msgEventID)}
    if msgEvent[6] == "id_send" then
        local colorIds = serialization.unserialize(msgEvent[8])
        local color = getColor(commandAddress,eventID,colorIds)
        local newFluidLoadId = color
        local loop = true
        while loop do
            loop = false
            for k,v in pairs(colorIds) do
                if newFluidLoadId ==  k then
                    newFluidLoadId = newFluidLoadId + 1
                    loop = true
                    break
                end
            end
            if not loop then
                fluidServer.sendMSG(modem,{"set_ID",msgId,newFluidLoadId,color})
                local success = {event.pull(msgEventID)}
                if success[6] ~= "id_seted" and not success[8] then
                    loop = true
                end
            end
        end
        eventhandler.removeChannel(msgId)
        return newFluidLoadId
    end
end

function addNewAssline(Event,arg)
    local function msger(Event)
        local eventID,_ = string.gsub(Event[3],"-","_")
        table.remove(Event,1)
        event.push(eventID,table.unpack(Event))
    end
    COMMAND_FUNCIONS[Event[3]] = msger
    local eventID,_ = string.gsub(Event[3],"-","_")
    local newAss = getAsslineName(Event,eventID)
    sendMSGS(Event[3],COMAND_PORT,{"print","select servers in order"})
    local length = newAss.length
    local index = 0
    local loop = true
    local serverNumber = 0
    while loop do
        local serverIndex = getUnitialisedItemServer(Event,eventID,ITEM_SERVERS)
        local server = ITEM_SERVERS[serverIndex]
        local componentCount = 4
        print("index",index)
        if length < index+4 then
           componentCount = length - index
            loop = false
        end
        print("comps",componentCount)
        serverNumber = serverNumber + 1
        index = initialiseItemServer(server,componentCount,index,Event[3],newAss,serverNumber)
        if index == length then
            
            sendMSGS(Event[3],COMAND_PORT,{"print","assline configured if a interface is mined or broken assline needs to be reconfigured"})
            break
        end
    end
    local fluidServer = getFluidServer(Event[3],eventID)
    local loadingId = getFluidId(Event[3],eventID,fluidServer)
    newAss.fluidId = loadingId
    COMMAND_FUNCIONS[Event[3]] = nil
    sendMSGS(Event[3],COMAND_PORT,{"print","assline configured"})
    newAss.initialized = true
    newAss.serverList[#newAss.serverList+1] = fluidServer
    save()
end



function resetServer(Event)
--     local function msger(Event)
--         local eventID,_ = string.gsub(Event[3],"-","_")
--         table.remove(Event,1)
--         event.push(eventID,table.unpack(Event))
--     end
--     COMMAND_FUNCIONS[Event[3]] = msger
--     local inactiveServers = {}
--     local eventID,_ = string.gsub(Event[3],"-","_")
--     local server = nil
--     while true do
--         for k,v in pairs(ITEM_SERVERS) do
--             if not v.initialised then
--                 inactiveServers[#inactiveServers+1] = {index=k,address=v.address,name=v.name,type="item"}
--             end
--         end
--         for k,v in pairs(FLUID_SERVERS) do
--             if not v.initialised then
--                 inactiveServers[#inactiveServers+1] = {index=k,address=v.address,name=v.name,type="fluid"}
--             end
--         end
--         sendMSGS(Event[3], COMAND_PORT, {"print","select server to reset"})
--         sendMSGS(Event[3], COMAND_PORT, {"print_table",inactiveServers})
--         local number = 0
        
--         while true do
--             sendMSGS(Event[3], COMAND_PORT, {"set_static","index number:"})
--             number = {event.pull(eventID)}
--             number = number[8]
--             sendMSGS(Event[3], COMAND_PORT, {"print","index number:"..number})
--             number = tonumber(number)
--             if number == nil  then
--                 sendMSGS(Event[3], COMAND_PORT, {"print","given number is a not a number"})
--                 break
--             end
--             for k,v in pairs(inactiveServers) do
--                 if v.index == number then
--                     server = v
--                 end
--             end
--             sendMSGS(Event[3], COMAND_PORT, {"print",number.." is a not a valid number"})
--             break
--         end
--         if server ~= nil then
--             break
--         end
--     end
--     if server.type == "item" then
--         server = ITEM_SERVERS[server.k]
--     elseif server.type == "fluid" then
--         server = FLUID_SERVERS[server.k]
--     end



--     COMMAND_FUNCIONS[Event[3]] = nil
end

function getStatus(commandAddress)
    printTable = {}
    --{index=k,address=v.address,name=v.name}
    for k,v in pairs(ASSLINES) do
        printTable[#printTable+1] = {index = k,name=v.name,length=v.length,fluidId=v.fluidId,access=v.access}
        if v.error ~= "" then
            printTable[#printTable].error = v.error
        end
    end
    sendMSGS(commandAddress, COMAND_PORT, {"print_table",serialization.serialize(printTable)})
end

function stringNil(In)
    if In == nil then
        return "nil"
    else
        return tostring(In)
    end
end

--event functions
function eventDefauld(event)
    print("defauld message recived")
    if event[1] == "modem_message" then
        if event[6] == "print" then
            print(event[8])
        elseif event[6] == "error" then
            --TODO add error handeling
            print(event[8],event[9])
        elseif event[6] == "bad_configuration" then
            --TODO reset the component if existed
        elseif event[6] == "get_host" then
            registerLoadServer(event)
        end
    end
end

function eventAwake(event)
    print("awake_recived")
    if event[6] ~= "awake" then
        return
    end
    registerLoadServer(event)
end

function comandLine(event)
    local func = COMMAND_FUNCIONS[event[3]]
    if func ~= nil then
        func(event)
        return
    end
    sendMSGS(event[3],COMAND_PORT,{"print",event[8]})
    local command,arg = processCommand(event[8])
    if command == "add_assline" then
        addNewAssline(event,arg)
    elseif command == "check_server" then
        sendMSGS(event[3],COMAND_PORT,{"print","checking server working"})
        local success = ASSLINES[1].checkWorking(modem)
        print("checkr servers")
        sendMSGS(event[3],COMAND_PORT,{"print",tostring(success)})
    elseif command == "get_fluids" then
        local server =  FLUID_SERVERS[1]
        if server == nil then
            sendMSGS(event[3],COMAND_PORT,{"print","no fluid servers found"})
        else
            local fluids = server.getFluids(modem)
        end
    elseif command == "set_id" then
        if arg == nil then
            sendMSGS(event[3], COMAND_PORT, {"print","args are nil"})
            return
        end
        arg[1] = tonumber(arg[1])
        arg[2] =  tonumber(arg[2])
        if type(arg[1]) ~= "number" or type(arg[2]) ~= "number" then
            sendMSGS(event[3],COMAND_PORT,{"print","set_id "..stringNil(arg[1]).." "..stringNil(arg[2]).." are not numbers"})
            return
        end
        local server = FLUID_SERVERS[1]
        if server == nil then
            sendMSGS(event[3],COMAND_PORT,{"print","no fluid servers found"})
        else
            print(arg[1],arg[2],print("args"))
            local success = server.addId(modem,arg[1],arg[2])
            sendMSGS(event[3],COMAND_PORT,{"print","id got added = "..tostring(success),})
        end
    elseif command == "get_ids" then
        local server = FLUID_SERVERS[1]
        if server == nil then
            sendMSGS(event[3],COMAND_PORT,{"print","no fluid servers found"})
            return
        end
        local IDs = server.getIds(modem)
        print(IDs)
    elseif command == "test_fluid" then
        local server = FLUID_SERVERS[1]
        if server ~= nil then
            local fluidName = {"Molten Soldering Alloy","Oxygen Plasma","Nitrogen Plasma"}
            local fluidAmount = {150,99,404}
            local fluidId = 7
            print("load")
            print(server.load)
            server.load(modem,fluidName,fluidAmount,fluidId,{s=false})
        else
            print("server nil")
        end
    elseif command == "tl" then
        local recipe = {}
        print("make recipe")
        -- r.addRecipy("Lapotronic Energy Orb Cluster",{{1,"Multilayer Fiber-Reinforced Circuit Board"},{32,"Europium Foil"},{4,6,1}
        -- ,{36,"Engraved Lapotron Chip"},{36,"Engraved Lapotron Chip"},{64,"High Power IC"},{32,"SMD Diode"},{32,"SMD Capacitor"},{32,"SMD Resistor"}
        -- ,{32,"SMD Transistor"},{64,"Fine Platinum Wire"}}
        -- ,{{720,"Molten Soldering Alloy"}}
        -- )
        recipe.ingredient = {{1,"Multilayer Fiber-Reinforced Circuit Board"},{64,"Naquadah Alloy Foil"},{4,"Nanoprocessor Mainframe"}
        ,{36,"Engraved Lapotron Chip"},{36,"Engraved Lapotron Chip"},{64,"High Power IC"},{8,"Advanced SMD Diode"},{8,"Advanced SMD Capacitor"},{8,"Advanced SMD Resistor"}
        ,{8,"Advanced SMD Transistor"},{64,"Fine Platinum Wire"}}
        recipe.fluid = {}
        recipe.fluid.recipy = {{720,"Molten Soldering Alloy"}}
        local ass = ASSLINES[1]
        print("check nill")
        if ass == nil then
            sendMSGS(event[3], COMAND_PORT, {"print","assline is nil"})
            return
        end
        local success = {s=false}
        print("loading starts")
        ass.load(recipe,1,modem,success)
        print("loading done")
        sendMSGS(event[3], COMAND_PORT, {"print","success"..tostring(success.s)})
    elseif command == "reset_server" then
        --resetServer(event)
    elseif command == "get_status" then
        getStatus(event[3])
    else
        sendMSGS(event[3],COMAND_PORT,{"print",command.." is not a valid command"})
    end

end


-- setup on start
modem.open(200)
modem.open(201)
local listnerThread = thread.create(eventhandler.run,eventDefauld,modem,{1,eventAwake},{4,comandLine})
setings.set("servers")
load()
print(#ASSLINES)


os.sleep(8)
while true do
    runAsslines()
    os.sleep(5)
end

listnerThread:kill()

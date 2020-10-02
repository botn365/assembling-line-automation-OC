filesystem = require("filesystem")
--options
lines = 500 -- thae amount of lines 
charachters = 60 -- amount of charachters per line minimum is 28
-- takes in 12 charchters
logers = {}
line = 0
location = "/assline/logs.txt"
L_F = 0

logger = {}

function logger.init() --genartaes log file if it does not exists
    if charachters < 28 then
        charachters =  28
    end
    if not filesystem.exists(location) then
        local file = filesystem.open(location,"w")
        file:close()
        file = io.open(location,"w")
        file:write("1         \n")
        file:close()
        --crash()
    end
    line = logger.getLineLocation()
end

function logger.log(name,contents) -- what you call to log stuff (name of the logger function,table of its contents)
    for k , v in pairs(logers) do
        if k == name then
            local file = io.open(location,"a")
            for i = 1 , v.length do
                if type(contents[i]) == "table" then
                    logTable(v.names[i],contents[i],file)
                    file:write("test")
                else
                    logSingle(v.names[i],contents[i],file)
                end
            end
            logger.newLine(L_F)
            file:close()
            break
        end
    end
end

function logSingle(name,contents,file)
    local temp = ""
    local L_C = 0
    local add = false
    if name ~= "nil" then
        temp = tostring(name) .. " = " .. tostring(contents)
    else
        temp = tostring(contents)
    end
        if L_F ~= 0 then
            add = true
        end
        L_C = #temp
        if add then
            L_C = L_C + 1
        end
        L_F =  L_F + L_C
    if L_F > charachters then
        if L_C > charachters then
            file:write("cant log over charachter lim")
            logger.newLine(28)
        else

            logger.newLine(L_F - L_C)
            file:seek("set",logger.getExextPos(line))
            file:write(temp)
        end
    else
        if add then
            temp = ";"..temp
        end
        file:seek("set",logger.getExextPos(line) + L_F - L_C)
        file:write(temp)
    end
end

function logTable(name,table,file)
    local temp = name
    if name ~= "nil" then
        temp = temp.." = "
        if (L_F + #temp) > charachters -1 then
            logger.newLine(L_F)
            L_F = #temp
            file:seek("set",logger.getExextPos(line))
            file:write(temp)
        else   
            file:seek("set",logger.getExextPos(line)+L_F)
                L_F = L_F + #temp
            file:write(temp)
        end
    end
    if L_F > (charachters - 2) then
        logger.newLine(L_F)
    end
    file:write("{")
    L_F = L_F + 1
    local count = 0
    local tableL = 0
    for k,v in pairs(table) do
        tableL =  tableL + 1
    end
    for k , v in pairs(table) do
        count = count + 1
        if type(v) == "table" then
            if type(k) == "string" then
                logTable(k,v,file)
            else
                logTable("nil",v,file)
            end
        else
            if type(k) == "string" then
                temp = k.." = "..tostring(v)
            else
                temp = tostring(v)
            end
            if L_F == 0 then
                file:seek("set",logger.getExextPos(line))
                if #temp > charachters then
                    file:write("cant log over charachter lim")
                    logger.newLine(28)
                else
                    L_F =  L_F + #temp
                    file:write(temp)
                end
            else
                if (L_F + #temp) < charachters then
                    file:seek("set",logger.getExextPos(line) + L_F)
                    temp2 = temp
                    L_F = L_F + #temp2
                    file:write(temp2)
                else
                    logger.newLine(L_F)
                    file:seek("set",logger.getExextPos(line))
                    L_F = #temp
                    file:write(temp)
                end
            end
        end 
        if count < tableL then
            if L_F > charachters - 1 then
                logger.newLine(L_F)
            end
            file:write(",")
            L_F = L_F + 1
        end
    end
    if L_F > charachters - 1 then
        logger.newLine(L_F)
    end
    file:write("}")
    L_F = L_F + 1
end

function logger.logRaw(data)
    local file = io.open(location,"a")
    if type(data) == "table" then
        logTable("nil",data,file)
    else
        logSingle("nil",data,file)
    end
    logger.newLine(L_F)
end

function logger.addLogger(name,nameArray) -- allows you to add a loger function 
    logers[name] = {}
    logers[name].length = #nameArray
    logers[name].names = nameArray
end

function logger.getLineLocation()
    local fileL = filesystem.open(location)
    local input = fileL:read(10)
    local pos = string.find(input," ")
    if pos == nil then
        pos = 10
    else
        pos = pos - 1
    end
    fileL:seek("set",0)
    input = fileL:read(pos)
    fileL:close()
    return tonumber(input)
end

function logger.setLineLocation(amount)
    local fileL = io.open(location,"a")
    local temp = tostring(amount)
    for i = 1 , (10 - #temp) do
        temp = temp.." "
    end
    temp = temp.."\n"
    fileL:seek("set",0)
    fileL:write(temp)
    fileL:close()
end

function logger.newLine(charchtersInLine)
    local temp = charachters - charchtersInLine
    local temp2 = logger.getExextPos(line) + charchtersInLine
    local toFile = ""
    for i = 1 , temp do
        toFile = toFile .. " "
    end
    toFile = toFile .. "\n"
    fileL = io.open(location,"a")  
    fileL:seek("set",temp2)
    fileL:write(toFile)
    fileL:close()
    line = line + 1
    if line > lines then
        line = 1 
    end
    L_F = 0
    logger.setLineLocation(line)
end

function logger.getExextPos(line_L)  -- get the exect carchacter
    local amount = 11
    local tempLine = line_L - 1
    amount = amount + tempLine * (charachters + 1)
    return amount
end

logger.init()
local a = {25,"36",45,{500}}
a.test = {10,11,{12,36,{25,45}}}
a.test2 = "testing 2"
logger.logRaw(a)

return logger
package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.CircuitOreDict=nil
package.loaded.config=nil
oredict = require("CircuitOreDict")
recipymap = require("Loadrecipy")
readchest = require("ReadChest")
filesystem = require("filesystem")
config = require("config")
local event = require("event")
goback = -800
pos = 0
itemstack = {}
fluidstack = {}
circuitlist = oredict.getlist()
itemTransposer = config.addrestransposeritem
fluidTransposer1 = config.addrestransposerfluid1
fluidTransposer2 = config.addrestransposerfluid2
function ifavailbel(file,tobyte,Pdata)
    file:seek("cur",tobyte)
    local read = file:read(-tobyte)
    local data =  string.find(read,"r.addRecipy")
    if data then
        Pdata.A = tobyte + data
        return true
    else 
        return nil
    end
end
iscircuitordict = true

print("include circuir oredict? press N to not include it ")
event.pull(0)
_,_,ch = event.pull()
if ch == 110 then
    iscircuitordict = false
end
os.sleep(1)
print("endet name of output press enter to confirm")
local name = ""
event.pull(0)
repeat
    a,_,ch = event.pull()
    if ch ~= 13 and a == "key_down" then
        name = name..string.char(ch)
    end
until ch == 13
print(name)



file = filesystem.open("/assline/Loadrecipy.lua")
file:seek("end",0)
data = {}
while ifavailbel(file,goback,data) do
    pos = data.A - 1
    goback = pos + 10
end
file:seek("end",pos)
lastadd = file:read(-pos)
--print(lastadd)
location = string.find(lastadd,")\n")
if location == nil then
    location = string.find(lastadd,")\r\n")  
end
location = location + 1 + pos
--print(location)
file:close()
itemstack.count = 0
local stick = itemTransposer.getStackInSlot(1,1)
if stick == nil or  stick.label ~= "gt.metaitem.01.32708.name" then
    print("not a datastick")
    return nil
end
if stick.eu == nil then
    print("not a valid stick")
end
-- for i = 1 , 15 do
--     local tempitemstack = itemTransposer.getStackInSlot(1,i)
--     if tempitemstack == nil or tempitemstack.name == "minecraft:stick"  then
--         break
--     else
--         local skip = false
--         if iscircuitordict then
--             for k,v in pairs(circuitlist) do
--                 for g,h in pairs(v) do
--                     if tempitemstack.label == h then
--                         skip = true
--                         itemstack.count = itemstack.count + 1
--                         itemstack[i] = "{"..tempitemstack.size..","..3+k..",1}"
--                         break
--                     end
--                     if skip then break end
--                 end
--             end
--         end
--         if skip == false then
--             itemstack.count = itemstack.count + 1
--             itemstack[i] = "{"..tempitemstack.size..",\""..tempitemstack.label.."\"}"
--         end
--     end 
-- end
for  pos,item in pairs(stick.inputItems)do
    if pos == "n" then
        break
    end
    if iscircuitordict then
        local tier = oredict.isCircuit(item[1])
        if tier > 0 then
            itemstack.count = itemstack.count + 1
            itemstack[pos] = "{"..item[2]..","..tier..",1}"
        else
            itemstack.count = itemstack.count + 1
            itemstack[pos] = "{"..item[2]..",\""..item[1].."\"}"
        end
    else
        itemstack.count = itemstack.count + 1
        itemstack[pos] = "{"..item[2]..",\""..item[1].."\"}"
    end
end

--local tempfluidstack = readchest.readFluid(4,fluidTransposer2,fluidTransposer1,nil,config.directionloader.directionfluid2)


tempfluidstack = stick.inputFluids
fluidstack.count = 0
for i = 1 , #tempfluidstack do
    fluidstack.count = fluidstack.count + 1
    fluidstack[i] = {tempfluidstack[i][2],tempfluidstack[i][1]}
end
if name == "" then
    name = stick.output
end


recipy = "r.addRecipy(\""..name.."\",{"
for i = 1 , itemstack.count do
    if i > 1 then
        recipy = recipy..","..itemstack[i]
    else
        recipy = recipy..itemstack[i]
    end
end
recipy =  recipy.."}\n,{"
for i = 1 , fluidstack.count do
    if i > 1 then
        recipy = recipy..",{"..fluidstack[i][1]..",\""..fluidstack[i][2].."\"}"
    else
        recipy = recipy.."{"..fluidstack[i][1]..",\""..fluidstack[i][2].."\"}"
    end
end
recipy =  recipy.."}\n)"
print("press enter to make item or any other key to reject")
print(recipy)
event.pull(0)
_,_,ch = event.pull()
if ch == 13 then
    file = io.open("/assline/Loadrecipy.lua","a")
    file:seek("end",location)
    file:write(recipy.."\n\n\nreturn r")
    file:close()
end

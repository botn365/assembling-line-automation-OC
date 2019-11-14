package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
package.loaded.LoadAssline=nil
package.loaded.config=nil
package.loaded.Recipy = nil
component = require("component")
loadassline = require("LoadAssline")
findmatch = require("FindMatch")
config = require("config")
local readchest = require("ReadChest")
local recipymap = require("Recipy")
local event = require("event")

local itemTransposer = config.addrestransposeritem
local fluidTransposer1 = config.addrestransposerfluid1
local fluidTransposer2 = config.addrestransposerfluid2
local redstoneassline = config.addresredstoneassline
local redstoneloader = config.addresredstoneloader
local recipystack = recipymap.RecipyArray({})
local itemstack = {}
local fluidstack = {}

for i = 1 , 15 do
    local tempitemstack = itemTransposer.getStackInSlot(1,i)
    if tempitemstack == nil then
        break
    else
        itemstack[i] = {tempitemstack.size,tempitemstack.label}
    end 
end
local tempfluidstack = readchest.readFluid(4,fluidTransposer2,fluidTransposer1,config.directionloader.directionfluid2)
for i = 1 , tempfluidstack.length do
    fluidstack[i] = {tempfluidstack.fluid[i].size,tempfluidstack.fluid[i].label}
end
recipystack.addRecipy("out",itemstack,fluidstack)
local cheststack = readchest.getInventory(1,itemTransposer,recipystack.substitude,fluidTransposer1)
local tankstack = readchest.loadFluids(fluidTransposer2,fluidTransposer1)
local loadmap = findmatch.makeLoadMap(recipystack,1,1,cheststack.simpleinventory,tankstack)
local availble = {}
if findmatch.getAvailble(redstoneassline,config.directionredstoneassline,availble) then
    availble = availble.A
    for i = 1 , loadmap.length do
        if loadmap[i] then
            local a = 1
            if a == loadmap[i][1] then
            print("amount="..loadmap[i][2].."   item name= "..loadmap[i][5])
            end
        end
    end
    for i = 1 , loadmap.length do
        if loadmap[i] then
            local a = 2
            if a == loadmap[i][1] then
            print("amount="..loadmap[i][2].."   item name= "..loadmap[i][5])
            end
        end
    end
    for i = 1 , loadmap.length do
        if loadmap[i] then
            local a = 3
            if a == loadmap[i][1] then
            print("amount="..loadmap[i][2].."   item name= "..loadmap[i][5])
            end
        end
    end
    print("press enter to make item or any other key to reject")
    local typ,_,ch = event.pull()
    if typ == 'key_up' then
        _,_,ch = event.pull()
        if ch == 13 then
            loadassline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,1,availble[1])
        end
    end
else
    print("no availble assembling lines to make item")
end


package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
recipymap = require("Loadrecipy")
findmatch = require("FindMatch")
ReadChest = require("ReadChest")
local component = require("component")
local itemTransposer = component.proxy("af607168-70c3-4528-b702-77b3cbbc0a83")
local fluidTransposer = component.proxy("42cb088c-ece2-49e6-9efe-efc9cc6c508b")
local readchest = ReadChest.getInventory(1,itemTransposer)


--for i = 1 , recipymap.n[1].simplerecipy.length do
--  print(recipymap.n[1].simplerecipy[i].size..recipymap.n[1].simplerecipy[i].label)
--end

--for i = 1, chestarr.simpleinventory.length do
--  print(chestarr.simpleinventory[i].size..chestarr.simpleinventory[i].label)
--end
local fluid = ReadChest.getFluid(4,fluidTransposer)
local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid)
--print(matchnumber)
if matchnumber then
  local loadmap = findmatch.makeLoadMap(recipymap,matchnumber,
  findmatch.getMax(recipymap,matchnumber,readchest.simpleinventory,fluid),readchest.simpleinventory)
  for i = 1 , loadmap.length do
    if loadmap[i] then
        print("loader= "..loadmap[i][1].."  amount="..loadmap[i][2].."  from slot= "..loadmap[i][3].."  to slot= "..loadmap[i][4].."  item name= "..loadmap[i][5])
    else
        print("false")
    end
  end
end

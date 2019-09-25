package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
recipymap = require("Loadrecipy")
findmatch = require("FindMatch")
chest = require("ReadChest")
local component = require("component")
local itemTransposer = component.proxy("af607168-70c3-4528-b702-77b3cbbc0a83")
local chestarr = chest.getInventory(1,itemTransposer)


--for i = 1 , recipymap.n[1].simplerecipy.length do
--  print(recipymap.n[1].simplerecipy[i].size..recipymap.n[1].simplerecipy[i].label)
--end

--for i = 1, chestarr.simpleinventory.length do
--  print(chestarr.simpleinventory[i].size..chestarr.simpleinventory[i].label)
--end

local matchnumber = findmatch.findMatch(recipymap,chestarr.simpleinventory)
print(matchnumber)
if matchnumber then
    print(findmatch.getMax(recipymap,matchnumber,chestarr.simpleinventory))
end
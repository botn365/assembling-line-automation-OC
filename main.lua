package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
package.loaded.LoadAssline=nil
package.loaded.config=nil
local config = require("config")
local recipymap = require("Loadrecipy")
local findmatch = require("FindMatch")
local ReadChest = require("ReadChest")
local component = require("component")
local LoadAssline = require("LoadAssline")
local event = require("event")
local itemTransposer = config.addrestransposeritem
local fluidTransposer1 = config.addrestransposerfluid1
local fluidTransposer2 = config.addrestransposerfluid2
local redstoneassline = config.addresredstoneassline
local redstoneloader = config.addresredstoneloader
print("hold\"any key\" to shut down program")
if config.use_enderchest then 
  redstoneassline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
else
  redstoneassline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
end
while true do
  local readchest = ReadChest.getInventory(1,itemTransposer,recipymap.substitude,fluidTransposer1)--getconten of chest
  local fluid = ReadChest.loadFluids(fluidTransposer2,fluidTransposer1)-- gets and sorts fluids
  local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid) -- looks for valid recipy
  if matchnumber then
    local amount = findmatch.getMax(recipymap,matchnumber,readchest.simpleinventory,fluid) --check how many recipys it can make
    if amount > config.Assline_max_item then 
      amount = config.Assline_max_item
    end
    if amount > 0 then
      local loadmap = findmatch.makeLoadMap(recipymap,matchnumber,amount,readchest.simpleinventory,fluid)-- makes the load map of the recipy
     -- for i = 1 , loadmap.length do
       -- if loadmap[i] then
         -- print("loader= "..loadmap[i][1].."  amount="..loadmap[i][2].."  from slot= "..loadmap[i][3].."  to slot= "..loadmap[i][4].."  item name= "..loadmap[i][5])
       -- else
         -- print("false")
       -- end
     -- end
      LoadAssline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,amount)--loads the assline with items and fluid
    end
  end
  local ch=event.pull(1)
  if ch == 'key_down' then
    break
  end
end
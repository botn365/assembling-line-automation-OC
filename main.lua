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
local --asslinetransposser = config.addrestransposerassline

--if package.path == "/lib/?.lua;/usr/lib/?.lua;/home/lib/?.lua;./?.lua;/lib/?/init.lua;/usr/lib/?/init.lua;/home/lib/?/init.lua;./?/init.lua;/asslines/?.lua" then
  --package.path == package.path..";/asslines/?.lua"
--end

function key(time)
  local ch=event.pull(time)
  if ch == 'key_down' then
    return true
  end
  return false
end


print("hold\"any key\" to shut down program")
if config.use_enderchest then -- configurs the redstone of the assline to deafault
  for k , v in pairs(config.directionredstoneassline) do
    redstoneassline[k].setBundledOutput(v,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
  end
else
  for k , v in pairs(config.directionredstoneassline) do
    redstoneassline[k].setBundledOutput(v,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
  end
end
redstoneloader.setOutput(0,0)
while true do
  local availble = {}
  if findmatch.getAvailble(redstoneassline,config.directionredstoneassline,availble) then
    availble = availble.A
    local readchest = ReadChest.getInventory(1,itemTransposer,recipymap.substitude,fluidTransposer1)--getconten of chest
    local fluid = ReadChest.loadFluids(fluidTransposer2,fluidTransposer1)-- gets and sorts fluids
    local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid) -- looks for valid recipy
    if matchnumber then
      if true then 
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
          LoadAssline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,amount,availble[1])--loads the assline with items and fluid
        end
      end
    end
  end
  if key(5) then
    break
  end
end


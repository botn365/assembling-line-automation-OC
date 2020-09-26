package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
package.loaded.LoadAssline=nil
package.loaded.config=nil
config = require("config")
recipymap = require("Loadrecipy")
findmatch = require("FindMatch")
ReadChest = require("ReadChest")
component = require("component")
LoadAssline = require("LoadAssline")
event = require("event")
--logger = require("logger")
itemTransposer = config.addrestransposeritem
fluidTransposer1 = config.addrestransposerfluid1
fluidTransposer2 = config.addrestransposerfluid2
fluidTransposer3 = config.addrestransposerfluid3
redstoneassline = config.addresredstoneassline
redstoneloader = config.addresredstoneloader
startIndex = 1
noFind = true;
keyTime = 5
 --asslinetransposser = config.addrestransposerassline

--if package.path == "/lib/?.lua;/usr/lib/?.lua;/home/lib/?.lua;./?.lua;/lib/?/init.lua;/usr/lib/?/init.lua;/home/lib/?/init.lua;./?/init.lua;/asslines/?.lua" then
  --package.path == package.path..";/asslines/?.lua"
--end

--logger.init()
--logger = 0
--logger.addLogger("chest_data",{"availble","get inventory","loadfluids","matchnumber"})
--logger.addLogger("amount",{"amount"})
--logger.addLogger("loadmap",{"loadmap"})

function key(time)
  local ch=event.pull(time)
  if ch == 'key_down' then
    return true
  end
  return false
end

--logger.logRaw("program start")
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
--redstoneloader.setOutput(0,0)
while true do
  local availble = {}
  if findmatch.getAvailble(redstoneassline,config.directionredstoneassline,availble) then
    availble = availble.A
    if startIndex < 1 then
      startIndex = 1
    end
    local readchest = ReadChest.getInventory(1,itemTransposer,recipymap.substitude,fluidTransposer1)--getconten of chest
    local fluid = ReadChest.loadFluids(fluidTransposer2,fluidTransposer1,fluidTransposer3)-- gets and sorts fluids
    local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid,startIndex) -- looks for valid recipy
    --logger.log("chest_data",{availble,"nil","nil",matchnumber})
    if matchnumber then
      if true then 
        local amount = findmatch.getMax(recipymap,matchnumber,readchest.simpleinventory,fluid) --check how many recipys it can make
        if amount > config.Assline_max_item then 
          amount = config.Assline_max_item
        end
        if amount< config.Assline_max_item then
          startIndex = matchnumber + 1
        end
        --logger.log("amount",{amount})
        if amount > 0 then
          local loadmap = findmatch.makeLoadMap(recipymap,matchnumber,amount,readchest.simpleinventory,fluid)-- makes the load map of the recipy
          --logger.log("loadmap",{loadmap})
          LoadAssline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,fluidTransposer3,amount,availble[1],logger)--loads the assline with items and fluid
          noFind = false
          --print("a"..nil)
        end
      end
    else
      startIndex = -1
    end
  end
    keyTime = 0.1
  if startIndex == -1 then
    if noFind then
      keyTime = 5
    end
    noFind = true
  end
  if key(keyTime) then
    break
  end
end
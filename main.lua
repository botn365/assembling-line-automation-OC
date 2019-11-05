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
local asslinetransposser = config.addrestransposerassline

function key(time)
  print("pass pull")
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
while true do
  local availble = {}
  if findmatch.getAvailble(redstoneassline,config.directionredstoneassline,availble) then
    availble = availble.A
    print("is availble")
    for k, v in pairs(availble) do print(k,v) end
    print("read chest")
    local readchest = ReadChest.getInventory(1,itemTransposer,recipymap.substitude,fluidTransposer1)--getconten of chest
    print("read fluid")
    local fluid = ReadChest.loadFluids(fluidTransposer2,fluidTransposer1)-- gets and sorts fluids
    print("read matchnumber")
    local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid) -- looks for valid recipy
    print("leaf matchnumber")
    if matchnumber then
      local nassline = {}
      if findmatch.matchAsslineRecipys(addresassline,availble,recipymap.n[matchnumber],nassline) then
        nassline = nassline.A
        print("foun match")
        print(nassline)
        local amount = findmatch.getMax(recipymap,matchnumber,readchest.simpleinventory,fluid) --check how many recipys it can make
        if amount > config.Assline_max_item then 
          amount = config.Assline_max_item
        end
        if amount > 0 then
          print("loadmap")
          local loadmap = findmatch.makeLoadMap(recipymap,matchnumber,amount,readchest.simpleinventory,fluid)-- makes the load map of the recipy
          -- for i = 1 , loadmap.length do
            -- if loadmap[i] then
              -- print("loader= "..loadmap[i][1].."  amount="..loadmap[i][2].."  from slot= "..loadmap[i][3].."  to slot= "..loadmap[i][4].."  item name= "..loadmap[i][5])
            -- else
              -- print("false")
            -- end
          -- end
          print("loading")
          LoadAssline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,amount,nassline)--loads the assline with items and fluid
          print("done")
        end
      end
    end
  end
  if key(5) then
    break
  end
end


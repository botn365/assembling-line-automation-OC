package.loaded.Loadrecipy=nil
package.loaded.ReadChest=nil
package.loaded.FindMatch=nil
package.loaded.LoadAssline=nil
local recipymap = require("Loadrecipy")
local findmatch = require("FindMatch")
local ReadChest = require("ReadChest")
local component = require("component")
local LoadAssline = require("LoadAssline")
local event = require("event")
local itemTransposer = component.proxy("af607168-70c3-4528-b702-77b3cbbc0a83")
local fluidTransposer1 = component.proxy("42cb088c-ece2-49e6-9efe-efc9cc6c508b")
local fluidTransposer2 = component.proxy("ac7764f5-0050-4252-88fb-08290ced5ae9")
local redstoneassline = component.proxy("4f453e3e-b4bf-4176-9919-01cc43d4fb18")
local redstoneloader = component.proxy("60cb8d12-191c-4724-a0a0-a3c012bb20c5")
print("hold\"s\" to shut down program")

while true do
  print("loop")
  local readchest = ReadChest.getInventory(1,itemTransposer,recipymap.substitude,fluidTransposer1)--getconten of chest
  local fluid = ReadChest.loadFluids(fluidTransposer2)-- gets and sorts fluids
  local matchnumber = findmatch.findMatch(recipymap,readchest.simpleinventory,fluid) -- looks for valid recipy
  if matchnumber then
    local amount = findmatch.getMax(recipymap,matchnumber,readchest.simpleinventory,fluid) --check how many recipys it can make
    if amount > 14 then 
      amount = 14
    end
    if amount > 0 then
      local loadmap = findmatch.makeLoadMap(recipymap,matchnumber,amount,readchest.simpleinventory,fluid)-- makes the load map of the recipy
      LoadAssline.load(loadmap,itemTransposer,redstoneassline,redstoneloader,fluidTransposer1,fluidTransposer2,amount)--loads the assline with items and fluid
    end
  end
  os.sleep(1)
  local _,_,_,ch=event.pull('key_down')
  if ch == 31 then
    break
  end
end
--for i = 1 , loadmap.length do
    --if loadmap[i] then
      --  print("loader= "..loadmap[i][1].."  amount="..loadmap[i][2].."  from slot= "..loadmap[i][3].."  to slot= "..loadmap[i][4].."  item name= "..loadmap[i][5])
    --else
      --  print("false")
    --end
  --end
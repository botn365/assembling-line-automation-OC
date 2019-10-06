local ReadChest = {}
package.loaded.config=nil
local config = require("config")

function ReadChest.makeShort(inventory,size)
  local simpleinventory = objSimpleArr()
  local isequal = 0
  simpleinventory.new(inventory[0])
  simpleinventory.newlocation(1,inventory,0)
  for i = 1,size-1 do
    if inventory[i].label ~= nil and inventory[i].name ~= "minecraft:stick" then 
      for j = 1 ,simpleinventory.length do 
        if simpleinventory[j].label == inventory[i].label then
          simpleinventory[j].size = simpleinventory[j].size + inventory[i].size
          simpleinventory.newlocation(j,inventory,i)
          isequal = 1
        end
      end
    if isequal == 0 then 
      simpleinventory.new(inventory[i])
      simpleinventory.newlocation(simpleinventory.length,inventory,i)
    else isequal = 0 end
    end
  end  
  return simpleinventory
end

function ReadChest.getFluid(side,addres) -- fluid needs to be reworked
  local temp = addres.getFluidInTank(side)
  local object = {}
  object.fluid = {}
  object.length = 0
  for k,v in pairs(temp) do 
    if v == 1 then
      break
    elseif v.label ~= nil then
      object.fluid[object.length + 1] = {}
      object.fluid[object.length + 1].label = v.label
      object.fluid[object.length + 1].size = v.amount
      object.length = object.length + 1
    end
  end
  return object
end  

function objSimple()
  local object = {}
  object.size = 0
  object.label = 0
  object.location = {}
  object.location.length = 0
  return object
end

function objSimpleArr()
  local object = {}
  object.length = 0
  function object.new(a)
    object[object.length+1] = objSimple()
    object.length = object.length + 1
    if a ~= nil then 
      object[object.length].size = a.size
      object[object.length].label = a.label
    end
  end
  function object.newlocation(a,b,c)
    local temp = object[a].location[object[a].location.length+1]
    temp ={}
    temp.size = b[c].size
    temp.slot = c+1
    object[a].location.length = object[a].location.length + 1
    object[a].location[object[a].location.length] = temp
  end
  return object
end
    

function ReadChest.getInventory(side,addres,subs,addresTop)
  local object = {}
  local inventory = addres.getAllStacks(side).getAll()
  local size = addres.getAllStacks(side).count()
  getInbetween(subs,addresTop,side,size,inventory)
  object.simpleinventory = ReadChest.makeShort(inventory,size)
  return object
end

function objFluid(label,size,tank)
  local object = {}
  object.label = label
  object.size = size
  object.tank = tank
  return object
end

function objFluidArr()
  local object = {}
  object.length = 0
  object.fluid = {}
  function object.newFluid(label,size,tank)
    object.fluid[object.length + 1] = objFluid(label,size,tank)
    object.length = object.length + 1
  end
  return object
end

function readFluid(Ntanks,address,addres2,position)
  local fluid = objFluidArr()
  for i = 1 , Ntanks do --reads the fluid of tanks and stores it
    local temp
    if i < 4 then
      temp = address.getFluidInTank(position[i])
    else
      temp = addres2.getFluidInTank(1)
    end
    if temp[1].label ~= nil and i ~= 4 then
      fluid.newFluid(temp[1].label,temp[1].amount,i)
    elseif i == 4 and temp[1].label ~= nil then
      fluid.newFluid(temp[1].label,temp[1].amount,i)
    end
  end
  return fluid
end

function ReadChest.loadFluids(address,addres2)
  local position = config.directionloader.directionfluid2
  local capacity = 256000
  while address.getFluidInTank(0)[1].label ~= nil and fluid.length < 4 do
    fluid = readFluid(4,address,addres2,position)
    local pass = true
    local temp  = address.getFluidInTank(0)[1]
    for i = 1 , 3 do
      if fluid.fluid[i] ~=  nil then
        if fluid.fluid[i].label == temp.label then
          pass = false
          local maxsize = 256000 - fluid.fluid[i].size
          if temp.amount < maxsize then
            if fluid.fluid[i].tank ~= 4 then
              address.transferFluid(0,position[fluid.fluid[i].tank],temp.amount)
            else
              address.transferFluid(0,posistion[5],temp.amount)
              addres2.transferFluid(posistion[3],1,temp.amount)
            end
            break
          else
            if fluid.fluid[i].tank ~= 4 then
              address.transferFluid(0,position[fluid.fluid[i].tank],maxsize)
            else
              address.transferFluid(0,posistion[5],maxsize)
              addres2.transferFluid(posistion[3],1,maxsize)
            end
            break
          end
        end
      end
    end
    if pass then
      local breakf = false
      for j = 1 , 4 do
        if fluid.length == 0 then
          address.transferFluid(0,position[j],temp.amount)
          break
        end
        for k = 1 , fluid.length do
          if fluid.fluid[k].tank == j then
            break
          end
          if k == fluid.length then
            if j ~= 4 then
              address.transferFluid(0,position[j],temp.amount)
            else
              address.transferFluid(0,posistion[5],temp.amount)
              addres2.transferFluid(posistion[3],1,temp.amount)
            end
           breakf = true
           break
          end
        end
        if breakf then
          break
        end
      end
    end
    os.sleep(0.2)
    fluid = readFluid(4,address,addres2,position)
  end
  return fluid
end

function getInbetween(subs,addresTop,side,size,inventory)
  local arrIn = {}
  arrIn.count = 0
  local arrOut = {}
  arrOut.count = 0
  for i = 0 , size - 1 do
    local found = true
    if inventory[i].name == "minecraft:stick" then
      for j = 1 , subs.length do
        if inventory[i].label == subs[j][2] then
          arrOut[arrOut.count + 1] = {}
          arrOut[arrOut.count + 1].label = subs[j][2]
          arrOut[arrOut.count+ 1].size = inventory[i].size
          arrOut[arrOut.count+ 1].j = j
          arrOut[arrOut.count+ 1].slot = i + 1
          arrOut.count = arrOut.count + 1
          found = false 
          break
        end
      end
      if found then 
        for j = 1 , subs.length do
          if inventory[i].label == subs[j][1] then
            arrIn[arrIn.count+ 1] = {}
            arrIn[arrIn.count+ 1].label = subs[j][1]
            arrIn[arrIn.count+ 1].size = inventory[i].size
            arrIn[arrIn.count+ 1].j = j
            arrIn[arrIn.count+ 1].slot = i + 1
            arrIn.count = arrIn.count + 1 
            break
          end
        end
      end
    end
  end
  for i = 1 , arrIn.count do
    for j = 1 , arrOut.count do
      if arrIn[i].j == arrOut[j].j then
        print("transport")
        addresTop.transferItem(0,config.directionloader.directionfluid2[2],arrIn[i].size,arrIn[i].slot,1)
        addresTop.transferItem(0,config.directionloader.directionfluid2[2],arrIn[i].size,arrOut[j].slot,1)
        break
      end
    end
  end
end

return ReadChest
--local test = getInventory()
--local inv = test.simpleinventory
--for i =1,test.simpleinventory.length do
  --print(inv[i].size..inv[i].label) 
  --for j =1,inv[i].location.length do
    --print("amount= "..inv[i].location[j].size.." slot=  "..inv[i].location[j].slot)
  --end
--end 
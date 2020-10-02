local ReadChest = {}
package.loaded.config=nil
local config = require("config")

function ReadChest.makeShort(inventory,size) -- makes  a compact version of the chest
  local simpleinventory = objSimpleArr()
  local isequal = 0
  local start = 0
  for i = 0, size-1 do
    if inventory[i].label ~= nil then
      simpleinventory.new(inventory[i])
      simpleinventory.newlocation(1,inventory,i)
      start = i+1
      break
    end
  end
  for i = start,size-1 do
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
  if simpleinventory.length == 0 then
    return nil
  else
    return simpleinventory
  end
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
    

function ReadChest.getInventory(side,addres,subs,addresTop) -- get a ordert kist of inventort
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

function ReadChest.readFluid(Ntanks,address,addres2,addres3,position,localpos) --reads the fluid of tanks and stores it
  local fluid = objFluidArr()
  for i = 1 , Ntanks do 
    local temp
    if i < 4 then
      temp = address.getFluidInTank(position[i])
    elseif i == 4 then
      temp = addres2.getFluidInTank(1)
    else
      temp = addres3.getFluidInTank(localpos[i-4])
    end
    --print(i)
    --print(position[i])
    if temp[1].label ~= nil and i ~= 4 then
      fluid.newFluid(temp[1].label,temp[1].amount,i)
    elseif i == 4 and temp[1].label ~= nil then
      fluid.newFluid(temp[1].label,temp[1].amount,i)
    end
  end
  return fluid
end

function spacefor(fluidpipe,fluidstored,maxcap,tankstostore) --- check if there is space to store the fluid
  for i = 1 , fluidstored.length do
    if fluidpipe.label == fluidstored.fluid[i].label then
      if fluidpipe.amount > maxcap then
        return true
      else 
        return false
      end
    end
  end
  if fluidstored.length < tankstostore then
    return false
  end
  return true
end

function ReadChest.loadFluids(address,addres2,addres3)  -- returns a fluid object with stored fluids
  local tankstostore = 6
  local position = config.directionloader.directionfluid2
  local localpos = {1,position[2]}
  local capacity = config.max_fluid_stored
  local fluid = ReadChest.readFluid(tankstostore,address,addres2,addres3,position,localpos)
  while address.getFluidInTank(0)[1].label ~= nil do
    local temp  = address.getFluidInTank(0)[1]
    if spacefor(temp,fluid,capacity,tankstostore) then
      break
    end
    local pass = true
    for i = 1 , tankstostore do
      if fluid.fluid[i] ~=  nil then
        if fluid.fluid[i].label == temp.label then
          pass = false
          local maxsize = capacity - fluid.fluid[i].size
          if temp.amount < maxsize then
            if fluid.fluid[i].tank < 4 then
              address.transferFluid(0,position[fluid.fluid[i].tank],temp.amount)
            elseif fluid.fluid[i].tank == 4 then
              address.transferFluid(0,position[5],temp.amount)
              addres2.transferFluid(position[3],1,temp.amount)
            else
              address.transferFluid(0,position[5],temp.amount)
              addres3.transferFluid(0,localpos[fluid.fluid[i].tank-4],temp.amount)
            end
            break
          else
            if fluid.fluid[i].tank < 4 then
              address.transferFluid(0,position[fluid.fluid[i].tank],maxsize)
            elseif fluid.fluid[i].tank == 4 then
              address.transferFluid(0,position[5],maxsize)
              addres2.transferFluid(position[3],1,maxsize)
            else
              address.transferFluid(0,position[5],maxsize)
              addres3.transferFluid(0,localpos[fluid.fluid[i].tank-4],maxsize)
            end
            break
          end
        end
      end
    end
    if pass then
      local breakf = false
      for j = 1 , tankstostore do --go trough all the tanks wher efluid can be stored
        if fluid.length == 0 then
          address.transferFluid(0,position[j],temp.amount)
          break
        end
        for k = 1 , fluid.length do  -- go trough all fluids that are stored 
          if fluid.fluid[k].tank == j then -- check if there is a fluid in the tank
            break
          end
          if k == fluid.length then -- if it has found a free tank store it transfer the fluid there
            if j < 4 then
              address.transferFluid(0,position[j],temp.amount)
            elseif j == 4 then
              address.transferFluid(0,position[5],temp.amount)
              addres2.transferFluid(position[3],1,temp.amount)
            else
              address.transferFluid(0,position[5],temp.amount)
              local p = addres3.transferFluid(0,localpos[j-4],temp.amount)
              if not p then
                print("failer to transfer fluid to tank ",j)
                print("direction to where the fluid should have transfered",localpos[j-4])
                local crash
                print(crash..crash)
              end
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
    os.sleep(0.05)
    fluid = ReadChest.readFluid(tankstostore,address,addres2,addres3,position,localpos) -- re read all the fluid that are stored
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
  local amount = 0
  for i = 1 , arrIn.count do
    for j = 1 , arrOut.count do
      if arrIn[i].j == arrOut[j].j then
        if arrIn[i].size > arrOut[j].size then
          amount = arrOut[j].size
          arrIn[i].size = arrIn[i].size - arrOut[j].size
          arrOut[j].size = 0
        else
          amount = arrIn[i].size
          arrOut[j].size = arrOut[j].size - arrIn[i].size
          arrIn[i].size = 0
        end
        print("transport Inbetween"..amount)
        addresTop.transferItem(0,config.directionloader.directionfluid2[2],amount,arrIn[i].slot,1)
        addresTop.transferItem(0,config.directionloader.directionfluid2[2],amount,arrOut[j].slot,1)
        break
      end
    end
  end
end

return ReadChest
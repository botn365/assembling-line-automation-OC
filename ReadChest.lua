local ReadChest = {}

function ReadChest.makeShort(inventory,size)
  local simpleinventory = objSimpleArr()
  local isequal = 0
  simpleinventory.new(inventory[0])
  simpleinventory.newlocation(1,inventory,0)
  for i = 1,size-1 do
    if inventory[i].label ~= nil then 
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

function ReadChest.getFluid(side,addres)
  local temp = addres.getFluidInTank(side)
  local object = {}
  object.fluid = {}
  object.length = 0
  for k,v in pairs(fluid) do 
    if v == 4 then
      break
    elseif v.label ~= nil then
      object.fluid[length + 1] = fluid.label
      length = length + 1
    end
  end
  return object
end  

function objSimple()
  local object = {}
  object.size = 0
  object.label = 0
  object.location = {}
  object.location["length"] = 0
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
    

function ReadChest.getInventory(side,addres)
  local object = {}
  local inventory = addres.getAllStacks(side).getAll()
  local size = addres.getAllStacks(side).count()
  object.simpleinventory = ReadChest.makeShort(inventory,size)
  return object
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
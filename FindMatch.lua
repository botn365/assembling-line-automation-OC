local FindMatch = {}

function FindMatch.makeLoadMap(recipy,n,amount,chest,fluidin)
  local loadmap ={}
  loadmap.length = 0
  local LS = 0
  if recipy.n[n].length < 5 then
    LS = recipy.n[n].length
  else
    LS = 5
  end
  for i = 1 , LS do -- items
    loadmap[loadmap.length+1] = false
    loadmap.length = loadmap.length + 1
    for l = 1 , math.ceil((recipy.n[n].length - (i -0.1))/5) do 
      for j = 1 , chest.length do
        if recipy.n[n].ingredient[i+((l-1)*5)][2] == chest[j].label then
          local total = recipy.n[n].ingredient[i][1] * amount
          local exitslot = 1
          for k = chest[j].location.length , 1 , -1 do
            if chest[j].location[k].size < total then
              loadmap[loadmap.length+1] = {l,chest[j].location[k].size,chest[j].location[k].slot,exitslot,chest[j].label}
              total = total - chest[j].location[k].size
              loadmap.length = loadmap.length + 1
              exitslot = exitslot + 1
              chest[j].location[k] = nil
              chest[j].location.length = chest[j].location.length - 1
            else
              loadmap[loadmap.length+1] = {l,total,chest[j].location[k].slot,exitslot,chest[j].label}
              --{1,2,3,4}1= load buffer 2=how much 3= from wich chestslot 4= to wich loaderslot
              chest[j].location[k].size = chest[j].location[k].size - total
              loadmap.length = loadmap.length + 1
              if chest[j].location[k].size == 0 then
                chest[j].location[k] = nil
                chest[j].location.length = chest[j].location.length - 1
              end
              break
            end
          end
          break
        end
      end
    end
  end
  loadmap[loadmap.length + 1] = false -- fluids
  loadmap.length = loadmap.length + 1
  for i = 1 , fluidin.length do
    for j = 1 , recipy.n[n].fluid.length do
      if fluidin.fluid[i].label  == recipy.n[n].fluid.recipy[j][2] then
          loadmap[loadmap.length + 1]={j,recipy.n[n].fluid.recipy[j][1]*amount,fluidin.fluid[i].tank,0,0}
          loadmap.length = loadmap.length + 1
        break
      end
    end
  end
  return loadmap
end

function checkFluid(recipy,fluid,n)
  for j = 1 , recipy.n[n].fluid.length do 
    for i = 1 , fluid.length do
      if recipy.n[n].fluid.recipy[j][2] == fluid.fluid[i].label then
        break
      end
      if i == fluid.length then
        return false
      end
    end
    if recipy.n[n].fluid.length == j then
      return true
    end
  end
end

function FindMatch.findMatch(recipy,input,fluid)
  local istreu = false
  for i = 1 ,recipy.count do
    if checkFluid(recipy,fluid,i) then 
      for j = 1 ,recipy.n[i].simplerecipy.length do
        local isfalse = false
        for k = 1 , input.length do
          if recipy.n[i].simplerecipy[j].label == input[k].label then 
            break
          end 
          if k == input.length then 
            isfalse = true
          end
        end
        if isfalse then
          break
        end
        if j == recipy.n[i].simplerecipy.length then
          return i
        end
      end
    end
  end
  return false
end

function getFluidMax(recipy,n,fluidin)
  local lowest
  for i = 1, recipy.n[n].fluid.length do
    for j = 1 , fluidin.length do
      if fluidin.fluid[j] ~= nil then
        if recipy.n[n].fluid.recipy[i][2] == fluidin.fluid[j].label then
          local temp = math.floor(fluidin.fluid[j].size / recipy.n[n].fluid.recipy[i][1])
          if lowest == nil then
            lowest = temp
          elseif lowest > temp then
            lowest = temp
          end
        end
      end
    end
  end
  return lowest
end

function FindMatch.getMax(recipy,n,input,fluidin)
  local lowest = getFluidMax(recipy,n,fluidin)
  for i = 1, recipy.n[n].simplerecipy.length do
    for j = 1 , input.length do
      if recipy.n[n].simplerecipy[i].label == input[j].label then
          local temp = math.floor(input[j].size / recipy.n[n].simplerecipy[i].size)
          if lowest == nil then
            lowest = temp
          else
            if lowest > temp then
              lowest = temp
            end
          end
          break
      end
    end
  end
    print(lowest)
   return lowest
end
return FindMatch
local FindMatch = {}

function FindMatch.makeLoadMap(recipy,n,amount,chest)
  local loadmap ={}
  loadmap.length = 0
  local braek = false
  local LS = 0
  if recipy.n[n].length < 5 then
    LS = recipy.n[n].length
  else
    LS = 5
  end
  for i = 1 , LS do
    loadmap[loadmap.length+1] = false
    loadmap.length = loadmap.length + 1
    --print(loadmap.length)
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
  return loadmap
end

function checkfluid(recipy,fluid)
  for i = 1 , fluid.length do
    for j = 1 , recipy.n[n].fluid.length do
      if recipy.n[n].fluid.recipy[j] == fluid[i].label then
        break
      end
      if j == recipy.n[n].fluid.length then
        return false
      end
    end
    if recipy.n[n].fluid.length == i then
      return true
    end
  end
end

function FindMatch.findMatch(recipy,input,fluid)
  local istreu = false
  for i = 1 ,recipy.count do
    if true then --checkFluid(recipy,fluid) 
    end
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
  return false
end

function FindMatch.getMax(recipy,n,input)
  local lowest
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
   return lowest
end
return FindMatch
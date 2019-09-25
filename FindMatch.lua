local FindMatch = {}

function makeLoadMap(recipy,n,amount,chest)
  local loadmap ={}
  local loadmap.length = 0
  if recipy.n[n].length < 5 then
    local LS = recipy.n[n].length
  else
    local LS = 5
  end
  for i = 1 , LS do
    for k = 1 , (recipy.n[n].length - (i -0.1))/5 do 
    for j = 1 , chest.length do
      if recipy.n[n].label == chest[j].label then
        for k = chest[j].location.length , 1 , -1 do
          if chest[j].location[k].size < reipy.n[n].ingerient[i][1] * amount then
            loadmap[loadmap.length+1] = {}
          end  
        end
        break
      end
    end
  end
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

function FindMatch.findMatch(recipy,input)
  local istreu = false
  for i = 1 ,recipy.count do
    if checkFluid then
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
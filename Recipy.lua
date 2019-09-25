local Recipy = {}

function copy(table)
   local  copy = {}
   copy.size = table[1]
   copy.label = table[2]
  return copy
end

function Recipy.getLength(ingredientFluid)
  if ingredientFluid ~= nil then
  local length = 0
    for k , v in pairs(ingredientFluid) do
      length = length + 1
    end
  return length
  end
end

function Recipy.makeShort(recipy)
  local simplerecipy = {} 
  local isequal = 0
  simplerecipy.length = 1
  simplerecipy[1] = copy(recipy.ingredient[1])

  for i = 2 , recipy.length do 
    for j = 1 , simplerecipy.length do
      if simplerecipy[j].label == recipy.ingredient[i][2] then 
          simplerecipy[j].size = simplerecipy[j].size + recipy.ingredient[i][1]
          isequal = 1
      end
    end
    if isequal == 0 then
      simplerecipy[simplerecipy.length + 1] = copy(recipy.ingredient[i])     
      simplerecipy.length = simplerecipy.length + 1
    end
    isequal = 0

  end
  return simplerecipy
end

function NewRecipy(output,ingredient,ingredientFluid)
  
  local object = {}
  object.output = output
  object.ingredient = ingredient
  object.length = 0
  object.simplrecipy = {}
  object.fluid = {}
  object.fluid.recipy = ingredientFluid
  object.fluid.length = Recipy.getLength(ingredientFluid)
 return object

end

function Recipy.RecipyArray(substitude)
  
  local object = {}
  object.n = {}
  object.count = 0
  object.substitude = substitude
  object.substitude.length = Recipy.getLength(substitude)
  

  function object.addRecipy(a,b,c)
    object.n[object.count + 1] = NewRecipy(a,b,c)
    object.count = object.count + 1
    for k, v in pairs(object.n[object.count].ingredient) do
       object.n[object.count].length = object.n[object.count].length + 1 
    end
    object.n[object.count].simplerecipy = Recipy.makeShort(object.n[object.count])
  end
  return object
end
if false then
local test = Recipy.RecipyArray()
test.addRecipy("M",{{1,"H"},{2,"M"}})
print(test.n[1].ingredient[1][1])
for k, v in pairs(test.n[1].ingredient) do print(v[1]..v[2]) end
for k, v in pairs(test.n[1].simplerecipy) do print(v[1]..v[2]) end
end

return Recipy
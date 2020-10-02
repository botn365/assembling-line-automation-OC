local recipe = {}

function copy(table)
   local  copy = {}
   copy.size = table[1]
   copy.label = table[2]
  return copy
end

function recipe.getLength(ingredientFluid)
  if ingredientFluid ~= nil then
  local length = 0
    for k , v in pairs(ingredientFluid) do
      length = length + 1
    end
  return length
  end
end

function recipe.makeShort(recipy)
  local simplerecipy = {} 
  local isequal = 0
  simplerecipy.length = 1
  simplerecipy[1] = copy(recipy.ingredient[1])

  for i = 2 , recipy.length do 
    for j = 1 , simplerecipy.length do
      if recipy.ingredient[i][2] ~= 1 then
        if simplerecipy[j].label == recipy.ingredient[i][2] then 
            simplerecipy[j].size = simplerecipy[j].size + recipy.ingredient[i][1]
            isequal = 1
        end
      else
        
      end
    end
    if isequal == 0 then
      simplerecipy[simplerecipy.length + 1] = copy(recipy.ingredient[i])
      if recipy.ingredient[i][3] == 1 then
        simplerecipy[simplerecipy.length + 1].C = 1
      end
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
  object.fluid.length = recipe.getLength(ingredientFluid)
 return object

end

function recipe.RecipyArray(substitude)
  
  local object = {}
  object.n = {}
  object.count = 0
  object.substitude = substitude
  object.substitude.length = recipe.getLength(substitude)
  

  function object.addRecipy(a,b,c)
    object.n[object.count + 1] = NewRecipy(a,b,c)
    object.count = object.count + 1
    for k, v in pairs(object.n[object.count].ingredient) do
       object.n[object.count].length = object.n[object.count].length + 1 
    end
    object.n[object.count].simplerecipy = recipe.makeShort(object.n[object.count])
  end
  return object
end

function recipe.DaddRecipy() -- void object to easly disable recipys
end


if false then
local test = recipe.RecipyArray()
test.addRecipy("M",{{1,"H"},{2,"M"}})
print(test.n[1].ingredient[1][1])
for k, v in pairs(test.n[1].ingredient) do print(v[1]..v[2]) end
for k, v in pairs(test.n[1].simplerecipy) do print(v[1]..v[2]) end
end

return recipe
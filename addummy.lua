config = require("config")
package.loaded.config=nil
filesystem = require("filesystem")
itemTransposer = config.addrestransposeritem
file = filesystem.open("/asslines/dummyfile.lua","r")
toreturn = -20
file:seek("end",toreturn)
text = file:read(-toreturn)
pos = string.find(text,"}\n")
if pos == nil then
    pos = string.find(text,"}\r\n")
end
pos = toreturn + pos - 1
file:seek("end",pos)
text = file:read(-pos)
print(text)
file:close()
file = io.open("/asslines/dummyfile.lua","a")
file:seek("end",pos)
item1 = itemTransposer.getStackInSlot(1,1).label
item2 = itemTransposer.getStackInSlot(1,2).label
file:write(",{\""..item1.."\",\""..item2.."\"}}\nreturn dummy")
file:close()
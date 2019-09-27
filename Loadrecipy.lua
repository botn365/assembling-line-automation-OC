package.loaded.Recipy = nil
local R = require("Recipy")
local r = R.RecipyArray({{"LuV_Piston_In","LuV_Piston_Out"}})

r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}})
r.addRecipy("Electric Piston (LuV)",{{1,"Electric Motor (LuV)"},{6,"HSS-S Plate"},{4,"HSS-S Ring"}
,{32,"HSS-S Round"},{4,"HSS-S Rod"},{1,"HSS-S Gear"}
,{2,"Small HSS-S Gear"},{4,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)

return r
package.loaded.Recipy = nil
local R = require("Recipy")
local r = R.RecipyArray({{"SolderMixIn","SolderMixOut"},{"LuVArmIn","LuVArmOut"}})

r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}})
r.addRecipy("Electric Piston (LuV)",{{1,"Electric Motor (LuV)"},{6,"HSS-S Plate"},{4,"HSS-S Ring"}
,{32,"HSS-S Round"},{4,"HSS-S Rod"},{1,"HSS-S Gear"}
,{2,"Small HSS-S Gear"},{4,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Robot Arm (LuV)",{{4,"Long HSS-S Rod"},{1,"HSS-S Gear"},{3,"Small HSS-S Gear"},{2,"Electric Motor (LuV)"}
,{1,"Electric Piston (LuV)"},{2,"Nanoprocessor Mainframe"},{4,"Elite Nanocomputer"},{8,"Nanoprocessor Assembly"},{6,"1x Yttrium Barium Cuprate Cable"}}
,{{576,"Molten Soldering Alloy"},{250,"Lubricant"}})

return r
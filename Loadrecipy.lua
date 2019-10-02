package.loaded.Recipy = nil
local R = require("Recipy")
local r = R.RecipyArray({{"SolderMixIn","SolderMixOut"},{"LuVArmIn","LuVArmOut"}})

r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Electric Piston (LuV)",{{1,"Electric Motor (LuV)"},{6,"HSS-S Plate"},{4,"HSS-S Ring"}
,{32,"HSS-S Round"},{4,"HSS-S Rod"},{1,"HSS-S Gear"}
,{2,"Small HSS-S Gear"},{4,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Robot Arm (LuV)",{{4,"Long HSS-S Rod"},{1,"HSS-S Gear"},{3,"Small HSS-S Gear"},{2,"Electric Motor (LuV)"}
,{1,"Electric Piston (LuV)"},{2,"Nanoprocessor Mainframe"},{4,"Elite Nanocomputer"},{8,"Nanoprocessor Assembly"},{6,"1x Yttrium Barium Cuprate Cable"}}
,{{576,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Field Generator (Tier VI)",{{1,"HSS-S Frame Box"},{6,"HSS-S Plate"},{2,"Quantum Star"},{4,"Emitter (LuV)"}
,{4,"Quantumprocessor Mainframe"},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"}
,{8,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Emittor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridite Rod"},{1,"Quantum Star"},{4,"Nanoprocessor Mainframe"}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Sensor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridite Plate"},{1,"Quantum Star"},{4,"Nanoprocessor Mainframe"}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Conveyor Module (LuV)",{{2,"Electric Motor (LuV)"},{2,"HSS-S Plate"},{4,"HSS-S Ring"},{32,"HSS-S Round"},{2,"1x Yttrium Barium Cuprate Cable"}}
,{{144,"Molten Soldering Alloy"},{250,"Lubricant"},{1440,"Molten Styrene-Butadiene Rubber"}}
)
r.addRecipy("Electric Pump (LuV)",{{1,"Electric Motor (LuV)"},{2,"Small Niobium-Titanium Fluid Pipe"},{2,"HSS-S Plate"},{8,"HSS-S Screw"}
,{4,"Molten Styrene-Butadiene Rubber Ring"},{2,"Hss-S Rotor"},{2,"1x Yttrium Barium Cuprate Cable"}}
,{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("LuV Energy Hatch",{{1,"LuV Machine Hull"},{2,"1x Superconductor LuV Wire"},{2,"Ultra High Power IC"},{2,"Nanoprocessor Mainframe"}
,{2,"Ludicrous Voltage Coil"},{1,"180K He Coolant Cell"},{1,"180K He Coolant Cell"},{1,"Electric Pump (LuV)"}}
,{{2000,"IC2 Coolant"},{720,"Molten Soldering Alloy"}}
)



return r
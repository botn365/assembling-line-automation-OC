package.loaded.Recipy = nil
local R = require("Recipy")
local r = R.RecipyArray({{"SolderMixIn","SolderMixOut"},{"LuVArmIn","LuVArmOut"},{"ESMIn","ESMOut"},{"FRWIn","FRWOut"},{"EHLIn","EHLOut"}
,{"SDM2In","SDM2Out"},{"ASM2In","ASM2Out"}})

r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Electic Motor (ZPM)",{{2,"Magnetic Samarium Rod"},{4,"Long Naquadah Alloy Rod"},{4,"Naquadah Alloy Ring"}
,{16,"Naquadah Alloy Round"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{2,"4x Vanadium-Gallium Cable"}}
,{{288,"Molten Soldering Alloy"},{750,"Lubricant"}}
)
r.addRecipy("Electric Piston (LuV)",{{1,"Electric Motor (LuV)"},{6,"HSS-S Plate"},{4,"HSS-S Ring"}
,{32,"HSS-S Round"},{4,"HSS-S Rod"},{1,"HSS-S Gear"}
,{2,"Small HSS-S Gear"},{4,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Electric Piston (ZPM)",{{1,"Electric Motor (ZPM)"},{6,"Naquadah Alloy Plate"},{4,"Naquadah Alloy Ring"}
,{32,"Naquadah Alloy Round"},{4,"Naquadah Alloy Rod"},{1,"Naquadah Alloy Gear"}
,{2,"Small Naquadah Alloy Gear"},{4,"4x Vanadium-Gallium Cable"}}
,{{288,"Molten Soldering Alloy"},{750,"Lubricant"}}
)
r.addRecipy("Robot Arm (LuV)",{{4,"Long HSS-S Rod"},{1,"HSS-S Gear"},{3,"Small HSS-S Gear"},{2,"Electric Motor (LuV)"}
,{1,"Electric Piston (LuV)"},{2,6,1},{4,5,1},{8,4,1},{6,"1x Yttrium Barium Cuprate Cable"}}
,{{576,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Robot Arm (ZPM)",{{4,"Long Naquadah Alloy Rod"},{1,"Naquadah Alloy Gear"},{3,"Small Naquadah Alloy Gear"},{2,"Electric Motor (ZPM)"}
,{1,"Electric Piston (ZPM)"},{2,7,1},{4,6,1},{8,5,1},{6,"4x Vanadium-Gallium Cable"}}
,{{1152,"Molten Soldering Alloy"},{750,"Lubricant"}}
)
r.addRecipy("Field Generator (Tier VI)",{{1,"HSS-S Frame Box"},{6,"HSS-S Plate"},{2,"Quantum Star"},{4,"Emitter (LuV)"}
,{4,7,1},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"},{64,"Fine Ruridit Wire"}
,{8,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Emittor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridit Rod"},{1,"Quantum Star"},{4,6,1}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Sensor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridit Plate"},{1,"Quantum Star"},{4,1,6}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Conveyor Module (LuV)",{{2,"Electric Motor (LuV)"},{2,"HSS-S Plate"},{4,"HSS-S Ring"},{32,"HSS-S Round"},{2,"1x Yttrium Barium Cuprate Cable"}}
,{{144,"Molten Soldering Alloy"},{250,"Lubricant"},{1440,"Molten Styrene-Butadiene Rubber"}}
)
r.addRecipy("Conveyor Module (ZPM)",{{2,"Electric Motor (ZPM)"},{2,"Naquadah Alloy Plate"},{4,"Naquadah Alloy Ring"},{32,"Naquadah Alloy Round"}
,{2,"4x Vanadium-Gallium Cable"}}
,{{288,"Molten Soldering Alloy"},{750,"Lubricant"},{2880,"Molten Styrene-Butadiene Rubber"}}
)
r.addRecipy("Electric Pump (LuV)",{{1,"Electric Motor (LuV)"},{2,"Small Niobium-Titanium Fluid Pipe"},{2,"HSS-S Plate"},{8,"HSS-S Screw"}
,{4,"Styrene-Butadiene Rubber Ring"},{2,"HSS-S Rotor"},{2,"1x Yttrium Barium Cuprate Cable"}}
,{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Electric Pump (ZPM)",{{1,"Electric Motor (ZPM)"},{2,"Enderium Fluid Pipe"},{2,"Naquadah Alloy Plate"},{8,"Naquadah Alloy Screw"}
,{8,"Styrene-Butadiene Rubber Ring"},{2,"Naquadah Alloy Rotor"},{2,"4x Vanadium-Gallium Cable"}}
,{{288,"Molten Soldering Alloy"},{750,"Lubricant"}}
)
r.addRecipy("LuV Energy Hatch",{{1,"LuV Machine Hull"},{2,"1x Superconductor LuV Wire"},{2,"Ultra High Power IC"},{2,6,1}
,{2,"Ludicrous Voltage Coil"},{1,"180k He Coolant Cell"},{1,"180k He Coolant Cell"},{1,"Electric Pump (LuV)"}}
,{{2000,"IC2 Coolant"},{720,"Molten Soldering Alloy"}}
)
r.addRecipy("LuV Dynamo Hatch",{{1,"LuV Machine Hull"},{2,"Superconductor Base LuV Spring"},{2,"Ultra High Power IC"},{2,6,1}
,{2,"Ludicrous Voltage Coil"},{1,"180k He Coolant Cell"},{1,"180k He Coolant Cell"},{1,"Electric Pump (LuV)"}}
,{{2000,"IC2 Coolant"},{720,"Molten Soldering Alloy"}}
)
r.addRecipy("Circuit Assembly Line",{{1,"Advanced Circuit Assembling Machine V"},{4,"Robot Arm (LuV)"},{4,"Electric Motor (LuV)"}
,{1,"Field Generator (Tier VI)"},{1,"Emitter (LuV)"},{1,"Sensor (LuV)"},{8,"Chrome Plate"}}
,{{1440,"Molten Soldering Alloy"}}
)
r.addRecipy("ZPM Energy Hatch",{{1,"ZPM Machine Hull"},{2,"2x Superconductor ZPM Wire"},{2,"Nano Power IC"},{2,7,1}
,{2,"ZPM Voltage Coil"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"Electric Pump (ZPM)"}}
,{{4000,"IC2 Coolant"},{1440,"Molten Soldering Alloy"}}
)
r.addRecipy("ZPM Dynamo Hatch",{{1,"ZPM Machine Hull"},{4,"Superconductor Base ZPM Spring"},{2,"Nano Power IC"},{2,7,1}
,{2,"ZPM Voltage Coil"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"Electric Pump (ZPM)"}}
,{{4000,"IC2 Coolant"},{1440,"Molten Soldering Alloy"}}
)



return r
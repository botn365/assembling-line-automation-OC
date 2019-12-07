package.loaded.Recipy = nil
package.loaded.dummyfile = nil
dummy = require("dummyfile")
local R = require("Recipy")
local r = R.RecipyArray(dummy)

r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
)
r.addRecipy("Electric Motor (ZPM)",{{2,"Magnetic Samarium Rod"},{4,"Long Naquadah Alloy Rod"},{4,"Naquadah Alloy Ring"}
,{16,"Naquadah Alloy Round"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{2,"4x Vanadium-Gallium Cable"}}
,{{288,"Molten Soldering Alloy"},{750,"Lubricant"}}
)
r.addRecipy("Electric Motor (UV)",{{2,"Long Magnetic Samarium Rod"},{4,"Long Neutronium Rod"},{4,"Neutronium Ring"}
,{16,"Neutronium Round"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"}
,{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{2,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{1296,"Molten Soldering Alloy"},{2000,"Lubricant"}}
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
--5
r.addRecipy("Electric Piston (UV)",{{1,"Electric Motor (UV)"},{6,"Neutronium Plate"},{4,"Neutronium Ring"}
,{32,"Neutronium Round"},{4,"Neutronium Rod"},{1,"Neutronium Gear"}
,{2,"Small Neutronium Gear"},{4,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{1296,"Molten Soldering Alloy"},{2000,"Lubricant"}}
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
--10
r.addRecipy("Field Generator (Tier VII)",{{1,"Naquadah Alloy Frame Box"},{6,"Naquadah Alloy Plate"},{1,"Quantum Star"},{4,"Emitter (ZPM)"}
,{4,8,1},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"},{64,"Fine Europium Wire"}
,{8,"4x Vanadium-Gallium Cable"}},{{1152,"Molten Soldering Alloy"}}
)
r.addRecipy("Emittor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridit Rod"},{1,"Quantum Star"},{4,6,1}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Emittor (ZPM)",{{1,"Naquadah Alloy Frame Box"},{1,"Electric Motor (ZPM)"},{8,"Osmiridium Rod"},{2,"Quantum Star"},{4,7,1}
,{64,"Trinium Foil"},{64,"Trinium Foil"},{64,"Trinium Foil"},{7,"4x Vanadium-Gallium Cable"}},{{1152,"Molten Soldering Alloy"}}
)
r.addRecipy("Sensor (LuV)",{{1,"HSS-S Frame Box"},{1,"Electric Motor (LuV)"},{8,"Ruridit Plate"},{1,"Quantum Star"},{4,6,1}
,{64,"Gallium Foil"},{64,"Gallium Foil"},{64,"Gallium Foil"},{7,"1x Yttrium Barium Cuprate Cable"}},{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("Sensor (ZPM)",{{1,"Naquadah Alloy Frame Box"},{1,"Electric Motor (ZPM)"},{8,"Osmiridium Plate"},{2,"Quantum Star"},{4,7,1}
,{64,"Trinium Foil"},{64,"Trinium Foil"},{64,"Trinium Foil"},{7,"4x Vanadium-Gallium Cable"}},{{1152,"Molten Soldering Alloy"}}
)
--15
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
--20
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
r.addRecipy("Lapotronic Energy Orb Cluster",{{1,"Multilayer Fiber-Reinforced Circuit Board"},{32,"Europium Foil"},{4,6,1}
,{36,"Engraved Lapotron Chip"},{36,"Engraved Lapotron Chip"},{64,"High Power IC"},{32,"SMD Diode"},{32,"SMD Capacitor"},{32,"SMD Resistor"}
,{32,"SMD Transistor"},{64,"Fine Platinum Wire"}}
,{{720,"Molten Soldering Alloy"}}
)
r.addRecipy("Data Bank",{{1,"Network Switch With QoS"},{2,6,1},{1,"Data Orb"},{1,"Computer Monitor Cover"}},{{2000,"IC2 Coolant"}
,{1000,"Hydrogen Gas"}}
)
--25
r.addRecipy({"Heavy Duty Alloy Ingot T4"},{{1,"Heavy-Duty Plate"},{3,"Compressed Ice Plate"},{3,"Compressed Ice Plate"},{4,"Ruridit Bolt"}}
,{{36,"Molten Soldering Alloy"}}
)
r.addRecipy({"Heavy Duty Alloy Ingot T5"},{{1,"Heavy Duty Plate Tier 4"},{4,"Compressed Quantium Plate"},{4,"Compressed Quantium Plate"}
,{8,"Naquadah Alloy Bolt"}},{{72,"Molten Soldering Alloy"}}
)
r.addRecipy({"Heavy Duty Alloy Ingot T6"},{{1,"Heavy Duty Plate Tier 5"},{5,"Compressed Lead-Oriharukon Plate"},{5,"Compressed Lead-Oriharukon Plate"}
,{8,"Tritanium Bolt"}},{{144,"Molten Soldering Alloy"}}
)
r.addRecipy("28",{{1,"Electric Motor (UV)"},{2,"Large Naquadah Fluid Pipe"},{2,"Neutronium Plate"},{8,"Neutronium Screw"},{16,"Styrene-Butadiene Rubber Ring"},{2,"Neutronium Rotor"},{2,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{1296,"Molten Soldering Alloy"},{2000,"Lubricant"}}
)
r.addRecipy("29",{{4,"Long Neutronium Rod"},{1,"Neutronium Gear"},{3,"Small Neutronium Gear"},{2,"Electric Motor (UV)"},{1,"Electric Piston (UV)"},{2,8,1},{4,7,1},{8,6,1},{6,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{2304,"Molten Soldering Alloy"},{2000,"Lubricant"}}
)
r.addRecipy("30",{{2,"Electric Motor (UV)"},{2,"Neutronium Plate"},{4,"Neutronium Ring"},{32,"Neutronium Round"},{2,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{1296,"Molten Soldering Alloy"},{2000,"Lubricant"},{5760,"Molten Styrene-Butadiene Rubber"}}
)
r.addRecipy("31",{{1,"UV Machine Hull"},{2,"2x Superconductor UV Wire"},{2,"Piko Power IC"},{2,8,1},{2,"Ultimate Voltage Coil"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"Electric Pump (UV)"}}
,{{8000,"IC2 Coolant"},{2880,"Molten Soldering Alloy"}}
)
r.addRecipy("32",{{1,"UV Machine Hull"},{4,"Superconductor Base UV Spring"},{2,"Piko Power IC"},{2,8,1},{2,"Ultimate Voltage Coil"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"360k He Coolant Cell"},{1,"Electric Pump (UV)"}}
,{{8000,"IC2 Coolant"},{2880,"Molten Soldering Alloy"}}
)
r.addRecipy("33",{{1,"Heavy Duty Plate Tier 6"},{6,"Compressed Mysterious Crystal Plate"},{6,"Compressed Mysterious Crystal Plate"},{10,"Neutronium Bolt"}}
,{{288,"Molten Soldering Alloy"}}
)
r.addRecipy("34",{{1,"Extreme Wetware Lifesupport Circuit Board"},{16,"Stemcells"},{16,"Reinforced Glass Tube"},{8,"Tiny PBI Fluid Pipe"},{4,"Fluxed Electrum Casing"},{32,"Thin Styrene-Butadiene Rubber Sheet"},{32,"HSS-S Bolt"}}
,{{250,"Sterilized Growth Medium"},{250,"UU-Matter"},{1000,"IC2 Coolant"}}
)r.addRecipy("35",{{2,"Tritanium Frame Box"},{2,"Wetware Supercomputer"},{16,"ZPM Voltage Coil"},{64,"SMD Capacitor"},{64,"SMD Resistor"},{64,"SMD Transistor"},{64,"SMD Diode"},{48,"Random Access Memory Chip"},{64,"1x Superconductor ZPM Wire"},{64,"Thin Silicone Rubber Sheet"}}
,{{2880,"Molten Soldering Alloy"},{10000,"IC2 Coolant"},{2500,"Radon"}}
)
r.addRecipy("36",{{1,"Neutronium Frame Box"},{1,"Electric Motor (UV)"},{8,"Neutronium Rod"},{4,"Gravi Star"},{4,8,1},{64,"Naquadria Foil"},{64,"Naquadria Foil"},{64,"Naquadria Foil"},{7,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{2304,"Molten Soldering Alloy"}}
)
r.addRecipy("37",{{1,"Heavy Duty Plate Tier 7"},{7,"Compressed Black Plutonium Plate"},{7,"Compressed Black Plutonium Plate"},{12,"Black Plutonium Bolt"}}
,{{576,"Molten Soldering Alloy"}}
)
r.addRecipy("38",{{1,"Neutronium Frame Box"},{6,"Neutronium Plate"},{2,"Gravi Star"},{4,"Emitter (UV)"},{4,9,1},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{64,"Fine Americium Wire"},{8,"4x Naquadah Alloy Cable"}}
,{{1296,"Molten Naquadria"},{2304,"Molten Soldering Alloy"}}
)


return r
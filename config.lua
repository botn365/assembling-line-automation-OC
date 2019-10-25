local Config = {}
package.loaded.conficprocess=nil
local translate = require("conficprocess") 



Config.directionloader = translate.setSide("N") --N,E,S,W
Config.directionredstoneassline = translate.setSide("U")  --N,E,S,W,D,U on wich side the bunled cable is conected
Config.addresredstoneassline = translate.setProxy({"4fd53861-f81f-423d-b886-d84dea515ff2"}) -- addres of the redstone IO part of the asslien
-- {"addr assline 1","addr assline 2","addr assline 3" }
Config.addrestransposerassline = translate.setProxy({""}) -- transposer to read name of data sticks
-- {"addr assline 1","addr assline 2","addr assline 3" }
Config.addresredstoneloader = "60cb8d12-191c-4724-a0a0-a3c012bb20c5" -- addres of the redstone IO part of the loader
Config.addrestransposeritem = "af607168-70c3-4528-b702-77b3cbbc0a83" -- addres of the transposer on the bottem of the loader
Config.addrestransposerfluid1 = "42cb088c-ece2-49e6-9efe-efc9cc6c508b" -- addres of the transposer on the top conectet to the chest
Config.addrestransposerfluid2 = "ac7764f5-0050-4252-88fb-08290ced5ae9" -- addres of the transposer on the top conectet to the tanks
Config.use_enderchest = false -- if you are using ae p2p tunnels set false if using enderchest set true
Config.Assline_max_item = 16 -- the amount of slots the input bus has
Config.Assline_max_fluid = 128000  --  the amont of fluid the input hatch stores
Config.max_fluid_stored = 256000 -- the size of the tanks you use to store fluids

return Config
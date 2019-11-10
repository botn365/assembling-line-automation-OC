local Config = {}
package.loaded.conficprocess=nil
local translate = require("conficprocess") 



Config.directionloader = translate.setSide(
    "" --N,E,S,W
)
Config.directionredstoneassline = translate.setSideA(
    {""}  --N,E,S,W,D,U on wich side the bunled cable is conected
)
Config.addresredstoneassline = translate.setProxyA(
    {""} -- addres of the redstone IO part of the asslien
)
-- {"addr assline 1","addr assline 2","addr assline 3" }
Config.addrestransposerassline = translate.setProxyA(
    {""} -- transposer to read name of data sticks
)
-- {"addr assline 1","addr assline 2","addr assline 3" }
Config.addresredstoneloader = translate.setProxy(
    "" -- addres of the redstone IO part of the loader
)
Config.addrestransposeritem = translate.setProxy(
    "" -- addres of the transposer on the bottem of the loader
)
Config.addrestransposerfluid1 = translate.setProxy(
    "" -- addres of the transposer on the top conectet to the chest
)
Config.addrestransposerfluid2 = translate.setProxy(
    "" -- addres of the transposer on the top conectet to the tanks
)
Config.use_enderchest = false -- if you are using ae p2p tunnels set false if using enderchest set true
Config.Assline_max_item = 16 -- the amount of slots the input bus has
Config.Assline_max_fluid = 128000  --  the amont of fluid the input hatch stores
Config.max_fluid_stored = 256000 -- the size of the tanks you use to store fluids


return Config
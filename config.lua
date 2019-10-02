local Config = {}
package.loaded.conficprocess=nil
local translate = require("conficprocess")
Config.directionloader = translate.setSide("") --N,E,S,W
Config.directionredstoneassline = translate.setSide("U")  --N,E,S,W,D,U on wich side the bunled cable is conected
Config.addresredstoneassline = "" -- addres of the redstone IO part of the asslien
Config.addresredstoneloader = "" -- addres of the redstone IO part of the loader
Config.addrestransposeritem = "" -- addres of the transposer on the bottem of the loader
Config.addrestransposerfluid1 = "" -- addres of the transposer on the top conectet to the chest
Config.addrestransposerfluid2 = "" -- addres of the transposer on the top conectet to the tanks
Config.use_enderchest = false

return Config
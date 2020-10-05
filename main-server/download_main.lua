local args = {...}
if args[1] == nil then
    print("no drive name (first 3 leters of address) given not downloading")
else
    local path = "/mnt/"..args[1]
    local shell = require("shell")
    local download_list = 
    {
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/CircuitOreDict.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/side.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/setings.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/recipe.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/itemServer.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/fluidServer.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/eventhandler.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/assline.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/Recipy.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/Loadrecipy.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/FindMatch.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/autorun.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/LoadrecipePriorety.lua"
    }

    shell.setWorkingDirectory(path)
    print("downloading")
    for k,v in pairs(download_list) do
        print("print",v)
        local command = "wget "..v.." -f"
        shell.execute(command)
    end
end

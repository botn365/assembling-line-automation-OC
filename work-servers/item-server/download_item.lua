local args = {...}
if args[1] == nil then
    print("no drive name (first 3 leters of address) given not downloading")
else
    local path = "/mnt/"..args[1]
    local shell = require("shell")
    local download_list = 
    {
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/item-server/autorun.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/item-server/comps.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/item-server/listner.lua",
        "https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/item-server/setings.lua"
    }

    shell.setWorkingDirectory(path)
    print("downloading")
    for k,v in pairs(download_list) do
        print("print",v)
        local command = "wget "..v.." -f"
        shell.execute(command)
    end
end

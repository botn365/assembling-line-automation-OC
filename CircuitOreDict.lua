local OreDict = {}
local minT = 4
local dictlist = {
    {"Nanoprocessor Assembly","Quantumprocessor","Workstation"}, --EV
    OreDict[5 - minT].length = 3
    {"Crystalprocessor","Elite Nanocomputer","Quantumprocessor Assembly","Mainframe"}, --IV
    OreDict[6 - minT].length = 4
    {"Master Quantumcomputer","Wetwareprocessor","Crystalprocessor Assembly","Nanoprocessor Mainframe"}, -- LuV
    OreDict[7 - minT].length = 4
    {"Bioprocessor","Wetwareprocessor Assembly","Ultimate Crystalcomputer","Quantumprocessor Mainframe"}, --ZPM
    OreDict[8 - minT].length = 4
    {"Wetware Supercomputer","Bioprocessor Assembly","Crystalprocessor Mainframe"}, -- UV
    OreDict[9 - minT].length = 3
    {"Wetware Mainframe","Bioware Supercomputer"}, -- UHV
    OreDict[10 - minT].length = 2
    {"Bio Mainframe"} -- UEV
    OreDict[11 - minT].length = 1
}

fuction OreDict.get(tier,list)
    for i = 1 , dictlist[tier + 1 - minT].length do
        for j = 1 , list.length do
            if dictlist[tier + 1][i] == list[j].label then
                return false
            end
        end
    end
    return true
end

return OreDict
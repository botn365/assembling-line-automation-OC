local OreDict = {}
local minT = 4
local dictlist = {
    {"Nanoprocessor Assembly","Quantumprocessor","Workstation"}, --EV
    {"Crystalprocessor","Elite Nanocomputer","Quantumprocessor Assembly","Mainframe"}, --IV
    {"Master Quantumcomputer","Wetwareprocessor","Crystalprocessor Assembly","Nanoprocessor Mainframe"}, -- LuV
    {"Bioprocessor","Wetwareprocessor Assembly","Ultimate Crystalcomputer","Quantumprocessor Mainframe"}, --ZPM
    {"Wetware Supercomputer","Bioprocessor Assembly","Crystalprocessor Mainframe"}, -- UV
    {"Wetware Mainframe","Bioware Supercomputer"}, -- UHV
    {"Bio Mainframe"} -- UEV
}
dictlist[5 - minT].length = 3
dictlist[6 - minT].length = 4
dictlist[7 - minT].length = 4
dictlist[8 - minT].length = 4
dictlist[9 - minT].length = 3
dictlist[10 - minT].length = 2
dictlist[11 - minT].length = 1

function OreDict.get(tier,list)
    for i = 1 , dictlist[tier + 1 - minT].length do
        for j = 1 , list.length do
            if dictlist[tier + 1- minT][i] == list[j].label then
                return false
            end
        end
    end
    return true
end

function OreDict.check(R_list,C_list)
    if R_list[3] == 1 then
        for i = 1 , dictlist[R_list[2]+1-minT].length do
            if dictlist[R_list[2]+1-minT][i] == C_list then
                return true
            end
        end
        return false
    else
        return R_list[2] == C_list
    end
end

function OreDict.getlist()
    return dictlist
end

return OreDict
local OreDict = {}
local minT = 4
-- dictlist = {
--     {"Nanoprocessor Assembly","Quantumprocessor","Workstation"}, --EV
--     {"Crystalprocessor","Elite Nanocomputer","Quantumprocessor Assembly","Mainframe"}, --IV
--     {"Master Quantumcomputer","Wetwareprocessor","Crystalprocessor Assembly","Nanoprocessor Mainframe"}, -- LuV
--     {"Bioprocessor","Wetwareprocessor Assembly","Ultimate Crystalcomputer","Quantumprocessor Mainframe"}, --ZPM
--     {"Wetware Supercomputer","Bioprocessor Assembly","Crystalprocessor Mainframe"}, -- UV
--     {"Wetware Mainframe","Bioware Supercomputer"}, -- UHV
--     {"Bio Mainframe"} -- UEV
-- }
dictlist = {
    {"gt.metaitem.03.32083.name","gt.metaitem.03.32085.name","gt.metaitem.01.32704.name"}, --EV
    {"gt.metaitem.03.32089.name","gt.metaitem.03.32086.name","gt.metaitem.03.32084.name","gt.metaitem.01.32705.name"}, --IV
    {"gt.metaitem.03.32087.name","gt.metaitem.03.32092.name","gt.metaitem.03.32096.name","gt.metaitem.01.32706.name"}, -- LuV
    {"gt.metaitem.03.32097.name","gt.metaitem.03.32093.name","gt.metaitem.03.32090.name","gt.metaitem.03.32088.name"}, --ZPM
    {"gt.metaitem.03.32091.name"}, -- UV
    {"gt.metaitem.03.32095.name","gt.metaitem.03.32099.name"}, -- UHV
    {"gt.metaitem.03.32120.name"} -- UEV
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
                return true,dictlist[R_list[2]+1-minT][i]
            end
        end
        return false
    else
        return R_list[2] == C_list,nil
    end
end

function OreDict.isCircuit(itemLabel)
    for tier,circuitList in pairs(circuitlist) do
        for g,circuitName in pairs(circuitList) do
            if itemLabel == circuitName then
                return tier + minT-1
            end
        end
    end
    return 0
end

function OreDict.getlist()
    return dictlist
end

return OreDict
local LoadAssline =  {}
local bundl = {{0,0,0,0,0,0,0,0,0,0,255,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,255,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,255,0,0}
,{0,0,0,0,0,0,0,0,0,0,0,0,0,255,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,255}}
local liquidbundl = {{0,0,0,0,0,0,255,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,255,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,255,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,255,0,0,0,0,0}}
function LoadAssline.load(loadmap,addressItem,addressRedstoneAssline,addressRedstoneLoader,addressFluid)
    local slot = 1 
    addressRedstoneLoader.setOutput(0,15)
    for j = 1 , loadmap.length do --k ,v in pairs(loadmap)
        print("slot"..slot.."  "..j)
        if loadmap[j] and slot < 7 then
            for  i = 1 , 10 do
                if addressItem.transferItem(1,translateLoader(loadmap[j][1]),loadmap[j][2],loadmap[j][3],loadmap[j][4]) == 0 then
                    print("item faild trasfer")
                    os.sleep(0.2)
                else
                    os.sleep(0.25)
                    print(addressRedstoneLoader.getInput(3))
                    local timeoutcount = 0
                    while(addressRedstoneLoader.getInput(3)~=0) do
                        timeoutcount = timeoutcount + 1
                        if timeoutcount > 80 then
                            print("item/fluid stuck in loader")
                            addressRedstoneLoader.setOutput(0,0)
                            local crash = nil
                            print(crash..crash)
                        end
                        os.sleep(0.05)
                    end
                    break
                end
                if i == 10 then
                    print("total failure cant transpot item after 10 tries")
                    local crash = nil
                    print(crash..crash)
                end
            end
        elseif slot > 6 then
            if loadmap[j] then
                print("transfer")
                addressRedstoneAssline.setBundledOutput(3,liquidbundl[loadmap[j][1]])
                if addressFluid.transferFluid(4,5,loadmap[j][2]) == 0 then
                    print("item faild trasfer")
                    os.sleep(0.2)
                else
                    os.sleep(0.25)
                    print(addressRedstoneLoader.getInput(3))
                    local timeoutcount = 0
                    while(addressRedstoneLoader.getInput(3)~=0) do
                        timeoutcount = timeoutcount + 1
                        if timeoutcount > 80 then
                            print("item/fluid stuck in loader")
                            addressRedstoneLoader.setOutput(0,0)
                            local crash = nil
                            print(crash..crash)
                        end
                        os.sleep(0.05)
                    end
                end
            end
        else
            if slot < 6 then
                addressRedstoneAssline.setBundledOutput(3,bundl[slot])
            end
            slot = slot + 1
        end
    end
end

function translateLoader(loader)
    if loader == 1 then
        return 5
    elseif loader == 2 then
        return 4
    elseif loader == 3 then
        return 0
    else 
        print("fatel error loadmap contains a illegal number ")
    end
end

return LoadAssline
local LoadAssline =  {}
local event = require("event")

local bundl = {{0,0,0,0,0,0,0,0,0,0,255,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,255,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,255,0,0}
,{0,0,0,0,0,0,0,0,0,0,0,0,0,255,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,255}}
local liquidbundl = {{0,0,0,0,0,0,255,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,255,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,255,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,255,0,0,0,0,0}}
function LoadAssline.load(loadmap,addressItem,addressRedstoneAssline,addressRedstoneLoader,addressFluid1,addressFluid2,amount,dir)
    local slot = 1 
    addressRedstoneLoader.setOutput(0,15)
    for j = 1 , loadmap.length do --k ,v in pairs(loadmap)
        if loadmap[j] and slot < 7 then
            for  i = 1 , 10 do
                if addressItem.transferItem(1,translateLoader(loadmap[j][1]),loadmap[j][2],loadmap[j][3],loadmap[j][4]) == 0 then
                    print("item faild trasfer")
                    os.sleep(0.2)
                else
                    print("transfer")
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
                addressRedstoneAssline.setBundledOutput(1,liquidbundl[loadmap[j][1]])
                if transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 then
                    local breakcount = 0
                    while transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 do
                        breakcount = breakcount + 1
                        if breakcount == 80 then
                            addressRedstoneLoader.setOutput(0,0)
                            addressRedstoneAssline.setBundledOutput(1,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
                            print("fluid faild trasfer")
                            print("reseting AE wil trie again in 30 seconds")
                            os.sleep(30)
                            addressRedstoneAssline.setBundledOutput(1,liquidbundl[loadmap[j][1]])
                            addressRedstoneLoader.setOutput(0,15)
                        end 
                        os.sleep(0.2)
                    end
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
                os.sleep(0.25)
                print(addressRedstoneLoader.getInput(3))
                local timeoutcount = 0
                while(addressRedstoneLoader.getInput(3)~=0) do
                    timeoutcount = timeoutcount + 1
                    if timeoutcount > 80 then
                        timeoutcount = 0
                        addressRedstoneLoader.setOutput(0,0)
                        addressRedstoneAssline.setBundledOutput(1,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
                        print("item faild trasfer")
                        print("reseting AE wil trie again in 30 seconds")
                        os.sleep(30)
                        addressRedstoneAssline.setBundledOutput(1,bundl[slot-1])
                        addressRedstoneLoader.setOutput(0,15)
                    end                        
                    os.sleep(0.05)
                end
                addressRedstoneAssline.setBundledOutput(1,bundl[slot])
            end
            slot = slot + 1
        end
    end
    addressRedstoneLoader.setOutput(0,0)
    addressRedstoneAssline.setBundledOutput(1,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
    while amount > 0 do 
        local ch=event.pull(1)
        if ch == 'key_down' then
            break
        end
        if addressRedstoneAssline.getBundledInput(1,4) > 0 then
            amount = amount - 1
            print("recipy read")
            if amount == 0 then
                print("leavloop")
            else
                os.sleep(1)
            end
        else 
            os.sleep(0.03)
        end
    end
end

function transferFluid(addressFluid1,addressFluid2,loadmap,j)
    local position = {1,3,4,0}
    print(loadmap[j])
    addressFluid2.transferFluid(position[loadmap[j][3]],5,loadmap[j][2])
    return addressFluid1.transferFluid(4,5,loadmap[j][2])
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
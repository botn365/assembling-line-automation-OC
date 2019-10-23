local LoadAssline =  {}
package.loaded.config=nil
local event = require("event")
local config = require("config")

local bundl = {{0,0,0,0,0,0,0,0,0,0,255,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,255,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,255,0,0}
,{0,0,0,0,0,0,0,0,0,0,0,0,0,255,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,255}}
local liquidbundl = {{0,0,0,0,0,0,255,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,255,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,255,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,255,0,0,0,0,0}}
function LoadAssline.load(loadmap,addressItem,addressRedstoneAssline,addressRedstoneLoader,addressFluid1,addressFluid2,amount,dir)
    local slot = 1 
    addressRedstoneLoader.setOutput(0,15)
    for j = 1 , loadmap.length do 
        if loadmap[j] and slot < 7 then
            for  i = 1 , 10 do
                if addressItem.transferItem(1,config.directionloader.directionitem[loadmap[j][1]],loadmap[j][2],loadmap[j][3],loadmap[j][4]) == 0 then
                    print("item faild trasfer")
                    os.sleep(0.2)
                else
                    print("transfer"..loadmap[j][5])
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
                print("transfer"..loadmap[j][5])
                addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,liquidbundl[loadmap[j][1]])
                if transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 then
                    local breakcount = 0
                    while transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 do
                        breakcount = breakcount + 1
                        if breakcount == 80 then
                            addressRedstoneLoader.setOutput(0,0)
                            if config.use_enderchest then 
                                addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
                              else
                                addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
                              end
                            print("fluid faild trasfer")
                            print("reseting AE wil trie again in 30 seconds")
                            local crash = nil
                            print(crash..crash)
                            os.sleep(30)
                            addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,liquidbundl[loadmap[j][1]])
                            addressRedstoneLoader.setOutput(0,15)
                        end 
                        os.sleep(0.2)
                    end
                else
                    os.sleep(0.25)
                    local timeoutcount = 0
                    while(addressRedstoneLoader.getInput(config.directionloader.directionredstoneloader)~=0) do
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
            if slot < 7 then
                os.sleep(0.25)
                local timeoutcount = 0
                while(addressRedstoneLoader.getInput(config.directionloader.directionredstoneloader)~=0) do
                    timeoutcount = timeoutcount + 1
                    if timeoutcount > 80 then
                        timeoutcount = 0
                        addressRedstoneLoader.setOutput(0,0)
                        if config.use_enderchest then 
                            addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
                        else
                            addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
                        end
                        print("item faild trasfer")
                        print("reseting AE wil trie again in 30 seconds")
                        local crash = nil
                        print(crash..crash)
                        os.sleep(30)
                        addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,bundl[slot-1])
                        addressRedstoneLoader.setOutput(0,15)
                    end                        
                    os.sleep(0.05)
                end
                if slot < 6 then
                addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,bundl[slot])
                end
            end
            slot = slot + 1
        end
    end
    addressRedstoneLoader.setOutput(0,0)
    if config.use_enderchest then 
        addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
    else
        addressRedstoneAssline.setBundledOutput(config.directionredstoneassline.directionredstoneassline,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
    end
    while amount > 0 do
        if addressRedstoneAssline.getBundledInput(config.directionredstoneassline.directionredstoneassline,4) > 0 then
            amount = amount - 1
            if amount == 0 then
            else
                os.sleep(1)
            end
        else 
            os.sleep(0.03)
        end
    end
    print("done")
end


function transferFluid(addressFluid1,addressFluid2,loadmap,j)
    local position = config.directionloader.directionfluid2
    if loadmap[j][3] ~= 4 then
    addressFluid2.transferFluid(position[loadmap[j][3]],5,loadmap[j][2])
    return addressFluid1.transferFluid(4,position[5],loadmap[j][2])
    else
        return addressFluid1.transferFluid(1,position[5],loadmap[j][2])
    end
end


return LoadAssline
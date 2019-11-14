local LoadAssline =  {}
package.loaded.config=nil
local event = require("event")
local config = require("config")

function resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
	addressRedstoneLoader.setOutput(0,0)
    if config.use_enderchest then 
        addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
    else
        addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
    end
    print("item faild trasfer")
	print("reseting AE wil trie again in 1 seconds")
	os.sleep(1)
	addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],bundl[slot-1])
	addressRedstoneLoader.setOutput(0,15)
end

function reset(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
	local timeoutcount = 0
    while(addressRedstoneLoader.getInput(config.directionloader.directionredstoneloader)~=0) do
		timeoutcount = timeoutcount + 1
        if timeoutcount > 20 then
            timeoutcount = 0
            resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
		end                        
		os.sleep(0.05)
    end
end

local bundl = {{0,0,0,0,0,0,0,0,0,0,255,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,255,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,255,0,0}
,{0,0,0,0,0,0,0,0,0,0,0,0,0,255,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,255}}
local liquidbundl = {{0,0,0,0,0,0,255,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,255,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,255,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,255,0,0,0,0,0}}
function LoadAssline.load(loadmap,addressItem,addressRedstoneAssline,addressRedstoneLoader,addressFluid1,addressFluid2,amount,nassline)
    for k , v in pairs(config.directionredstoneassline) do
        addressRedstoneAssline[k].setBundledOutput(v,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
    end
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
					local crash
					print("total falure")
					print(crash..crash)
                end
            end

        elseif slot > 6 then
            if loadmap[j] then
                print("transfer"..loadmap[j][5])
                addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],liquidbundl[loadmap[j][1]])
                if transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 then
                    local breakcount = 0
                    while transferFluid(addressFluid1,addressFluid2,loadmap,j) == 0 do
                        breakcount = breakcount + 1
                        if breakcount == 80 then
							breakcount = 0
                            resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,loadmap[j][1]+1,liquidbundl)
                        end 
                        os.sleep(0.2)
                    end
                else
                    os.sleep(0.30)
                    reset(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
                end
            end
        else
            if slot < 7 then
                os.sleep(0.30)
				reset(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
                if slot < 6 then
				--print(nassline)
                addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],bundl[slot])
                end
            end
            slot = slot + 1
        end
    end
    addressRedstoneLoader.setOutput(0,0)
    if config.use_enderchest then -- configurs the redstone of the assline to deafault
        for k , v in pairs(config.directionredstoneassline) do
            addressRedstoneAssline[k].setBundledOutput(v,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
        end
      else
        for k , v in pairs(config.directionredstoneassline) do
            addressRedstoneAssline[k].setBundledOutput(v,{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
        end
      end
    addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],1,255)
    os.sleep(0.1)
    addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],1,0)
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
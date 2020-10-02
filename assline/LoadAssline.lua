local LoadAssline =  {}
package.loaded.config=nil
local event = require("event")
local config = require("config")
local os = require("os")
local computer = require("computer")
local localpos = {1,config.directionloader.directionfluid2[2]}
hasloged = false
file = 0
function key(time)
    event.pull(0)
    local ch=event.pull(time)
    if ch == 'key_down' then 
      return true
    end
    return false
  end

function resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
	--addressRedstoneLoader.setOutput(0,0)
    if config.use_enderchest then 
        addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
    else
        addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],{0,0,0,0,0,0,255,255,255,255,255,255,255,255,255})
    end
	addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],bundl[slot-1])
	--addressRedstoneLoader.setOutput(0,15)
end

function checkinv(transfercount,address,loadmap,j)
    for i = transfercount , j do
        local itemstack = address.getStackInSlot(config.directionloader.directionitem[loadmap[i][1]],loadmap[i][4])
        if itemstack ~= nil then
        end
        if itemstack ~= nil then
            return true
        end
    end
    return false
end

function checktank(address)
    fluidsatck = address.getFluidInTank(config.directionloader.directionfluid2[5])
    if fluidsatck[1].label ~= nil then
        if key(1) then 
            local crash
			print(crash..crash)
        end
        return true
    end
    return false
end

function reset(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl,isfluid,tocheck,address,loadmap,j)
    j = j - 1
    if j == 0 or loadmap[j] ~= false then
    local timeoutcount = 0
    local tries = 1
    if isfluid then
        while checktank(address) do
            timeoutcount = timeoutcount + 1
            if timeoutcount > 10 then
                timeoutcount = 0
                resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
		    end                        
            os.sleep(0.05)
        end
    else
        if (j - tocheck) > 5 then
            tries = 1
        end
        while checkinv(tocheck,address,loadmap,j) do
		    timeoutcount = timeoutcount + 1
            if timeoutcount > tries then
                timeoutcount = 0
                resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
		    end                        
		    os.sleep(0.05)
        end
    end
    end
end

local bundl = {{0,0,0,0,0,0,0,0,0,0,255,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,255,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0,255,0,0}
,{0,0,0,0,0,0,0,0,0,0,0,0,0,255,0},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,255}}
local liquidbundl = {{0,0,0,0,0,0,255,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,255,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,255,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,255,0,0,0,0,0}}
function LoadAssline.load(loadmap,addressItem,addressRedstoneAssline,addressRedstoneLoader,addressFluid1,addressFluid2,addressFluid3,amount,nassline,logger)
    local startTime = computer.uptime()
    --if not hasloged then
        --hasloged = true
        --logger.addLogger("printitem",{"has transferd","direction","amount","from slot","to slot"})
        --logger.addLogger("fluidtransfer",{"tank","has transferd1","has transferd2","posistion from","position to","amount"})
    --end
    for k , v in pairs(config.directionredstoneassline) do
        addressRedstoneAssline[k].setBundledOutput(v,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
    end
    local slot = 1 
    local transfercount = 1
    --addressRedstoneLoader.setOutput(0,15)
    for j = 1 , loadmap.length do 
        if loadmap[j] and slot < 7 then
            for  i = 1 , 10 do
                --print(loadmap[j][1],loadmap[j][4])
                if config.use_enderchest == false then
				resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl)
                end
                local hastransferd = addressItem.transferItem(1,config.directionloader.directionitem[loadmap[j][1]],loadmap[j][2],loadmap[j][3],loadmap[j][4]) == 0
                --logger.log("printitem",{hastransferd,config.directionloader.directionitem[loadmap[j][1]],loadmap[j][2],loadmap[j][3],loadmap[j][4]})
                if hastransferd then
                    print("item faild trasfer")
                    os.sleep(0.2)
                else
                    --print("transfer"..loadmap[j][5])
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
                --print("transfer"..loadmap[j][5])
				--print(loadmap[j][1])
                addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],liquidbundl[loadmap[j][1]])
                if transferFluid(addressFluid1,addressFluid2,addressFluid3,loadmap,j) == 0 then
                    local breakcount = 0
                    while transferFluid(addressFluid1,addressFluid2,addressFluid3,loadmap,j) == 0 do
                        breakcount = breakcount + 1
                        if breakcount == 80 then
							breakcount = 0
                            resetout(addressRedstoneLoader,addressRedstoneAssline,nassline,loadmap[j][1]+1,liquidbundl)
                            local crash
                            --print(loadmap[j][1],slot)
					        print("total falure")
					        print(crash..crash)
                        end 
                        os.sleep(0.2)
                    end
                else
                    os.sleep(0.30)
                    reset(addressRedstoneLoader,addressRedstoneAssline,nassline,loadmap[j][1]+1,liquidbundl,true,nil,addressFluid1,loadmap,j)
					local crash
                end
            end
        else
            if slot < 7 then
                os.sleep(0.30)
                if config.use_enderchest == false then
				reset(addressRedstoneLoader,addressRedstoneAssline,nassline,slot,bundl,false,transfercount,addressItem,loadmap,j)
                end
                if slot < 6 then
				--print(nassline)
                addressRedstoneAssline[nassline].setBundledOutput(config.directionredstoneassline[nassline],bundl[slot])
                end
            end
            slot = slot + 1
            transfercount = j + 1
        end
    end
    --addressRedstoneLoader.setOutput(0,0)
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
    print("time to load = ",computer.uptime()-startTime)
    print("done")
end


function transferFluid(addressFluid1,addressFluid2,addressFluid3,loadmap,j)
    local temp1 
    local temp2
    local position = config.directionloader.directionfluid2
    if loadmap[j][3] < 4 then
        --print(position[4],"pos4")
        temp1 = addressFluid2.transferFluid(position[loadmap[j][3]],position[5],loadmap[j][2])
        temp2 = addressFluid1.transferFluid(position[3],position[5],loadmap[j][2])
        --logger.log("fluidtransfer",{loadmap[j][3],temp1,temp2,position[loadmap[j][3]],position[5],loadmap[j][2]})
        return temp2
    elseif loadmap[j][3] == 4 then
        temp1 = addressFluid1.transferFluid(1,position[5],loadmap[j][2])
        --logger.log("fluidtransfer",{loadmap[j][3],temp1,nil,nil,position[5],loadmap[j][2]})
        return temp1
    else
        temp1 = addressFluid3.transferFluid(localpos[loadmap[j][3]-4],0,loadmap[j][2])
        temp2 =  addressFluid1.transferFluid(position[3],position[5],loadmap[j][2])
        --logger.log("fluidtransfer",{loadmap[j][3],temp1,temp2,localpos[loadmap[j][3]-4],position[5],loadmap[j][2]})
        return temp2
    end
end



return LoadAssline
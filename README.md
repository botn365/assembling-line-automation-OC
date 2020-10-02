### assembling-line-automation-OC
automating assembling line with open computers



program exists out of multiple servers each do their own thing  

## head servers  

# main server  
evry other server conncets tho this this also controls al the other  
only put 1 of them in the network  

# item-server  
this server puts th items and runs the assline  
and controlls it  

# fluid-server  
puts th fluids in the assline  

## misc servers  
servers that do other stuff not and are not super importent to the program

# command server  
this server alows you to send command to it  
you need this to setup servers

# graphical command server  
coming soon if i ever get to it

# listenr  
records and writes down all importen msgs sent trough the modem  
mostly used to know if somthing went wrong   

## downloading programs

run the download.lua program with as argument the fits 3 leters of the drive address
example
```
download_main 13a
```
commands to download the programs
does not matter where they are downloaded
```
download main
wget https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/main-server/download_main.lua
for item server
wget https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/item-server/download_item.lua
for fluid server
wget https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/work-servers/fluid-server/download_fluid.lua
command server
wget https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/misc-servers/command-server/main.lua
msg listener
wget https://raw.githubusercontent.com/botn365/assembling-line-automation-OC/ae-intergeted/misc-servers/msg-listner/main.lua
```

## component requirments
 
# misc
- internet card (to download programs)

# main server  
- cpu
- network crad
- hard disk
- lots of ram
- gpu (optional)

# item and fluid server
- cpu
- network crad
- some ram
- hard disk
- 1-2 T3 component bus (depents on length of assline)

# command server
- cpu
- litle ram
- network card
- hard disk
- graphics card

# msg listner
- cpu
- some ram
- network card
- gpu (you could cal the file autorun once it is configured and then you dont need this)
- 2 hard disks (one to save the file in)

## seting up

item and fluid serevr just need to be turned on  
make sure the network conection and component conection is difrent for all servers  

to configure a assline in the command server  
type "add_assline" and fill in the information  

addresses shown of servers is the address of the netwoerk card  

on the 3 directions when configuringa fluid server  
first is the side of the transposer where the multie hatch of the t.f.f.t is conected  
second the side of the transposer is where it pushes the fluid wich then gose to the assline  
third side of wich the cable is atached  


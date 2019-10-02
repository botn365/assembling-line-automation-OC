# assembling-line-automation-OC
automating assline with open computers

automating the assembling line with this program exists of 2 parts the loader and the assembling line part
this system works with ender chests or AE p2p tunnels
if you use enderchests I = ender chest and Fo = ender tank also enbale use_enderchest in the config.lua file

if you use AE p2p tunnels I = gt buffer with a machine controller cover, item detector cover 
and a conveyor belt on export(conditinal) 
Fo = gt tank with a a machine controller cover, fluid detector cover and a pump on export(conditinal) 

# THE LOADER PART


T = transposer, I = buffer/ender chest, Fo = tankA/ender tank, Fi = tankB, P = (gt)pipe, R = OC redstone component
C = chest, M = me inteface, Mf = me fluid interface  () =  block behind it  E = empty space

  E    Fi    E    Fi    E       
 Fo    T(M)  Fi  T(Fi)  Fi      
  E    C     Mf   P     E       
  I1   T     I3           
  E    I3    E       
  E    R     E   
  
  Fi is a normal tank
  
  the front of the loader to what derection this side faces is what needs to be fild in the config.lua file
  the back of the OC redstone component needs to be concted with the fluid/item detector this is to make sure
  the item gets transported to the assembling line
  
  (only if you use AE p2p tunnels) you want to conect the bottem of the OC redstone component to the 
  machine controller cover 
  
  
  # THE ASSEMBLING LINE PART
  
  evry input bus needs a shutter cover or a conveyor belt on import(conditinal) if your using ender chests on the bottem of
  on the bottem of the bus on the side facing away from the imput hatches there needs to be a machine contoller cover
  the same needs to be done with the fluid covers
  
   O = output bus I = input bus I1 p2p from I1 of the loader or ender chest with the same code as I1 the same for I2 and I3
   
   E = empt space
  
   O I | I | I | I | I | I | I | I | I | I | I | I | I | I | I
  
   E I3 I3 I3 I3 I3 I2 I2 I2 I2 I2 I1 I1 I1 I1 I1
   
   E BLA | R | G | BR | BLU (reepeted 3 times)
   
   the input hatches need to be conectet with the collers grey,light grey,cyan and magenta from firts  to last input hatch
   
   when a item gets made you need to send a signal trough the yellow wire  
   
   # how to add a new recipy
   
   in LoadRecipy.lua
   
   r.addRecipy("output", {{amount,name input 1 },{amount,input 2}} , {{amount,fluid}} exemple:
   
   r.addRecipy("Electric Motor (LuV)",{{1,"Magnetic Samarium Rod"},{2,"Long HSS-S Rod"},{64,"Fine Ruridit Wire"}
,{64,"Fine Ruridit Wire"},{2,"1x Yttrium Barium Cuprate Cable"}},
{{144,"Molten Soldering Alloy"},{250,"Lubricant"}}
  
  
  # HOW TO ADD RECIPY TO AE WITH MORE THEN 9 INGREDIENTS
  
  in LoadRecipy.lua  in the line local r = R.RecipyArray() you can add a between item 
  ({{itemIn,ItemOut},{itemIn,itemOut}})
  
  to use this in AE autocrafting  
  
  item/fluid + item/fluid  + itemIn = itemOut
  
  item + item + item + item + itemOut = end result
  
  the itemIn and itemOut have to be sticks for OC to know the diftrents you have to rename them so 
  itemIn needs to have the exect name to how you renamed the stick 
  you can easly rename the sticks with a tool forge
  
  # TO INSTAL ON COMPUTER
  
  download files from github and un zip
  go to you safe file and in the opencomputer folder and place it in the folder
  of the drive that is in that computer
  
  
  

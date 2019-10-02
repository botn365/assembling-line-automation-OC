# assembling-line-automation-OC
automating assline with open computers

automating the assembling line with this program exists of 2 parts the loader and the assembling line part
this system works with ender chests or AE p2p tunnels
if you use enderchests I = ender chest and Fo = ender tank also enbale use_enderchest in the config.lua file

if you use AE p2p tunnels I = gt buffer with a machine controller cover, item detector cover 
and a conveyor belt on export(conditinal) 
Fo = gt tank with a a machine controller cover, fluid detector cover and a pump on export(conditinal) 

the loader part


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
  
  
  the assembling line part
  
  evry input bus needs a shutter cover or a conveyor belt on import(conditinal) if your using ender chests on the bottem of
  on the bottem of the bus on the side facing away from the imput hatches there needs to be a machine contoller cover
  
  
  

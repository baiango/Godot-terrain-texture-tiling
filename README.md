# terrain-texture-tiling
 
It features:
- No hard edges because of no UV rotation
- No mini conditional branch so it's predictable for the GPU and the compiler(if any)
- Easy to use yet flexible (Although there are hard coded numbers)

Drawbacks:
- You have to duplicate the mesh and place below -0.05 Y or inside the mesh in order to get the shader read the Z-buffer. And that creates Z-fighting
- Minor +x self overlapping from the back quad (If you look the mesh from right side to left)
- Z-fighting in the editor viewport. Increase camera near culling to and reduce it. Or hide the z-mesh. (Note the shader will start to overlapping itself once you hide it)
- You can't use transparency on z-mesh or the shader will fail to read Z-buffer (No one is supposed to found out the z-mesh anyway)

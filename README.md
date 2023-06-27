# Terrain-texture-tiling
 
It features:
- 3 examples of the shader (2 hill meshes, 1 csgbox)
- No hard edges because of no UV rotation
- No mini conditional branch so it's predictable for the GPU and the compiler(if any)
- Easy to use yet flexible (Although there are hard coded numbers)
- Tiny project size. The JPG is compressed by Guetzli and jpegtran 3.3.1. The EXR is compressed by PIZ lossless codec from Blender. (Because Godot 4 doesn't support lossy EXR for some reason)

Drawbacks:
- You have to duplicate the mesh and place below -0.05 Y or inside the mesh in order to get the shader read the Z-buffer. And that creates Z-fighting
- Minor +x self overlapping from the back quad (If you look the mesh from right side to left)
- Z-fighting in the editor viewport. Increase camera near culling to and reduce it. Or hide the z-mesh. (Note the shader will start to overlapping itself once you hide it)
- You can't use transparency on z-mesh or the shader will fail to read Z-buffer (No one is supposed to found out the z-mesh anyway)

Screenshots:  
(All of these are on 1k textures which means it takes up 3.3 MiB VRAM for the diffuse, ambient occlusion roughness metallic texture, mask, and normal map texture.)
![Godot_v4 0 3-stable_mono_win64_6Vt3nMTxj4_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/9323d065-08d2-4be4-8af5-5b469c75dad9)
![Godot_v4 0 3-stable_mono_win64_yM2adCp0Dr_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/37c0e92e-a3cf-4e2a-b797-d6c05c86bafe)
![Godot_v4 0 3-stable_mono_win64_MLP0iErn0a_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/614bf17d-de64-4007-ab85-7d5774c7e2a3)
![Godot_v4 0 3-stable_mono_win64_4XQ8rgcYWj_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/b148d989-ed64-4b57-bf1f-d72128f1788b)

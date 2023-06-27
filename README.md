# Terrain texture tiling
 
It features:
- 3 examples of the shader (2 hill meshes, 1 csgbox)
- No hard edges because of no UV rotation
- No mini conditional branch so it's predictable for the GPU and the compiler(if any)
- Easy to use yet flexible (Although there are hard coded numbers)
- Tiny project size. (10.7 MiB when commit 8th/e57c254) The JPG is compressed by Cjpeg(was using Guetzli before) at 75% and Jpegtran 4.1.1 from Mozjpeg. The EXR is compressed by PIZ lossless codec from Blender (Because Godot 4 doesn't support lossy EXR like DWAB for some reason)

Drawbacks:
- You have to duplicate the mesh and place below -0.05 Y or inside the mesh in order to get the shader read the Z-buffer. And that creates Z-fighting
- Minor +x self overlapping from the back quad (If you look the mesh from right side to left)
- Z-fighting in the editor viewport. Increase camera near culling to and reduce it. Or hide the z-mesh (Note the shader will start to overlapping itself once you hide it)
- You can't use transparency on z-mesh or the shader will fail to read Z-buffer (No one is supposed to found out the z-mesh anyway)

# Screenshots  
(All of these are on 1k textures which means it takes up 3.3 MiB VRAM for the diffuse, ambient occlusion roughness metallic texture, mask, and normal map texture)  
### Z-fighting
![Godot_v4 0 3-stable_mono_win64_6Vt3nMTxj4_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/9323d065-08d2-4be4-8af5-5b469c75dad9)
### Setting camera near culling to 1m  
![Godot_v4 0 3-stable_mono_win64_yM2adCp0Dr_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/37c0e92e-a3cf-4e2a-b797-d6c05c86bafe)
### Camera close-up
![Godot_v4 0 3-stable_mono_win64_MLP0iErn0a_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/614bf17d-de64-4007-ab85-7d5774c7e2a3)
### OmniLight3D scatter through volumetric fog with 40000 kelvin(98baff)
![Godot_v4 0 3-stable_mono_win64_4XQ8rgcYWj_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/b148d989-ed64-4b57-bf1f-d72128f1788b)
### ![Self overlapping hill](https://github.com/baiango/terrain-texture-tiling/assets/105705580/49786963-2846-4f4e-8dc4-24d938745920)
(This is unavoidable unless there's another way to get the Z-buffer without placing the mesh below or inside)

# Art style guide
The 3D model can be as random as possible like going from realistic to abstract or very consistent  
The sun angular size should be 0.1 for soft shadows  
The sun color should be 5600K(ffefff) as in daylight  
Most light falloff/attenuation should be 1.5 for matching inverse-square law  
Most light size should be at least 0.1 m unless it's a very small object  
The natural light(sun, fire) must be in range of 1000 K to 40000 K. There's no requirement for the temperature accuracy as long it's not way off from the actual stuff  
The artificial light(Outside of the natural light range) can be used as you wish. But natural light is preferred  
Recommend 18mm(67.4 FOV) instead of 12mm(90 FOV) camera focal length for any camera  
### 12mm(90 FOV) with distance of 2m (Too distorted)
![Godot_v4 0 3-stable_mono_win64_15maDM28Zs_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/77f150ce-2ee9-40d8-9a22-c2589f30a65d)
### 18mm(67.4 FOV) with distance of 3m
![Godot_v4 0 3-stable_mono_win64_FoqWmXDLjQ_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/b1bb4849-d127-48ea-b2f8-5e27aee78119)
### 24mm(53.1 FOV) with distance of 4m (Too tight)
![Godot_v4 0 3-stable_mono_win64_VCicejQ7J3_out](https://github.com/baiango/terrain-texture-tiling/assets/105705580/a8508272-e852-45cf-a2fb-5b4079ff3a82)
## Tone
It should be fun or visually pleasing to look at the scenes instead of sad  
It should be looks like a colored coloring book or with a wide range of color  

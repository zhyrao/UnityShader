#### Irradiance Environment Map
在本节中我们将学习了解'Irradiance Environment Map', 它是怎么计算的以及在场景中是怎么运用的. 在我们深入irradiance envrionment map之前, 我们需要理解一些概念: 
> 不管何时我们看到任何技术方案设计环境贴图(environment map), 这就意味着它是一个基于图像渲染的技术(iamge-based rendering technique)或者基于图像的光照技术(image-based lighting technique). 

现在我们理解一下什么是irradiance: 
> 在理解irradiance之前, 我们了解一下什么是radiance. 在前面的章节中, 我们知道光线波是由粒子组成的, 这些带有能量的粒子我们成为"光子". radiance是值在某个单位表面在某个给定方向上, 在单位时间内发射的能量. 在这里, 我们可以将光源看做是发射能量的表面, 所在单位表面在单位时间内会在给定的方向上发射能量. 我们想象灯光是一个高瓦特的光源, 它能够发射热量和能量, 如果灯光变得越来越大, 那么发射的能量也增加了; 这个灯光持续的越久, 那么越多的能量就会被发射出来. 我们也可以在场景中想象这个东西.  这样以来, 物体的表面也会接受到灯光能量, 而单位面积内接受到的能量我们成为irradiance. 

> 假设我们在场景中有9盏灯光和一个物体. 为了计算每个fragment中的diffuse lighting, 我们需要很多的计算. 前面已经学习过了计算diffuse lighting, 我们是利用 *max(0, dot(n, l)* (n是物体表面的法线向量, l是灯光方向的法线向量). 所以我们需要的计算量(fragment-based) operations = number of fragments of surface * number of lights. 这样最终的颜色结果就是: 
> **color = max(0, dot(n, l1)) + max(0, dot(n, l2)) + max(0, dot(n, l3)) + ... +  max(0, dot(n, l9))**  
> **Σ(0 <= i <= n) max(0, dot(n, l))**  
> 这就是场景中有n个灯光的总和.   

> 当场景中的灯光数量增加的时候, 那么计算场景中的diffuse lighting的操作数量也是在持续增加的. 当灯光增加到某一个点的时候, 这个计算量将会增加到很高的数量, 这样的话在实时渲染中, 如果要好的帧率的情况下是很难计算的. 这样我们必须要来进行对这个过程的优化. 

一个优化的方案就是我们将所有场景中的灯光都保存到一张成为环境贴图的纹理中. 这是一个很有效的方法去把灯光信息存入到一张纹理中.  
> 这样的话在我们的环境贴图中, 我们将会把9个灯光变成为"texel". 每一个"texel"表示场景中的某一个灯光. 到目前为止, 我们可以认为"texel"是贴图中的一个像素. 虽然这种方式我们很有效的存储了灯光的信息, 但是我们实际上还是没有减少需要计算的操作步骤数量, 这是因为我们还是需要计算9个灯光. 唯一的区别是我们不需要再去获取场景中灯光, 而是在环境贴图中找到灯光的方向向量. *但是我们的目的是节省计算的操作步骤*

另外一个方案是使用light map(光照烘焙贴图):  
> 我们可以将场景中的相关光照信息烘焙到纹理贴图中. 我们可以预计算所有的光照计算, 然后烘焙到一张纹理中, 然后在我们的游戏中直接使用它. 在烘焙的时候, 光照信息依然是依据max(0, dot(n, l))来计算的. 所以这个纹理贴图的diffuse部分依然是基于n.l计算得到的. 这样当我们在烘焙的时候, 我们的信息是基于已经给定的发现向量和光照方向向量的, 这样一来我们就相当于在light map中固定了我们的信息, 我们就不能旋转或者移动灯光以及场景中的任何物体了. 这就是lightmap的缺点: 所有的场景中的东西都必须是静止不动的(static). 一旦物体旋转或者改变了, 那么预计算出阿里的信息就不可用了. 

那么, 我们就需要换一种思维了. 我们想象在世界中心有一个球形物体, 这个球形物体的每个点都有法线向量. 然后从这个法线方向我们将会使用环境贴图中得到的9个"texel"来光照信息max(0, dot(n,l)).
![sphere map](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_51/Slide_51/Slide_04.png?raw=true) 

所以对于某点的法线n1来说, 我们将计算它与所有的光源的光照运算:  
**max(0, dot(n1, l1)) + max(0, dot(n1, l2)) + ... + max(0, dot(n1, l9))**  
**color = Σ(0 <= i <= n) max(0, dot(n1, l_i))**  
这样就能得到这个表面上的点的最终的颜色, 接下来我们要做的就是创建一副另外的environment map, 这个环境贴图就是我们所说的irradiance environment map. 
![irradiance environment map](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_51/Slide_51/Slide_05.png?raw=true)

上图所示的黄色的贴图就是irradiance environment map. 目前还没有这个贴图上还没有任何的信息, 我们将会一个一个的来填充它. 
上面, 我们已经计算到了n1的最终颜色color. 假设n1持续延长后将会在irradiance environment map上相交于一个点(图中绿色的点), 那么在environment map中的这个点将会存储n1的最终颜色color. 
> 1. 我们先选取表面上的某个点的法线.
> 2. 我们将会结合场景中的所有光源(9个)来计算这个点的最终颜色. 
> 3. 我们将这个法线与irradiance environment map相交的位置上存储物体表面这个点所计算出来的颜色值. 

接下来我们将对物体表面上所有的点都重复这3个步骤, 然后存储在environment map中. 这就是如何全部得到irradiance map的方法. 所有的这些计算都是预处理的计算, 所以我们不会在程序或者游戏运行的时候来进行计算(耗时耗力). 我们预计算所有的漫反射的光照值, 然后存储到irradiance environment map中, 这个irradiance environment map将会在计算场景的最后漫反射的时候使用. 

我们怎么在运行时来计算场景中的漫反射呢? 我们接下来就会讲解.  
![calclate map](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_51/Slide_51/Slide_07.png?raw=true)
这个就是我们预先计算和存储的环境贴图(environment map), 不同的图素(texel)中有不同的颜色值. 我们将使用这个环境贴图来计算场景中的漫反射. 

假设我们将这个环境贴图给场景使用了, 场景中有一个球和方块. 场景中物体的表面都会有一个法线向量, 这个向量当然也是一个方向向量. 现在我们将要来计算在这个表面上产生的漫反射(diffuse reflection). 为了得到这个值, 我们采取的方法是将这个法线向量放到环境贴图的中心位置, 那么因为它是一个方向向量, 它始终会与环境贴图相交的, 而在环境贴图中的这个交点的值就是这个物体的这个点在场景中的漫反射的值. 我们计算颜色值的时候已经知道需要两个信息, 法线值和灯光方向向量值, 也就是说任何表面上只要有相同的法线向量值那么我们将会从环境贴图中提取到相同的值. 

为了理解我们如何找到法线和环境贴图相交点的颜色值, 在CG shader中有一个函数叫texCube()来帮助我们, 它有两个输入参数(CUBEMAP, NORMAL):  
> 接受一个环境贴图和法线向量, 返回这个法线在这个环境贴图上交点的值. 


当我们理解了上面所有的环境贴图信息后, 另外一个想法出现了.  
**在现实世界中, 一个物体越接近光源, 会越亮, 这个现象也是在点光源和区域光源中出现的.**    
但是我们从irradiance environment map中怎么才能看到这种现象呢?  
答案是不能看得见. 这是因为不管是在我们创建irradiance environment map的计算过程中, 或者是读取irradiance environment map中, 我们都没有相关与灯光距离(distance)的变量. 我们计算所用到的两个变量仅仅是法线向量和灯光的方向向量. 这就是为什么我们认为所有的基于图像的irradiance environment map, reflection map都是基于无穷远的, 跟平行光类似. 

到目前为止, 我们已经讨论了如何创建和读取radiance environment map的理论概念. 我们基于读取所有可能的法线向量的条款在我们编写代码的时候是不能的, 所以我们需要指定一个数量来表示我们需要读取多少个法线, 我们怎么获得他们 以及我们怎么烘焙他们. 
![howtocalc1](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_51/Slide_51/Slide_09.png?raw=true)
![howtocalcluate](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_51/Slide_51/Slide_10.png?raw=true) 

#### Image Based Reflection
在本节中, 我们来看看编写image-based reflection shader的基础. 在介绍image-based lighting的章节中, 我们使用一个chrome ball来捕获环境, 然后将捕获的环境转化为立方体贴图. 
![chrome ball](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_01.png?raw=true)  
> 具体细节就是当我们捕获周围环境信息的时候, 我们使用了一个chrome ball(反射性非常好的球), 然后在较远的位置放置了一个摄像机, 这个摄像机可以看到chrome ball 上面反射的最大程度的信息.  然后将它转换为立方体贴图cube map. 最后这个cube map被用来当作image-based lighting. 这就是捕获制作环境的过程.  当我们在场景中使用这个cube map作为光照信息的时候, 我们将它当作是周围的环境信息并且我们将使用同样的计算过程来计算光照信息. 

![usecubemap](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_02.png?raw=true)
假设在我们的场景中有一个没有颜色的反光的球, 然后在球的周围包围着一个cube map. 当我们捕获环境信息后, 这个cubemap就被当成了场景中的光照信息. 当我们计算球上的某个点的颜色的时候, 这个点具有法线向量n的. 然后我们计算视线方向向量v, 这个向量是从球上的这个点到摄像机的位置的向量. 然后在这个视线方向向量和点法线的结合上, 我们计算这个视线在反射向量R. 依据反射定律可以知道n和v的夹角和r和n的夹角是一样的. 当我们计算出反射向量r的时候, 我们接着计算反射向量r和cube map的交点, 然后取得cube map中这个位置的像素(texel), 然后将它应用到这个表面上面. 重复这个步骤, 这样我们就能填满场景中的所有的物体的表面. 这个就是image-based reflection工作的原理. 

在计算的时候, 我们需要 "WorldspaceViewDir", 然后需要计算reflection dir(前面章节中已经学习过了如何计算光线的反射, 视线的反射同理).  或者直接使用CG shader中提供的函数reflect(-in vector, normal vector) 注意这里需要传入-的视线方向向量. 
![reflectiondir](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_04.png?raw=true)

现在我们已经理解了shader中需要的技术, 我们来看看在shader中我们需要什么样的属性以及如何计算环境反射.  
- Cube Map
- Reflection Factor
- Level of Detail
- Exposure 
- Reflection ON/OFF

> 如果基本光照是打开的, 我们将基础光照的结果和基于图像反射的结果相乘; 如果基本光照是关闭的, 结果光照加上反射光照信息. 
![basic lighting and environment light](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_03.png?raw=true)


我们也知道在计算光照的过程中我们需要视线的方向, 也就是视线方向向量, 然后基于这个视线方向向量和点的表面法线, 来计算视线基于法线的反射向量. 一旦我们获得到了这个反射方向向量, 我们就可以使用函数texCUBE()来获取环境贴图的像素信息. 
![reflection dir](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_05.png?raw=true)

我们也在shader的属性中定义了细节层次系数(表示我们想要多少的细节信息), 使用这个属性的时候我们需要使用另外一个函数texCUBElod(\_cubeMap, float4):  
> \cubemap是环境贴图, float4(x,y,z,w)中的xyz组成为法线信息, 而w是lod的系数. 其中1代表最高程度的层次细节.  

那么我们是如何得到越来越低的细节信息呢? 我们通过**mip-mapping**来实现的  
##### Mip-Mapping 
mip-mapping技术的核心就是贴图纹理缩小原来的倍数(通常是1/2倍)来得到另外一个层次的纹理贴图
![mipmapping](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_52/Slide_52/Slide_06.png?raw=true)
在unity中可以在贴图的属性中打开mip mapping这个控制属性. 这样的话unity就可以预先给我们创建好相关层次的mipmapping

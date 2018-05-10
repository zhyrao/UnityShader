#### Image Based Lighting
在本节中, 我们来学习基于图像的光照(Image Based Lighting).

当我们在计算机图形学中计算光照的时候, 我们尽量的尝试来模仿真实世界的光照. 而通常在真实的世界中, 光照是由多个光源组成的. 例如: 

![newyork church](http://collarcitybrownstone.com/wp-content/uploads/2013/04/Saint-Pauls-church-in-Troy-New-York.jpg)

在这个教堂中, 由很多灯光提供照明. 那么如果我们尝试在场景或者图形中计算这么多灯光效果, 那么计算量是非常耗时耗力的. 所以我们需要找到一个替代的方法来在我们的场景中来计算这么多光源的效果. Image based Lighting是其中的一个解决方案, 这个完整的技术方案被分为了几个步骤:

**1. 将环境光照的信息烘培/捕获到一张纹理当中.**
> 这个过程有好几种方案来实现:
> - Chrome Ball:  
> 在这个方案当中, 一个非常光滑反射很强的球放置到想要烘培的场景当中, 然后一个相机放置到距离这个球较远的位置, 这样可以尽可能的拍摄到更多的可视的区域. 这个chrome ball会从各个方向来获取光线信息. 这个从全方向获取光照信息的纹理贴图被称为light probe(光探测器). ![chrome ball](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_50/Slide_50/Slide_02.png?raw=true)
> - Fish Eye Lens:   
> 另外一个用来捕获光照信息的技术方案是使用鱼眼镜头. 鱼眼镜头是一个广度镜头, 它可以拍摄周围185度视角的信息. 所以使用鱼眼镜头的时候, 可以获得185度范围内的信息. 然后将两张鱼眼镜头的照片缝合在一起, 就得到了360的光照信息. ![fish eye lens](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_50/Slide_50/Slide_03.png?raw=true)

> 后面的时候将利用这个纹理来创建环境映射图environment map.

**2. 从光照探测器的结果中创建环境贴图(environment map).**
> - sphere map
> - cube map

**3. 使用环境贴图来计算环境光照信息.**

以上就是创建场景中环境光照的3个步骤, 在后面的章节中我们将编写shader来计算image based reflection和image based refraction. 

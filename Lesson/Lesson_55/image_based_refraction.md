## Image Based Refraction
在本节中, 将学习一下计算机图形学中的`Refraction`(折射)现象. 什么是折射, 折射是怎么发生的? 后面在从折射推导出折射公式, 方便后期在编写shader的时候使用. 

![refraction](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_55/Slide_55/Slide_01.png?raw=true)
>从图中可以看出, 在一个透明的玻璃本中装了半部分的水, 然后将一根吸管放进去, 当我们从玻璃杯外面观察的时候, 发现原本是直的吸管从外面看的时候在与水面接触的的部分已经弯曲(被折断了一样)了, 这种现象称为折射现象.  

### 介质 
在前面的章节中, 我们已经知道如果我们能看到某些物体, 是因为光线在照射到这个物体表面的时候进行反射, 这个反射光线进入了我们的眼睛. 在这样的情况下我们就看到了这个物体. 在这个过程中, 光线是在`空气`中传播的, 这个`空气`这类的传播物质被称为**介质medium**.  

### 太阳光
同样的, 当我们看到阳光的时候, 实际上太阳发射的光线已经经过了8分20秒长的时间在真空中的传播, 才到达了地球.  
![sunshine](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_55/Slide_55/Slide_02.png?raw=true)  

### 折射 
光线在不同的介质当中传播的速度是不同的, 因为不同的介质中, 它们的光学密度是不同的, 正是因为这样的原因才导致了折射现象的发生.  
**折射是这样的一种大气现象, 光线在进入新的媒体介质的时候会发生弯曲的现象.(如上图)**  
当光线进入一种新的介质的时候, 不光它的方向会改变, 光线的速度也会改变:  
1. 方向 -- 方向折射
2. 速度 -- 因为介质的不同的`折射指数indices of refraction`, 光线的速度可能下降有可能提升


### Indices of Refraction (折射指数)
简单来说, 折射指数是指光线在这个介质当中的弯曲的程度值. 它是由光线在真空中传播的速度和光线在这个介质中传播的速度的比例而计算出来的.  
![refractive index](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_55/Slide_55/Slide_03.png?raw=true)
> 需要注意的是, 在真空中的光线的传播速度是最快的. 因为在真空当中, 并没有存在微小的粒子去阻挡光线的传播. 它的默认值是1. 


### Refraction formula(折射公式)
现在我们已经理解了折射的基本概念, 那么我们来看看如何推导折射的公式. 
![refractionformula](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_55/Slide_55/Slide_04.png?raw=true)
> 在上图中, 假设水平线上下是两种不同的介质, 水平线的位置就是这两种介质的相交处. 垂线是这两种介质中的法线. 从左上方有一条入射光线I从介质1射入到两种不同介质的交点, 然后在介质2冲继续传播, 但是因为两种介质不同的, 所以光线在介质2种传播的方向和速度是不一样的. 为了方便计算, 我们都将所有的信息认为是向量. 现在我们有已知入射方向向量I和法线n, 我们需要计算出来的就是折射光线R.  

在整个推导的过程当中, 我们需要一些额外的工具\公式来帮助我们完成整个公式的推导: 
- (sinθ)^2 + (cosθ)^2 = 1
- ProjL on N = (N dot L) * L 
- sinθ = 对边/斜边
- 如果两个向量的方向和长度是相等的, 那么这两个向量相同. 

### SNELL'S LAW
在理解折射的过程中, 都会接触到一个定律`Snell's Law`(斯涅尔定律), 科学家snell发现了关于光线从一个介质传导到另外一个介质中的定律:  
![refractivindex](http://latex.codecogs.com/gif.latex?%5Cbg_white%20index_1*sin%5CTheta%20_1%3Dindex_2*sin%5CTheta_2)
> 其中index1指的是介质1的折射率, θ1指的是入射光线和法线的夹角.  
> index2指的是介质2的折射率, θ2指的是折射光线和负法线的夹角.


### Refract
![REFRACT](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_55/Slide_56/Slide_01.png)
> 如上图所示: 我们已知两种不同的介质, 以及入射光线和入射点的平面法线. 为了方便计算, 都认为它们是向量, 并且是单位向量. 

推导过程省略, 结果如下:  

![formula](http://latex.codecogs.com/gif.latex?%5Cbg_white%20%5Clarge%20eat%20*%20%5Cvec%7BI%7D%20&plus;%20%5Cvec%20%7BN%7D%20*%20%28%28eta%20*%20cos%5Ctheta_I%29%20-%20%5Csqrt%5B%5D%7B1-eta%5E2%20*%20%281-cos%5E2%5Ctheta_R%29%7D%29)  

其中 eta 表示:   

![eta](http://latex.codecogs.com/gif.latex?%5Cbg_white%20%5Clarge%20%5Cfrac%7Bindex_I%7D%7Bindex_R%7D)

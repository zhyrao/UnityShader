#### Specular Reflection Introduction
在本节中我们将学习Specular Reflection(高光/镜面反射): 
- "Specular Reflection"是光滑表面的一种属性; 
- 是相对于反射表面对应的shininess; 
- 反射表面会产生高光反射(specular highlight)

> 从上述的3中属性得出一件事情, 所有的都是关于反射的. **Law of Reflection**是一种常见的现象


##### Law of Reflection
![law of reflection](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_42/Slide_42/Slide_02.png?raw=true)

如图中所示:  

在一个表面上有法线N, 入射光线R_i, 和反射光线R_r.因为这个表面是光滑反射的, 所以入射光线和反射光线以表面法线为中心对称. 那么就可以知道R_i和法线N的夹角θ_i与R_r和法线N的夹角θ_r是相等的. 

从这里可以看出, 不同于diffuse reflection中光线是朝着所有的方向漫反射的, 对于光滑表面光线只反射到一个方向, 这就意味着反射光线有可能不会进入视线范围内, 那么我们就看不到这个反射光线. **这就意味着specular reflection的光照计算是和视线相关的.**

下面就来看看怎样计算specular reflection, 通常会至少有3中变量:
1. 入射光线的方向向量
2. 法线Normal向量
3. 视线到顶点的方向向量

Phong, 计算机图形学的大牛, 观察到这样的现象: 对于非常光滑明亮的表面, 它的反射高光很小, 并且强度衰减非常快; 对于没有那么光滑的表面来说, 高光反射范围较大, 并且强度衰减的比较慢. 如下图所示: 

![](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_42/Slide_42/Slide_04.png?raw=true)

Phong对于这种现象可以理解为在law of reflection上面添加了cone of reflectance. 
![phong](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_42/Slide_42/Slide_05.png?raw=true)

从上图可以看出这个椎体的夹角为φ, 它有以下的几种意义:
- 高光反射的可视范围
- 椎体的直径决定了材质的高光反射属性
  >越大的直径表示可视的光斑越大, 高光没有那么强烈.
  
所以当我们的视线在椎体内的时候, 我们是可以看见高光的; 在椎体外面的话, 是看不见高光的; 并且可以看出视线和反射光线之间的夹角影响着高光反射的强度. 这样使我们回想起了lambert漫反射的原理, 那么在高光反射中也是一样的, 我们需要计算max(0, dot(R, V))

Phong也观察到在cone of reflectance中, 强度也有一个衰减, 这个衰减可以近似的表示为 (Cosθ)^S, 其中s表示specular power.

综合上面的解释我们可以得到这个公式: **max(0, dot(R,V))^s**, 那么我们来看看现在已知的信息:
- 表面的法线normal
- 光源的位置
- 摄像机的位置

我们只有反射光线是未知的, 那么我们怎么来得到这个反射光线呢?
![R](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_42/Slide_42/Slide_07.png?raw=true)

从上图可以知道, 我们需要首先得到入射光线向量L的反向向量-L, 然后在-L中移动2个L对于法线的投影向量, 得到反射法线R.  
                    **R = 2(N dot L)N - L**

然后带入公式:

  max(0, (2x(N . L)N - L dot V)) ^ 
  

##### Blinn Phong
后来的, blinn在上面的基础上优化了这个方法.  
max(0, dot(N, H))^s  
>其中N是表面的法线, H是normalize(L + V), 这样就不需要那么多的计算而得到非常相似的效果. 

这个被称为Blinn Phong Specular Equation:
![equation](http://latex.codecogs.com/gif.latex?%5Cdpi%7B200%7D%20%5Csmall%20S%20%3D%20%5Csum_%7Bi%3D0%7D%5E%7Bn%7Dintensity_%7Blight%7D%20%5Ctimes%20specular%20property%20%5Ctimes%20attenuation%20%5Ctimes%20max%280%2C%20%28N%20%5Ccdot%20H%29%29%5E%7Bspecular%20power%7D)

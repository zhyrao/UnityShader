#### Hemispherical Lighting Model
在本节中, 我们来学习Hemispherical Lighting Model(半球光照模型). 

通过名字可以看出来, 这个模型含有两个上下半球, 在这个模型中, 我们的环境光照被分为了2个部分(半球形), 物体则是被认为在两个半球组合成的球形的中心位置. 
> 上半部分的球形被认为是天空;
> 下半部分的球形被认为是ground. 

如果物体表面的法线指向天空, 那么表面从天空(上半部分球形)获取到颜色; 如果法线指向了下面部分球形, 那么表面通过下面部分球形来获取到颜色.

简单来说, 如果考虑光线是平行光(directional light), 那么当*Dot(n, l) > 0*的时候, 得到的是天空的颜色; 当*Dot(n, l) < 0*的时候得到的是地面的颜色. 
> 其中n是表面法线向量, l是入射光线方向向量

![hemispherical](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_49/Slide_49/Slide_01.png?raw=true)

这就是hemispherical lighting的简单概括.

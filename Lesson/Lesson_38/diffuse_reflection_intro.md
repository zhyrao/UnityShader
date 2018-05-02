#### Diffuse Reflection/Light Intro 
在本节中学习Diffuse Reflection/Diffuse Light. 在前面的章节中, 我们理解了什么是基本光照模型;依据基本光照模型的原理, 我们简化的记为"BEADS"：
> E:Emissive A:Ambient D:Diffuse S:Specular  
> 一个表面的颜色就是这四种颜色的组合：Surface Color = Ambient + Emissive + Diffuse + Specular

在本节中, 我们将来学习Diffuse这个光照模型组件的原理:  
*我们来看看人类是怎么看到事物的. 当光线照射到某些物体上面, 然后光线在物体表面反射, 这个时候, 会有一部分的光线会反射到我们的眼睛当中, 在这种情况下面,我们 "看到" 了事物.*

**值得注意的是, 任何一个物体如果要被看到, 那么它必须能够反射光线.**  
Diffuse Reflection是rough surfaces(粗糙表面)的一个属性; 理想中的rough surface是可以将光线平均平等的反射到各个方向. 这样当光线接触到表面的时候, 会被均匀的散射到各个方向. 
>实际上是没有能够均衡的反射所有方向光线的表面.

科学家Lambert定义了一个规律：**Lamber Cosine Law** 在这个定律当中, 光照的反射依据Cosine-falloff在衰减. 
>Cosine-falloff![falloff](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_38/Slide_38/Slide_04.png?raw=true)


向量L表示从表面的点到光源的单位方向向量, 向量N表示表面上的点的单位法向量, 它们之间的夹角称为θ; 表面收到光线的影响强度依据cosθ的值变化而变化(取值在0-1之间).   


**结果就是向量L和N的点积 (N·L)**
> 其中L和N都是单位向量, 那么cosθ会是[-1, 1]之间的值, 我们需要使用max(a, b)函数来限定这个结果到[0, 1]之间  
> max(0, (N · L))

**Diffuse Color = max(0, (N · L)) **  
我们推到出了漫反射光照的公式, 但这个公式仅仅在只有一个光源, 并且这个光源是无线大的, 认为表面是很rough时候才可以使用. 


但是当我们谈论到计算机图形学的时候, 场景中会有不止一个光源, 光源的强度会不同, 物体的材质的diffuse属性也可能不同, 所有diffuse reflection的公式我们将使用:  
![formula](http://latex.codecogs.com/gif.latex?d%20%3D%20%5Csum_%7Bi%3D0%7D%5E%7Bn%7Dintensity__%7B%28light%29%7D%20%5Ctimes%20Diffuse_%7B%28material%20property%29%7D%20%5Ctimes%20altenuation_%7B%28light%29%7D%20%5Ctimes%20%5Bmax%280%2C%20%28N%20%5Ccdot%20L%29%29%5D)
>1. 第一组表示所有光源的光照强度的相加值  
>2. 第二组表示表面材质的rough强度值, 取值范围是[0-1]
>3. 第三组光源的衰减度(例如点光源)
>4. 第四组是[0-1]之间的法线向量和朝光源的单位方向向量的点积值

#### Outline Shader(Part1)
在本节中，我们来了解一下outline shader 的原理。
>outline shader的表现就是在原本的物体外围添加一个额外的物体的形状的描边。它能够使得这个物体更加的具有吸引力。可以通过outline shader控制这个描边的宽度和颜色。

现在我们来分析一下Outline shader，通过例子可以看到这个shader的渲染结果分为两部分
>1. 描边。
2. 物体渲染的本身。

那么这样的情况下面，我们在shader中使用两个pass来分别渲染描边和物体本身。当我们近距离观察outline的时候发现这个边是在物体本身的基础上放大了物体本身并且只给定了单一的颜色而形成的一种现象。那么我们的任务就是：
>1. 放大整个物体，并且将放大后的物体渲染成一种颜色。
2. 正常的使用texture或者其他属性来渲染原始的物体。

现在的问题就是我们怎么在shader中缩放这个物体呢？在MVP章节中我们知道为了达到物体的变换，那么物体将会被移动、旋转或者缩放。
>1. Translation
2. Rotation
3. Scale

---
 我们来分别看看这3个矩阵的数学形式上的表现：
---
首先，我们来看看单位矩阵(Identity Matrix) :

![Indentity Matrix](http://latex.codecogs.com/gif.latex?Identity%20Matrix%20%3D%20%5Cleft%5B%20%5Cbegin%20%7Bmatrix%7D%201%20%26%200%20%26%200%20%26%200%5C%5C%5C%200%20%26%201%20%26%200%20%26%200%5C%5C%5C%200%20%26%200%20%26%201%20%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D)
---
在单位矩阵的基础上来看看translate matrix： 

![Translation Matrix](http://latex.codecogs.com/gif.latex?Translate%20Matrix%20%3D%20%5Cleft%5B%20%5Cbegin%7Bmatrix%7D%201%20%26%200%20%26%200%20%26%20x%5C%5C%5C%200%20%26%201%20%26%200%20%26%20y%5C%5C%5C%200%20%26%200%20%26%201%20%26%20z%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D)
 >在移动矩阵中，x/y/z分量分别表示了移动的位移向量.![Formula](http://latex.codecogs.com/gif.latex?Translation%20matrix%20%5Ctimes%20Object%20Matrix%20%3D%20Translated%20Object%20Matrix)

 ---
 缩放矩阵

![Scale Matrix](http://latex.codecogs.com/gif.latex?%24%24Scale%20Matrix%20%3D%20%5Cleft%5B%20%5Cbegin%7Bmatrix%7D%20x%20%26%200%20%26%200%20%26%200%5C%5C%5C%200%20%26%20y%20%26%200%20%26%200%5C%5C%5C%200%20%26%200%20%26%20z%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D%24%24)
 > x/y/z值就是在各个轴上面的缩放量
 > 
---
旋转矩阵
>旋转矩阵和上面的两个矩阵有所不同，旋转的时候，每次都是绕一个轴旋转。

>1. Rotation X matrix

>>![Rotation X Matrix](http://latex.codecogs.com/gif.latex?%24%24%5Cleft%5B%20%5Cbegin%20%7Bmatrix%7D%201%20%26%200%20%26%200%20%26%200%5C%5C%5C%200%20%26%20%5Ccos%5Ctheta%20%26%20-%5Csin%5Ctheta%20%26%200%5C%5C%5C%200%20%26%5Csin%5Ctheta%20%26%20%5Ccos%5Ctheta%20%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D%24%24)

>2. Rotation Y matrix
>![Rotation Y Matrix](http://latex.codecogs.com/gif.latex?%24%24%5Cleft%5B%20%5Cbegin%20%7Bmatrix%7D%20%5Ccos%5Ctheta%20%26%200%20%26%5Csin%5Ctheta%20%26%200%5C%5C%5C%200%20%26%201%20%26%200%20%26%200%5C%5C%5C%20-%5Csin%5Ctheta%20%26%200%20%26%20%5Ccos%5Ctheta%20%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D%24%24)

>3. Rotation Z matrix

>![Rotation Z Matrix](http://latex.codecogs.com/gif.latex?%24%24%20%5Cleft%5B%20%5Cbegin%20%7Bmatrix%7D%20%5Ccos%5Ctheta%20%26%20-%5Csin%5Ctheta%20%26%200%20%26%200%5C%5C%5C%20%5Csin%5Ctheta%20%26%20%5Ccos%5Ctheta%20%26%200%20%26%200%5C%5C%5C%200%20%26%200%20%26%201%20%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D%20%24%24)

---
现在我们来看看这个outline shader的顺序:
>1. 创建Scale Matrix：

![Outline Scale Matrix](http://latex.codecogs.com/gif.latex?%24%24%5Cleft%5B%20%5Cbegin%7Bmatrix%7D%201&plus;outline_width%20%26%200%20%26%200%20%26%200%5C%5C%5C%200%20%26%201&plus;outline_width%20%26%200%20%26%200%5C%5C%5C%200%20%26%200%20%26%201&plus;outline_width%26%200%20%5C%5C%5C%200%20%26%200%20%26%200%20%26%201%20%5Cend%7Bmatrix%7D%20%5Cright%5D%24%24)
>2. 将object space vertex和这个缩放矩阵相乘
>3. 将得到的缩放的结果与MVP相乘
>4. fragment shader中将每个像素都返回Outline Color.
>5. 在pass2中，正常渲染原始的模型。

下节中我们将看看具体如何实现。

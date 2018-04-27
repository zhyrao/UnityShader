<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
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

我们来分别看看这3个矩阵的数学形式上的表现：
---
首先，我们来看看单位矩阵(Identity Matrix)
$$Identity Matrix = 
\left[
\begin {matrix}
1 & 0 & 0 & 0\\\
0 & 1 & 0 & 0\\\
0 & 0 & 1 & 0 \\\
0 & 0 & 0 & 1
 \end{matrix} \right]
 $$
---
在单位矩阵的基础上来看看translate matrix：
$$Translate Matrix = 
\left[
\begin{matrix}
1 & 0 & 0 & x\\\
0 & 1 & 0 & y\\\
0 & 0 & 1 & z \\\
0 & 0 & 0 & 1
\end{matrix}
 \right]$$
 >在移动矩阵中，x/y/z分量分别表示了移动的位移向量。$$Translation matrix \times Object Matrix = Translated Object Matrix$$

 ---
 缩放矩阵
$$Scale Matrix = 
\left[
\begin{matrix}
x & 0 & 0 & 0\\\
0 & y & 0 & 0\\\
0 & 0 & z& 0 \\\
0 & 0 & 0 & 1
\end{matrix}
 \right]$$
 > x/y/z值就是在各个轴上面的缩放量
 > 
---
旋转矩阵
>旋转矩阵和上面的两个矩阵有所不同，旋转的时候，每次都是绕一个轴旋转。

1. Rotation X matrix
>$$\left[
\begin {matrix}
1 & 0 & 0 & 0\\\
0 & \cos\theta & -\sin\theta & 0\\\
0 &\sin\theta & \cos\theta  & 0 \\\
0 & 0 & 0 & 1
 \end{matrix} \right]$$
2. Rotation Y matrix
$$\left[
\begin {matrix}
 \cos\theta & 0 &\sin\theta & 0\\\
0 & 1 & 0 & 0\\\
-\sin\theta & 0 & \cos\theta & 0 \\\
0 & 0 & 0 & 1
 \end{matrix} \right]$$
3. Rotation Z matrix
$$ 
\left[
\begin {matrix}
 \cos\theta  & -\sin\theta & 0 & 0\\\
\sin\theta &  \cos\theta  & 0 & 0\\\
0 & 0 & 1 & 0 \\\
0 & 0 & 0 & 1
 \end{matrix} \right]
 $$

---
现在我们来看看这个outline shader的顺序:
>1. 创建Scale Matrix：
$$\left[
\begin{matrix}
1+outline_width & 0 & 0 & 0\\\
0 & 1+outline_width & 0 & 0\\\
0 & 0 & 1+outline_width& 0 \\\
0 & 0 & 0 & 1
\end{matrix}
 \right]$$
 2. 将object space vertex和这个缩放矩阵相乘
 3. 将得到的缩放的结果与MVP相乘
 4. fragment shader中将每个像素都返回Outline Color.
 5. 在pass2中，正常渲染原始的模型。

下节中我们将看看具体如何实现。

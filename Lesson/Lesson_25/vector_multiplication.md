#### Vector multiplication
在前节中，我们理解了什么是向量以及向量的加减法。在本节中我们将理解向量的相关乘法。
>向量可以与常数相乘，也可以与向量相乘。

**1. Scalar Multiplication**
例如：$\vec{a} \times 2$
> $\vec {a} =
> \left[
\begin{matrix}
2 \\\
3 \end{matrix}
\right]
\times 2 = 
 \left[
\begin{matrix}
2 \times2\\\
3 \times 2\end{matrix}
\right]=
 \left[
\begin{matrix}
4 \\\
6 \end{matrix}
\right]$
向量中的每个分量分别乘以常数而得到一个新的缩放过的向量

**Vector - Vector multiplication**
向量与向量之间的乘法分为两种情况：
>1. Dot (点乘)，结果是一个常量
2. Cross (叉乘)，结果是一个向量
---
##### Dot Product
$\vec{a} \cdot  \vec{b} = n$
>我们有$\vec{a} = 
> \left[
\begin{matrix}
a_x \\\
a_y \end{matrix}
\right]$和$\vec{b} = 
> \left[
\begin{matrix}
b_x \\\
b_y \end{matrix}
\right]$那么它们之间的点乘为$\vec{a} \cdot \vec{b} = (a_x \times b_x + a_y \times  b_y)$;
同理在3D空间中有$\vec{a} = 
> \left[
\begin{matrix}
a_x \\\
a_y \\\
a_z \end{matrix}
\right]$和$\vec{b} = 
> \left[
\begin{matrix}
b_x \\\
b_y\\\
b_z \end{matrix}
\right]$那么它们之间的点乘为$\vec{a} \cdot \vec{b} = (a_x \times b_x + a_y \times  b_y + a_z \times b_z)$;

另外，点乘还有另外的一种表现方式：
$$\vec{a}\cdot \vec{b} = \left \\| a \right \|\times \left \| b \right \|\times \cos \theta  $$
这个公式还有一个比较简单的方式就是当$\vec{a} \vec{b}$是单位向量的时候，那么它们的点乘就是为$\cos \theta$
>单位向量:Normalized Vector，它的特征就是这个向量的长度为1.任何一个向量都可以由该向量的单位向量和一个缩放系数组成。
##### Cross Product
$\vec {a} \times \vec{b} = \vec{c}$
>$\vec{a} = 
> \left[
\begin{matrix}
a_x \\\
a_y \\\
a_z \end{matrix}
\right]$和$\vec{b} = 
> \left[
\begin{matrix}
b_x \\\
b_y\\\
b_z \end{matrix}
\right]$，那么它们的叉乘就是 $$\left[
\begin{matrix}
a_y \times b_z - a_z \times b_y \\\
a_z \times b_x - a_x \times b_z\\\
a_x \times b_y - a_y \times b_x \end{matrix}
\right]$$
另外的一种方式就是$$\vec{a} \times \vec{b} = \left \\| a \right \|\times \left \| b \right \|\times \sin \theta \times \vec{n} $$其中$\vec{n}$是正交于$\vec{a} \vec{b}$的单位向量。也是$\vec{a} \vec{b}$叉乘后得到的新的向量的方向。
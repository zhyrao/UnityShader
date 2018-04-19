##### 什么是Shader（着色器）？
当我们使用电脑做事情的时候，我们实际上是给电脑发出了很多的指令。这些指令集组成了程序，其中有一类的程序是让电脑在屏幕上绘制或者投影一些图形、图片的东西称为**[Shader](https://en.wikipedia.org/wiki/Shader)**。
>In computer graphics, a shader is a type of computer program that was originally used for shading (the production of appropriate levels of light, darkness, and color within an image) but which now performs a variety of specialized functions in various fields of computer graphics special effects or does video post-processing unrelated to shading, or even functions unrelated to graphics at all.

Shader是在**[GPU](https://en.wikipedia.org/wiki/Graphics_processing_unit)(graphic processing unit)**上运行的一系列指令。

GPU是并行处理的架构，专门为了处理大量图形计算而设计的：
    * Computer Graphic Operation
    * Image manipulation
 
 在现代CPU中一般有多个处理核心，假设为4个，但是CPU的架构是连续的，这意味着CPU只能每次处理一个指令。当这个指令完成了，CPU再接着处理下一个指令。而GPU的是并行的架构，那么它就可以一次性处理很多个指令任务。这样对比CPU来说在多任务处理上要快很多倍。

******

现在，根据Shader不同的功能性将它分为以下几类：
>   1. Vertex Shader
>   2. Pixel/Fragment Shader
 >  3. Geometry Shader
 >  4. Compute Shader 
 >  5. Tessellation/Hull Shader
 >  *在这里，我们集中于顶点和片元着色器*
 >  
 

###### Vertex Shader 顶点着色器
为了绘制模型，首先我们需要将模型的顶点在屏幕上绘制出来，这个时候就要使用到Vertex Shader。模型都是由顶点构成的，在计算机图形学中，基本的图形单元就是三角形，三角形有3个顶点，这个三角形在通过一系列的矩阵变换后才能被绘制到屏幕上，这个过程被称为**Transform**，绘制这些顶点的函数就是Vertex Shader。


###### Pixel/Fragment Shader 像素/片元着色器
当顶点着色器绘制了顶点以后，三角形内部依然是空的，那么我们就需要使用Pixel/Fragment Shader来填充这个三角形。这个过程主要是对三角形内的每个像素最后的颜色进行计算。


###### Tessellation Shader 细分着色器
细分着色器是在OpenGL 4.0和Directx11以后加入的新功能。它主要的作用就是将一个简单的模型进行细分，使得这个模型变成一个更加精细的模型。苹果公司首先在它的渲染API Metal中提出了这个着色器，并且集成在API中，但是这个着色器是不可编程的。
>*不可编程的着色器都统称为固定功能着色器，一般会提供接口更改参数。*


###### Geometry Shader 几何着色器
Geometry Shader是用来操作渲染通道中的几何体的。Geometry Shader接受基本片元作为输入。在渲染管道中，Geometry Shader在顶点着色器和像素着色器之间进行的。
> Vertex Shader ---> Geometry Shader ---> Pixel/Fragment Shader
> 

###### Compute Shader
通常被用来General Purpose Shader



### Rendering Pipeling (Part1)
本节中，我们来了解一下整个渲染管线的流程。
>简单来说，渲染管线的流程就是一个mesh的生命流程。

在大多数游戏中，想要绘制出物体，大致分为两步：
1. 加载模型
2. 渲染模型

#### 加载模型
已经准备好的模型都是存储在硬盘上的，大部分的类型为.obj/.fbx等文件。Unity或者其他引擎或者软件将模型加载到内存(RAM)中，这时候模型的信息就被内存存下来了。 

接下来就是CPU和GPU之间的交互。CPU和GPU并不直接通信，而是靠一个叫Command Buffer(Ring Buffer)的队列来交互的。在GPU中也有内存的存在，称为VRAM。当CPU要求GPU去绘制物体的时候，这个要求会被分成两个步骤：
>1. 设定Render State
2. 绘制Draw Mesh
---
**Render State**
渲染状态是指一个状态或者环境下面，mesh是怎么绘制。一般包括：
>1. vertex Function/vertex shader
2. pixel shader
3. texture
4. light settings


**在设置render state这个阶段以后，模型相关的信息和纹理贴图等都会被传入的GPU的VRM中，因为GPU访问VRAM的速度远远大于访问RAW的速度，所以我们将模型相关的信息都存储到VRAM中。**

---
**Draw Mesh**
一旦render state 设置好了，那么接下来就是绘制模型。

**注意：如果我们设置好了一个render state，那么我们就可以绘制使用这个render state的所有的mesh**
>例如：开始的时候我们设置好了一个render state，一个cube使用这个render state来绘制。然后接下来又有一个sphere也使用这个render state(使用同样的vertex shader/pixel shader, texture, lightting etc)来绘制，那么我们就不需要重新设定render state，而是使用这个已经设定好的render state来绘制sphere.但是如果有其他的模型使用不同的render state来绘制，那么就需要重新设定render state，然后再绘制。

设定render state 相比于Draw Call是一个很耗时耗力的任务，这个时候就有了优化：Batching.例如在unity中，unity把使用相同的shader、相同的纹理、相同的光照的所有的物体都打包在一下统一设置render state，然后在一个一个去绘制。每个绘制物体的过程被称为**DrawCall(DC)**。
>在Unity中创建一个cube，然后在复制相同的两个cube。从state中可以看出batches只有1个，而saved batches有2个，这个说明了3个cube使用的是一个render state，所有只设定了一个render state。而Draw call = batches + saved batches = 3个。一共绘制3个cube。就有3个DC。
---
**Vertex Shader**
接下来就是vertex shader了。vertex shader从mesh中读取mesh的属性：vertex position, normal, tangents 等。从前面的章节中我们可以知道可以从本地坐标系转换到世界坐标系，然后再转换到视图坐标系，然后在转换到投影坐标系。一般来说这个时候就可以将转换后的信息发送给光栅化了，但是这个时候还有要给可选的操作：Culling
---
**Culling**
通常一个面是由3个顶点构成的，如果以顺时针来获得这3个点组成的面，称为front face；如果是逆时针获得的，称为back face。我们可以选择绘制front face 或者back face或者全部都绘制。在unity中，默认的是绘制front face，这是因为相对于相机来说，我们只能看到front face而看不到back face，那么我们就可以选择只绘制front face来提升性能。
>1. front face
2. back face 
3. ignore
---
**光栅化**
经过剔除后，接下来就是光栅化。光栅化的作用就是裁剪，它决定了哪些像素会在屏幕上显示出来，哪些像素超出了屏幕范围而不会被绘制。
>1. pixel to be draw
2. interpolation
---
**Fragment Shader**
通过了clip的像素接下来进入fragment shader。fragment shader将会返回：
>1.color of pixel
2. alpha of pixel
3. z-depth of pixel
---
**ZTest**
当我们得到了像素的z值以后，我们就可以比较当前像素的z值和shader的z值来决定是否通过或者抛弃。*当通过了ztest的时候，这z值将会被写入到Zbuffer中。*
>这时候会有两个buffer：
1.color buffer/frame buffer
2. z buffer

color buffer中存储了当前像素的颜色，zbuffer存储了当前像素中的z距离。
---
**Blending**
当ztest通过以后，我们将会进行blending操作(详细查看blending章节)
---
**Stencil Test**
模板测试和ztest很相似，只有模板测试中能够通过的才能够在屏幕中绘制出来。
---
**Color Masking** 
color mask是最后的一个选择性的操作。我们可以使用这个来分离RGBA通道。
---
**Final Color**
---
**Color Buffer**
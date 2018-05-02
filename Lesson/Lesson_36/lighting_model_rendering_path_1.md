### Basic Lighting Model and Rendering Path(part1)
从现在开始，我们将学习lit shaders. lit shaders将会给我们打开一个新的世界。我们将从一个场景中物体和灯光是如何交互的开始学习，在本章中学习基础的光照模型和渲染路径。不同的渲染路径之间有什么不同？

现在我们开始看看最基础的主题： 

#### light-object intersection(灯光和物体间的交互)
假设我们有一个场景，场景中有一个物体和一个灯光。灯光和物体间的交互基于两个不同的事情：
>1. 灯光的属性
>2. 物体的材质的属性

light-object intersection 被称为光照模型；在过去的许多年中，很多种类的光照模型已经被发现和使用了。其中一个被称为:

#### Basic Lighting Model(基本光照模型)

在这个模型中，物体表面的颜色由四种不同的颜色组合而成：

        Surface Color = Emmisive + Ambient + Diffuse + Specular 
>简单记为:BEADS,其中E(Emmisive)/A(Ambient)/D(Diffuse)/S(Specular),在后面的章节中，我们会理解每个颜色的含义以及整个4种颜色是如何计算的。

光照的计算是在shader中完成的，那么在vertex/fragment shader中就有两种不同的位置可以计算光照：
1. Vertex Lighting:
        
        光照在顶点shader中完成，这个颜色是基于每个顶点而计算的。
2. Fragment Lighting:
        
        光照在fragment shader中完成，颜色是基于每个像素点pixel完成的。
        
#### Rendering Path  
path/workflow/technique去渲染一个光照的场景被称为*Rendering path*. 在Unity中，支持4种不同的rendering path:

1. Forward Rendering
2. Legacy deferred/Deferred Lighting
3. Deferred Shading    
4. Legacy Vertex Lit

##### Forward Rendering
Forward Rendering 技术提供了两种不同的pass供我们在shader中使用：
>1. Base Pass
>2. Additional Pass

Forward Rendering(前向渲染)的想法是对于场景中的每一个物体都会计算和每一个灯光的交互颜色，然后每一个draw calls会依据颜色不同的贡献值相加来渲染整个场景或者图片。

![forward lighting](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_36/Slide_36/Slide_04.png?raw=true)

>这就是forward lighting的原理，对于每一个物体都会计算它跟每一个灯光的关系。但是在现代的引擎当中做了有关的优化：例如在unity中，仅仅计算被光照影响了的物体。

*我们可以看到场景中的每一个单独的光源都会增加很多的draw calls，这样一来在移动平台上的场景中，会尽可能的保持最小数量光源。在移动平台中，光照信息会被烘培到贴图纹理中，或者另外一个广泛使用的方法就是在场景中只有一个灯源，这样来保持最小的draw calls。*

**现在我们来看看Forward Rendering Passes:**

**1. Base Pass**
```
	// 原来我们已经接触到了PASS,这里也是一样的；
	// 在Tag内容下面指定这个pass的渲染路径
	Tag {"Quene" = "Transparent" ...}
	pass
	{
		Tag{"LightMode" = "ForwardBase"}
		
	}
	// 在前向渲染base pass中可以渲染一个逐像素的平行光；
	// 如果场景中有多个directional light，那么亮度最强的那个会
	// 被采用作为逐像素的光源；如果没有平行光，那么将不能完成
	// 光照计算。
	// + 
	// 再加上球谐函数(spherical harmonics light)的光源例如：
	//light probes, global illumination, sky ambient等。
```

**2. Additional Pass**
```
// 在Tag内容下面指定这个pass的渲染路径
	Tag {"Quene" = "Transparent" ...}
	pass
	{
		Tag{"LightMode" = "ForwardAdd"}	
	}
	// 附加额外pass可以渲染一个影响物体的逐像素级别的光源
```

*举例来说，如果场景中有两个光源，一个是平行光，一个是点光源或者spot光源；我们想在这两个光源的基础上计算光照，在这种情况下，shader中必须要有两个pass，一个pass将会是forwardbase pass,它将会计算这个direction light的光照信息；另外一个pass就是forwardAdd pass，这个pass来计算额外的光源对物体的影响；如果场景中还有第三个光源，那么就必须写第三个pass为addition pass.*

##### Legacy Deferred/Deferred Lighting

Deferred Lighting含有三个阶段：

**1. 将场景中的可见的像素的一些信息写入到Geometry Buffer(G-BUFFER)中:**  
- Depth
- Specular
- Normal

**2. 对于场景中的每一个光源,找到受到它影响的像素,然后从G-buffer中读取这个像素的信息,并且计算光照值, 将值存入到 light accumulation buffer中:**
1. 对每一个光源找到受到它影响的像素;
2. 对于受影响的像素,从g-buffer中读取到它们的信息;
3. 结合像素信息和光照，计算光照值;
4. 将光照值存入Light Accumulation Buffer中;

**3. 再次渲染场景，对于场景中可见的像素，将mesh color 和 light accumulation color后，再加上ambient 和 emmisive color**
>Accumulation light value + Mesh color + Ambient + Emmisive

![Deferred light steps](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_36/Slide_36/Slide_07.png)

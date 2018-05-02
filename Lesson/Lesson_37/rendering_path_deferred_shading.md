#### Rendering Path(part2:Deferred Shading)
在本节中，我们将来看看Deferred shading的工作原理, 它有两个阶段:

**1. 将整个场景的相关信息渲染写入到G-buffer中：**
- depth
- diffuse
- normal(world space)
- specular color
- smoothness
- emission

**2. 同样的, 对于每一个光源, 找到受到它影响的像素, 从g-buffer中读取这个像素的信息, 计算光照值, 存入accumulation light buffer:**
1. 对每一个光源找到受到它影响的像素;
2. 对于受影响的像素,从g-buffer中读取到它们的信息;
3. 结合像素信息和光照，计算光照值;
4. 将光照值存入Light Accumulation Buffer中;
5. 从g-buffer中获取信息来得到mesh color,然后加上accumulation light值从而得到最终的颜色值;

*Deferred Light 和 Deferred Shading之间最大的区别就是在Deferred Shading中, 我们不需要再一次渲染整个场景, 因为在第一渲染中, 已经把所有需要的相关信息存入到了Geometry Buffer中了.(使用Deferred Lighting的原因可能是当时的硬件不支持写入那么多的信息到G-buffer中)*

**使用Deferred Shading 是有要求的：**
>1. graphics card with multiple render targets
>2. shader model 3 or later
>3. support for Depth-render texture

#### Blending 
在本节中，我们将学些什么是**Blending**。当一个透明物体出现在一个不透明物体或者透明物体之前的时候，将会发生什么？
> Blending是一个融合两个像素颜色值的过程。 Blending是一个可以选择的操作。只有当存在透明或者半透明的时候才会使用blending。
> 

在前一节中我们了解到sorting的作用。当一个像素通过(如果不通过则被抛弃)Z-Test的时候，这个像素的颜色值将会被保存在一个缓存中，Color-Buffer，这个缓存里面包含了这个像素的颜色值和透明值。
>我们需要将使用shader的这个物体的颜色值和已经在颜色缓存中存在的颜色值融合起来。

Blending 就是一个函数:
```
Blending(srcFactor, dstFactor)
{
    color value - pixel shader;
    color value - color buffer;

    return mergedColor;
}
```
在Unity Shader中，我们使用关键字**Blend** srcFactor (BlendOp) dstFactor:
>srcFactor是值使用当前shader产生的颜色值，dstFactor是指已经在颜色缓存中存在的像素的颜色值及透明值。其中[BlendOp](https://docs.unity3d.com/Manual/SL-Blend.html)是一个可选的操作，在Unity中默认的操作类型是Add。
```
Merged Pixel = [srcColor * srcFactor] + [dstColor * dstFactor]
// 其中srcColor是shader计算出来的颜色值，srcFactor是一个范围值，取值范围是[0-1]
// dstColor是在颜色缓存中的值，dstFactor是一个范围值，取值范围是[0-1]
```
>
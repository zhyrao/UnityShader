### Rendering Pipeling (Part2)
在本节中，我们将以一个场景作为例子来看看z-buffer和color-buffer是怎么变化的？ 同时也来看看shader中几个非常重要的关键字：
>1. ZWrite
2. Cull
3. Z-Test

为了方便理解，我们依然是使用上节中的渲染管线流程。
*注意：在现代的GPU中，跟上节中的渲染管线有所不同的是，现代的GPU支持在执行pixel shader之前就进行Z-test，同时unity也是这么操作的。*
---
![场景图片](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_22/Slide_22/Renderingorder.png?raw=true)
---
从场景中可以看出该场景的层级结构是：
```
Scene Hierarchy
|--- Back Plane
|--- Red Plane
|--- Green Plane
|--- Blue Sphere
|--- Pink Plane
```
右上角表示了屏幕中的所有像素(假设)。从上节中可以了解到我们存在着两个buffer:
1.Color Buffer
2.Z-Buffer
>他们的大小与屏幕中的像素大小相关

Z-Buffer的默认值为1，代表了摄像机属性中Far plane所在的位置深度信息。而摄像机Near Plane的Z值是0.

然后根据物体在场景中距离摄像机的距离，从远到近的开始绘制。从例子中可以看出，首先将绘制Back Plane， 然后再绘制半透明的Red Plane，因为Red Plane是半透明的那么就需要和已经在像素中的颜色进行混合。然后再持续绘制绿色、蓝色和粉色的物体。


---
##### [ZWrite](https://docs.unity3d.com/Manual/SL-CullAndDepth.html)
Zwrite 关键字控制了shader中是否向Z-buffer中写入数据。
>1.On: 允许写入(如果Z-test中通过，那么就向Z-buffer中写入深度值)
2.Off: 不允许写入

*对于所有的Opaque物体来说，都是ZWirte On，而对于透明或者半透明来说大部分都是ZWrite Off*
---
##### [Cull](https://docs.unity3d.com/Manual/SL-CullAndDepth.html)
>1.Front
2.Back
3.Off

---
##### [Z-Test](https://docs.unity3d.com/Manual/SL-CullAndDepth.html)
```
Less | Greater | LEqual | GEqual | Equal | NotEqual | Always
```
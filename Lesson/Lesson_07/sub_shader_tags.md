### SubShader Tags
在本章中，我们将要理解什么是Shader Tags, 什么是Render Quene,以及什么事unity Projector.

#### Sub-Shader Tags
>这些标签决定这个subshader的渲染属性(Rendering properties)

```
Subshader
{
    Tags { " " = " " " " = ""}

    Pass
    {
        Tags{" " = " " " " = " "}
    }
}
```
>如果Tags是在Subshader内的那么称为Subshader-Tags，它对于整个subshader内的所有pass都有效果。如果Tags是在Pass内的那么称为Pass-Tags，它仅仅对所属的Pass生效。Tags可以有很多个Tag但是他们之间不用 *,*隔开，而是用空格隔开。

---
现在我们来了解3个比较重要的Tag：
**1.Quene**
>在上节中已经了解到Quene锁代表的意义了。 
*"Quene" = "Transparent" 或者 "Quene" = "Transparent + 1"*

**2.IgnoreProjector**
>Unity提供了一种类似于现实中投影仪的方式将材质投影到物体上面。**Projector**,它将视椎体范围内的任何物体都投影上Projector自身带的材质。如果"IgnoreProjector" = "True",那么使用这个shader的物体在Projector的投影范围内是不会受到投影的作用的。相反，"IgnoreProjector"="False"，那么就会收到影响。

**3.RenderType**
>使用RenderType可以让Unity知道这个Subshader或者pass是被指定了特定的render order的。一般来说RenderType和Quene的内容是一样的。为什么需要这个呢？Unity中提供了一个C#的方法：

>**Camera.main.SetReplacement("shader_name", "rendertype")** // OPAUQE

>这个时候，所有的物体上的材质中如有标明了RenderType与这个函数第二个参数相同的材质，将会使用shader_name的这个shader。其他类型的RenderType不受影响。
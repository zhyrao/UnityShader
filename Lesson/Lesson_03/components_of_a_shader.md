#### Components of a Shader
在了解Unity shader组件以前，我们需要知道在Unity Shader中，是由两种语言组成的：
>1. ShaderLab
>2. CG language

    --------------------
    |    ShaderLab      |                       1.ShaderLab
    |                   |                           1.Material Inspector
    |                   |                           2.Blending Option
    |                   |                           3.Render Passes
    |      CG           |                           4.Hardware fallback
    |                   |                       2. CG Language (nvidia)
    |                   |                           - control over graphic hardware
    |                   |    
    |     ShaderLab     |                
    ---------------------

CG code 包含有**Surface Shader** 和 **Vertex/Fragment Shader**，其中 Surface Shader是Unity自动生成的，对这个shader来说，我们有较少的控制权。而Vertex/Fragment Shader是自己编写的Shader，对它有绝对的控制权。

##### Components 组件
 **1.Properties**
```
 Properties
 {
    _Color("Main Color", Color) = (1,1,1,1)
    _MainTex("Main Texture", 2D) = white{}
    _CutoutThres("Cutout Threshold", Range(0,1)) = 0.5
  }
```

**2.SubShader**
> subshader是为了shader支持不同硬件来编写的，unity会使用与硬件兼容的第一个subshader。如果所有的subshader都与硬件兼容则最后使用Fallback shader绘制。Subshader会与硬件兼容例如：metal, gles, gles3,xbox360等等。  
*[pragma only renderer metal]*

**3.Pass**
> Render Passes.

**4.Vertex-Shader Input**
> vertex的相关信息：position, normal, color等。

**5.Vertex Shader**
> 顶点着色器

**6.Vertex-Shader Output**
> 经过顶点shader变换后输出的顶点信息内容

**7.Pixel/Fragment Shader**
> 像素/片元着色器

![完整图片](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_03/Slide_03/slide_04.png?raw=true)

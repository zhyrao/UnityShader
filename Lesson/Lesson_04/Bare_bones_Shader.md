#### **Bare-bones Shader**
本节主要是创建一个最基本的Shader，然后看看上节中的每个组件在Shader中的作用及用法。

```
Shader"ShaderDev/BareBone" 
    {
        // 属性
        Properties
        {
            _Color("Main Color", Color) = (1, 1, 1, 1)
        }
    // SubShader 
    SubShader
    {   
        // 通道
        Pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag  

            uniform half4 _Color; 

            struct vertexInput
            {
                float4 vertex : POSITION;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
            };


            vertexOutput vert(vertexInput i)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(i.vertex);

                return o;
            }

            half4 frag(vertexOutput o): COLOR
            {
                return _Color;
            }

            ENDCG
        }
    } 
}
```
现在我们来分段解析整个Shader的构成：
---
```
Shader"ShaderDev/BareBone" 
{

}
```
>关键字 **Shader**后面的名称是指在为材质Material选择指定Shader的时候的路径名称。如例子中的路径将会是在ShaderDev下面的BareBone。Shader本身的文件名不影响这个路径。

---
```
Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
    }
```
>接下来的是**Properites**关键字。这个位置里面的内容表示了从Unity Inspector中输入的内容。其中的构成为： 

        变量名("在Unity材质中显示名", 变量类型) = 默认值
>1. 变量名表示为在shader内部运行时候使用的名称，它存储了这个变量的值。
>2. 在Unity中的显示名字是指在unity中材质球面板中显示的名字。
>3. 变量类型表示了这个输入的类型，可以是2D/3D/RANGE/FLOAT等。 
>4. 默认值是指如果这个变量在材质中没有赋值的时候默认使用的值。

---
```
Subshader 
{

}
```
>Subshader 是指Unity对于多平台的兼容处理，Unity总是会选择第一个能够与当前运行平台兼容的这个Subshader来渲染。如果全部没有合适的Subshader那么就到最后使用能够在任何平台上都可以运行的FallBack Shader.

---
```
Pass
{
    CGPROGRAM

    ENDCG
}
```
>Pass是renderer passes，在Pass里面将会使用其他的shader components。 到目前位置，我们所说的所有的都是ShaderLab语言，然而在Pass里面，我们需要编写的CG Language。

---
```
uniform half4 _Color;
```
>这个将Properties中的变量和后续使用的变量链接起来。


---
```
struct vertexInput
{
    float4 position:POSITION;
    float3 normal:NORMAL;
    ...
};
```
>这个是顶点输入结构体。其中的POSITION/NORMAL是指定所属变量的语义(semantic)，表示了这个变量变量的含义。

---
```
struct vertexOutput
{
    float4 pos:SV_POSITION;
}
```
>经过顶点变换以后输出的信息结构体。同vertexInput类似。

---
```
#pragma vertex vert
#pragma fragment frag
```
>\#pragma是提示编译器注意后面的内容。 vertex/fragment表示了顶点和片元着色器名称。vert/frag是代表了vertex/fragment着色器函数的名称。

---
```
vertexOutput vert(vertexInput i)
{
    vertexOutput o;
    ...;
    return o;
}
```
>顶点着色器函数，这个函数接受一个顶点输入结构体为参数，返回一个顶点输出结构体。 其中一般进行的内容就是将模型的顶点从模型的本地坐标系转换到屏幕坐标系中去。


---
```
half4 frag(vertexOutput i):SV_TARGET(COLOR)
{
    return half4;
}
```
>片元着色器，它接受一个已经经过顶点变换了的结构体作为输入参数，返回了一个组成最终颜色的信息内容，其中SV_TARGET/COLOR表示了这个返回内容代表的意义。
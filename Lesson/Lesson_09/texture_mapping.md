#### Texture Mapping
在本节中，我们将理解**Texture Mapping(纹理映射)**是怎么样将一张纹理映射/显示到mesh。
>在Maya或者3Dmax等三维模型创造软件中，当创建一个模型的时候，会同时的创建一套相应的UV信息。每一个网格上的顶点都会在UV集信息中给出一个位置信息，被称为这个顶点的UV/Texture坐标。这样的UV信息集合被称为UV-space:
>>1. UV space是一个2D的空间
>>2. UV space中的所有取值范围都是[0-1]之间

>这样的UV space也同样被称为Texture Space，它们基本上是相同的。  

现在在顶点输入结构体中就会多一个顶点的信息：UV TextureCoordinate，接下来将这个信息打包传入给顶点着色器，经过顶点着色器以后，UV信息将会被传递给Rasterizer进行插值计算后再传入给fragment shader来做最后的输出。在Unity Fragment Shader中，我们将使用纹理采样函数**tex2d(texture, uv)**来进行纹理的采样。

---
#### Unity 中的Texture Shader
在Unity材质的inspector中可以看出，当我们使用Texture的时候，对应的Texture下面将会有4个数据：
>Tiling (x, y) 控制缩放
OffSet (x, y) 控制位移

使用方式是在shader中定义与该Texture对应变量名再加上_ST后缀,
>例如，我们使用了一个_MainTex的纹理，那么我们就可以定义_MainTex_ST来定义这个变量。
```
o.texcoord.xy = (i.texcoord * _Main_ST.xy) + _Main_ST.zw;
```
>**需要注意的是，如果要使_ST起作用那么，这个纹理在Unity中的属性的wrapMode必须是Repeat的，否则不会作用。**
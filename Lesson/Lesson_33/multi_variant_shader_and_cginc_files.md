#### Multi Variant Shader and Cginc files
在接下来的几个章节中，我们将了解material property的材质UI接口，也被称为Custom UI Drawers。我们将学习如何在unity shader中增加一个接口，使得我们能够在材质面板上选择关/闭来控制shader中的代码块。也将学习怎么来编写扩展名为.cginc的CG include文件。
>CG include的文件类似于库的概念，这个文件能够在不同的shader中被共用。


##### GUI Option/Custom UI drawers 

为了更好的理解GUI上的选项，我们将使用我们学习过的法线shader作为例子，其中我们可以使用两种选择来绘制:  
>1. 使用法线贴图纹理  
>2. 使用fragment shader提供的插值。  

当使用法线贴图的选项ON的时候，我们使用从法线贴图中获取到的信息；当这个选项是OFF的时候，我们使用从fragment shader中插值获取到的法线信息。

**我们来看看怎么来创建自定义的UI面板内容 **

***
1. 首先定义你想要使用的GUI的选项类型：
   1. 使用关键字KeywordEnum:  它创建了一个可以下拉的菜单，值类型为float。
   ```
        [KeywordEnum(_,_,_,_)]_VariableName("Label", dataType) = defaultValue
        //[KeywordEnum(on,off)]_UseNormalMap("Use Normal Map?", float) = 0
   ``` 
   2. Enum: 这个关键字也创建了一个float类型的下拉菜单。在这里可以定义ON/OFF，甚至可以定义数字。
   ```
        Enum(ON,1,OFF)
   ```
   3. Toggle: 这个关键字会在面板中创建一个toggle按钮，它的值为0或者1.

---
2. 选择使用的#Pragma 值： Multi_Compile 或者Shader_feature 
```
    // 当我们首先定义了[KeywordEnum(on,off)]_UseNormalMap("Use Normal Map?", float) = 0后
    // 就使用关键字multi_compile 或者 shader_feature来定义我们上面的选项内容：
    // 使用方法就是在定义的选项变量名后面直接加上_ON或者_OFF(变量名需要大写)
    #pragma multi_comile _UESNORMALMAP_ON _UESNORMALMAP_OFF
    #pragma shader_feature _UESNORMALMAP_ON _UESNORMALMAP_OFF
    // 如果定义了多个选项内容，就需要在这里面全部声明出来。
```
 
 ---
 3. 使用if\else\endif条件
 ```
    #if _USENORMALMAP_ON
        // do something
    #else
        // do something
    #endif 
 ```
**Steps:**
>1. 首先定义选项变量名以及选项
>2. 使用#pragma 以及关键字申明所有的选项名以及内容
>3. 使用#if #else #endif来划分不同的代码块

**multi_compile & shader_feature的区别：**

当我们编写了一个可以有控制选项的shader，这样的shader称为Multi Variant Shader(或者the shader with multiple program variants)。multi variant shader会在编译的时候根据不同定义的选项会编译多次。
```
    // 例如：我们定义了2种不同的选项和2种不同的选项内容
    1. UseNormalMap(ON,OFF)
    2. Diffuse Light(ON,OFF)
    // 那么我们将会得到2x2=4种不同的结果，这样在编译shader的时候，会编译4份不同的shader。
```
而multi_compile和shader_feature之间唯一的不同的是，shader_feature会仅仅编译那些已经在场景或者游戏中选中的选项。multi_compile会编译所有的不同的shader的变种，不管是不是已经被使用了。所以为了提升性能，我们一般会使用shader_feature这个关键字来使用shader变种。

##### CG-include files(.cginc)

cg文件是类似于其他编程语言中使用的额外的库或者命名空间内容。
>例如在python中使用的import
>或者在c#中使用using

在shader中我们使用#include"fileName.cginc"来引入这个文件，这时候cg文件中所有的函数或者其他内容就可以直接拿来使用了。

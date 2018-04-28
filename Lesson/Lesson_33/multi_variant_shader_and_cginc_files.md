#### Multi Variant Shader and Cginc files
在接下来的几个章节中，我们将了解material property的材质UI接口，也被称为Custom UI Drawers。我们将学习如何在unity shader中增加一个接口，使得我们能够在材质面板上选择关/闭来控制shader中的代码块。也将学习怎么来编写扩展名为cginc的CG include文件。
>CG include的文件类似于库的概念，这个文件能够在不同的shader中被共用。

**GUI Option/Custom UI drawers**
>我们将使用我们学习过的法线shader作为例子，其中我们可以使用两种选择来绘制： 
1.使用法线贴图纹理
2. 使用fragment shader提供的插值。

我们来看看怎么来创建自定义的UI面板内容 
***
1. 首先定义你想要使用的GUI的选项类型：
>1.使用关键字KeywordEnum:  它创建了一个可以下拉的菜单，值类型为float。
```
        [KeywordEnum(_,_,_,_)]_VariableName("Label", dataType) = defaultValue
        //[KeywordEnum(on,off)]
        //_UseNormalMap("Use Normal Map?", float) = 0
``` 
>2. Enum: 这个关键字也创建了一个float类型的下拉菜单。在这里可以定义ON/OFF，甚至可以定义数字。
```
        Enum(ON,1,OFF)
```
>3.Toggle: 这个关键字会在面板中创建一个toggle按钮，它的值为0或者1.

---
2. 选择使用的#Pragma 值： Multi_Compile 或者SHader_feature 
```
    #pragma Multi_Comile _UseNormalMap_ON _UseNormalMap_OFF
    #pragma Shader_feature UseNormalMap_ON _UseNormalMap_OFF
```
 
 ---
 3. 使用if\else\endif条件

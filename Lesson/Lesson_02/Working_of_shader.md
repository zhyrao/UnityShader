#### Working of a Shader 着色器的工作流程
**0.  准备工作**
    为了绘制一个由顶点组成的网格片(mesh card)，首先需要收集所有的顶点的信息，并且将它们一个一个的传给顶点着色器来绘制模型。这些顶点的信息将会被看作一个个的包信息，其中包里面包含了这个顶点的信息：
>     * position(必须含有)
>     * normal
>     * color
>     * 其他需要的信息等   
  
   这个信息包被当作顶点着色器的输入内容，**vertexInput**，
>        struct vertexInput
        {
             postion;
             normal;
             color;
             ...;
        }
        

当vertexInput 经过顶点着色器变换以后，会输出一个另外一个结构体，**vertexOutput**，
>       struct vertexOutput
        {
            newPosition;
            其他信息;
        }
![流程图](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_02/Slide_02/slide_01.png?raw=true)

**1.  光栅化**
当上述内容完成后，我们将vertexOutput包进行下一步操作：**光栅化**。光栅化的主要工作内容是： 
>1. 找出哪些像素在屏幕范围内。
>2. 通过插值得出需要光栅化像素的颜色。

**Pixel Shader**
像素着色器为光栅化的每个像素计算得到最终的像素的：
>1. 颜色
>2. Alpha值

[详细过程](https://github.com/zhyrao/UnityShader/tree/master/Lesson/Lesson_02/Slide_02)
### Image Based Fresnel 基于图像的菲涅尔现象
在本节中, 我们将学习菲涅尔效应, 在我们了解任何fresnel effect之前, 先看看下面的这幅图片:  

![pic](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Image.png?raw=true) 

从图片中可以看到我们能够在距离相机越近的地方能够清楚的观察到湖面下面的石头, 而在越来越远的地方观察到的效果越来越差, 而在超过了一定的距离以后, 我们看不到任何石头的信息只能看到湖面上反射的信息. 这种现象就成为`Fresnel Effect`.


#### Fresnel Effect
一个法国的物体学家`Augustin Jean Fresel`提出想玻璃或者水这样的媒体会产生反射和折射两种现象. 而反射的数量程度取决于入射光线或者视线的角度.  
![fresnel](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_02.png?raw=true)  
>如图, 假设是一个湖的表面, 湖底有一些石头和小鱼, 而你在湖边向湖面观察. 
>
>当你垂直的看向湖面的时候, 你可以很清楚的观察到湖底的信息, 例如石头和小鱼, 这个是因为当你垂直观察的时候, 湖面产生的反射是最小的(可以忽略不计的). 也就是说你的视线和湖面的法线的夹角是0度. 当你看向湖面中间位置的时候, 你的视线与湖面表面的法线夹角为θ1, 这个时候θ1不再为0, 那么根据反射定律, 你能够看到一部分湖底的信息. 
> 
>而当你看向更远的地方的时候, 你的视线和湖面法线夹角为θ2, 因为θ2大于θ1, 那么你会看到更多的或者完全的反射信息, 这样你就可能会看到或者不会看到湖底的信息.  
>
>**总结来说, 你能看到的反射信息近似于你的视线和法线夹角.**

那么在我们编写shader的时候, 我们需要一个值来表示当视线和法线夹角变化的时候的变化. 我们肯定是不能使用它们的夹角θ的, 那么我们将使用什么呢? 我们将使用基本上在所有的光线计算中使用过的东西: **DOT(n, v)**


![dot](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_03.png?raw=true)
我们知道dot会给我们返回[-1, 1]之间的值, 而我们只需要[0,1]之间的取值. 在我们反射shader的时候有一个变量值叫_ReflectionFactor, 它的取值范围也是[0,1]之前, 当为0的时候没有任何反射, 当为1的时候为完全反射. 

当我们需要截取值范围的时候我们采用的是max(dot(n, v), 0), 我们可以继续使用这种方式来获取合理的范围. 但是为了理解和学习, 我们将采用另外一种由CG shader提供的方法: **saturate()**

### Saturate
![saturate](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_07.png?raw=true)

saturat(x)e的作用就是返回[0-1]之间的值. 如果传入的值x大于1, 那么就返回1, 如果传入的数值x小于0, 那么就返回0; 如果数值x在[0-1]之间, 那么就返回这个数值x. 

这样的话我们使用saturate只需要传入dot值就可以了. saturate(dot(n,v)) 

![reflection](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_03.png?raw=true)
值得注意的是, 当我们视线与法线的夹角为0, 也就是说dot值为1的时候, 其实我们实际上观察到的反射值是为0的; 当我们视线与法线夹角为90°的时候, 那么dot(n,v)是0, 但是我们实际上观察到的现象是全部为反射, 反射值为1. 那么我们需要在saturate(x)的值中做处理:  

**1-saturate(dot(n,v))**  

这样的话, 我们就获得了与实际观察情况一直的反射值.   

![1-saturate](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_04.png?raw=true)

最后的公式 **1 - saturate(dot(n,v))**就是我们需要的信息, 但是在实际上, 我们需要更多的信息来控制这个反射的距离, 例如在湖面0.3以后的信息开始有fresnel效应, 而在[0-0.3]之间是没有任何效应的. 那么我们就需要在shader中添加一个信息来控制这个fresnel effect的宽度. 

#### FresnelWidth
这个变量控制fresnel effect在何时开始起作用. 
![fresnelwidth](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_05.png?raw=true)
如图所示, 白色三角部分是全部的反射信息, 但是我们在实际上观察的时候, 可能不会需要那么多的信息, 那么就需要压缩这个反射区域. 我们不采用截取是因为如果截取了的话在表现形式上会产生突然出现反射/突然反射消失的现象, 这个是不合理的. 

我们采用以前使用过的方法[smoothstep()](https://en.wikipedia.org/wiki/Smoothstep)来实现这个压缩 
![smoothstep](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_58/Slide_58/Slide_06.png?raw=true)

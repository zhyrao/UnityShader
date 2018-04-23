### Gradient Pattern
在本节中，我们将来看看在UNITY中怎么创建程序控制的梯度模式，并且将在unity中实现这个shader。

在上节中，我们知道texture coordinate的取值范围是在0-1之间的，然而他们的方向是什么呢？
>在unity中，texture coordinate的取值是从左下角开始为(0,0)，右上角为最大值(1,1)。OpenGL中也是和unity一样的取值方式。但是在DirectX中有所不同，它的取值开始位置是左上角位置，(0,0),取值结束最大值位置是右下角位置为(1,1)。

在这里，我们将要去创建一张在x轴上面颜色渐变的Quad。
#### Circle Pattern
本节中，我们将理解圆的方程式，然后我们将使用这个方程创建一个可以使用参数控制圆的大小和位置的shader。
>跟前几节一样，我们依然使用alpha控制像素的显示：在圆内的显示出来，圆外的不显示。
![图片](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_14/Slide_14/Slide_02.png?raw=true)
从上图可以看出圆的方程式为：
$$radius^2 = r_p^2 + r_b^2$$
$r_p$是指在垂直方向的距离$r_b$是指在水平方向的距离。
从图中可以看出：
$$r_b = y'' - y'; r_p = x'' - x'$$

将圆心以及UV的坐标带入以后得到以下的圆的方程：
$$radius^2 = (uv.y - offset.y)^2 + (uv.x - offset.x)^2$$
$$=>$$
$$radius^2 = (uv.y - center.y)^2 + (uv.x - center.x)^2$$
可以得到在shader中如果 $circle < (radius)^2 $那么则在圆内，返回1，否则返回0

unity shader:
```
// 绘制圆
float drawCircle(float2 uv, float2 center, float radius)
{
    float circle = pow((uv.y - center.y), 2) + pow((uv.x - center.x), 2);
    if (circle < pow(radius,2))
        return 1;
    return 0;
}
```
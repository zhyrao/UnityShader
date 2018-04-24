#### Pattern Animation
在本节中，我们将使用三角函数等在shader中创建程序可控制的动画。

*原理：让shader中的圆形随着时间变化，alpha值也会随着变化，其中使用sin()函数来获取alpha值的变化，因为sin()的返回值范围是[-1, 1],而我们需要选取的是[0-1]，简单的把sin()返回结果使用abs()来进行截取实现这个目标。*



在shader中，我们通过smoothstep()函数来获取：
```
float alphaValue = abs(sin(_Time.y * _Speed))
```
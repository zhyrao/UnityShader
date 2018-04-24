#### Smoothstep Function
在本节中，我们将了解一下模式创建中比较重要的一个函数-**[Smoothstep](https://en.wikipedia.org/wiki/Smoothstep)**.
>Smoothstep是一个用来创建*Fading Pattern*的重要的方程。
$$value = Smoothstep(low value, high value, test value)$$

Smoothstep方程的返回值在[0,1]之间，它跟Normalization()很相似，但是它们之间是有区别的。
>1. smoothstep方程会将一个值在给定的值范围内进行压缩到[0-1]之间
2. smoothstep方程不是一个线性的。

![smoothstep graph](https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Smoothstep_and_Smootherstep.svg/1280px-Smoothstep_and_Smootherstep.svg.png)
如上图所示：x轴代表了所取的最低和最高值，y轴代表了方程的返回值。
>如果想要计算的值，小于最低值，那么都会返回0；如果大于最大值，那么都将会返回1.
```
    value = smoothstep(0, 10, 5) //返回0.5
    value = smoothstep(0, 10, -1) //返回0
    value = smoothstep(0, 10, 15) //返回1
    value = smoothstep(1, -1, 0.5) //可能在0.15
```

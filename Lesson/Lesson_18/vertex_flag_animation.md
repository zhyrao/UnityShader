#### Vertex Flag Animation
在本节中，我们将使用顶点动画来展现一个飘动的旗帜。
>原理：控制顶点在Z轴上的位置即可以控制旗帜在Z轴上的移动：
1. 频率(frequency)
2. 振幅(amplitude)
3. 速度(speed)
4. 离uv.x = 0的位置基本不动，随着x的增加飘动距离越大。
```
vertexPos.z = vertexPos.z + sin((uv.x - (_Time.y * _speed)) * _frequency) * (uv.x *amplitude)
```
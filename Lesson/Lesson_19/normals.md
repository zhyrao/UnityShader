####Normals
在本节中，我们将理解什么是**[Normal（法线）](https://en.wikipedia.org/wiki/Normal_geometry)**，以及它在数学形式中是如何表现的，它对于2D/3D中的直线或者曲线来说又是什么意义？

---

##### Normal:
1. 2D - World:
    i. A Plane:
        对于一个2D平面来说，normal就是垂直于这个平面的线。
    ii. A Curved Plane:
        对于一个2D的曲面来说，找到normal需要3步骤:
```
 1. 选取曲线上的一个点  
 2. 找到与这个点相切的平面
 3. 找到这个切面的normal//这个normal就被称为这个点在曲面的normal
```
2. 3D - World:
    i.3D Straight Plane:
        垂直于这个平面的线
    ii. 3D Curved Plane:
        同2D原理相似，还是使用3个步骤找到这个发现:
        ```
        1. 选取3D曲面的一个点
        2. 找到于这个点相切的曲面
        3. 找到这个相切曲面的垂直线。
        ```

##### Geometry
Geometry是有顶点vertex和面Face组成的，那么对应的就会有顶点法线和面法线：
1.Face Normal
>Face Normal就是经过面的中心点并且与这个面垂直的线

2.Vertex Normal
>顶点法线是有与这个顶点相关的面的法线来计算的。
1.找到所有与这个顶点有关系的面的法线face normal
2.将这些发现全部加起来
3.将加起来的结果归一化normalized
经过normalize的向量就是这个顶点的法线。

#### Mathematically Represent
法线是一个方向，我们用向量来表示：normalized vector.
我们在做顶点动画的时候，除了移动顶点在Z轴上的位置，还可以在顶点的发现方向移动来形成动画。
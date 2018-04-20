#### Model-View-Project Matrix 模型-视图-投影矩阵
在本章中，我们来大致了解一下3个不同的矩阵：模型、视图和投影矩阵（MVP）。这3个矩阵是顶点着色器将信息传递到光栅化之前用来将模型的信息转换/变换到特定坐标空间的。

---
##### Coordinate System 坐标系统
>In geometry, a [coordinate system](https://en.wikipedia.org/wiki/Coordinate_system) is a system which uses one or more numbers, or coordinates, to uniquely determine the position of the points or other geometric elements on a manifold such as Euclidean space.

---
##### Coordinate Space 坐标空间
>In mathematics, a [coordinate space](https://en.wikipedia.org/wiki/Coordinate_space) is a space in which an ordered list of coordinates, each from a set (not necessarily the same set), collectively determine an element (or point) of the space – in short, a space with a coordinate system.

在Unity 坐标变换系统中设计到以下几个变换空间：
   
    1. Object Space 模型空间
    2. World Space 世界空间
    3. View Space 视图/相机空间
    4. Projection Space 投影空间
>模型空间 代表了顶点在本身模型本地空间中相对于模型中心点的位置。
>世界空间 表示模型顶点在整个世界空间中当对于世界中心点的位置变换。
>视图控件 表示模型相对于相机中心点的位置变换。
>投影空间 表示结合了相机的Near plane/Far plane以及FOV后，顶点所在的空间位置。

##### Model-View-Projection Matrix MVP矩阵
UNITY_MATRIX_MVP 这个宏结合了这个3个矩阵，在后期的unity中将会被自动升级替换为UnityObjectToClipPos()。
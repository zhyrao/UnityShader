#### Normal Map Shader Intro
在本节中，我们先来看看在shader中使用Normal Map的时候需要的基本的信息等。
**我们将要写的这个shader的目标就是从一张切线空间法线贴图中转换得到世界坐标系下的法线信息。**
在前节中我们知道了为什么需要世界坐标系下面的法线信息：
>我们想要在世界坐标系下面模拟光照计算信息，需要光照和法线都在同一个坐标系下面。另外一个需要注意的是法线贴图在切线空间下面，而转换坐标系则最少需要一个矩阵， TBN 矩阵。

---
现在的问题是，让我们用切线空间下的法线和TBN矩阵相乘的时候，我们将会得到什么样的信息？是world-space Normal value 或者是object-space normal value?
>它的答案就在TBN矩阵中，TBN矩阵是有Tangent Binormal Normal组成的。所以它们相乘的结果决定于TBN中的Normal信息是在什么空间下面的。如果是object-space Normal，那么结果就是Object-space normal；如果TBN中的normal是world-space normal，那么结果就会是world-space normal。

---
当我们编写shader的时候，
>第一件事情就是我们从读取mesh的属性信息。例如mesh的normal、tangent等。其中normla\tangent都是object space的。是属于每一个顶点的信息。
第二就是我们会创建一个输入纹理贴图，这个贴图将会是法线贴图。

而最终的结果就是获取到世界坐标系下面的法线值。

---
现在的任务就是如何得到这个结果。基于TBN的分类，我们有两种情况：
```
其中我们已知的是顶点的相关信息如：
    vertex.normal
    vertex.tangent
    可以计算出:binormal = cross(vertex.normal, vertex.tangent)
1. TBN-World Space
    首先转换vertex.normal和vertex.tangent到世界坐标系下面，
    然后利用转换以后的世界坐标下的法线以及切线来获取世界坐标系下面的binormal从而组合成为TBG(World Space)。
    然后将法线信息和TBN矩阵相乘就得到了世界坐标系下面的法线信息。
2. TBN-Object Space
    这样的话我们就直接能够用已知的Object Space下的法线和切线以及利用法线和切线求解出来的副法线来组合成TBN矩阵。
    这样我们就可以在fragment shader中将切线空间下面的法线转换到Object-space，
    然后再乘以Model Matrix(_Object2World)将法线转换到我们最后将要使用的世界坐标法线。
    *在这里，我们在fragment里面使用了2个步骤*

**我们将采用第一个方案。因为在第一个方案中我们只在fragment shader中计算了一次。而在
第二个方案中，fragment shader中我们计算两次。**
```

---
现在我们已经理解了步骤：
>1. 从mesh信息中读取normal\tangent，然后叉乘得到binormal
2. 将本地坐标系下面的信息转换到世界坐标系。
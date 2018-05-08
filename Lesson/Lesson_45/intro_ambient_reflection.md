#### Ambient Reflection Intro
现在来学习Ambient Reflection(环境光)对场景的影响. 

环境光是一种没有方向的光线, 它是有大量的光线在同一个场景中对所有的物体都有同样的固定的强度的光照. 这意味着着在每一个表面上的每一个点都一律受到相同的光照信息. 

环境光的主要原理就是模拟光线在场景中一直跳弹, 在弹跳无数次以后最终被考虑作为弹跳光源, 这样它感觉是从任意方向射过来的光照.  
![bounce image](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_45/Slide_45/Slide_01.png?raw=true)

在数学上表示的时候, 分为环境光的系数值和环境光本身. 
*a = Ka * global ambient*
>其中Ka表示了在材质属性中环境光的系数值. 

在Unity中提供了内置的变量来获取环境光的值: **UNITY_LIGHTMODE_AMBIENT**

#### Circel Fading Edges
在本节中，我们将使用smoothstep函数来绘制一个边缘渐隐的圆。
>原理：越靠近圆边缘的像素的alpha值越小，在边缘处的alpha值为0.我们可以选定一个渐隐的宽度，使得像素值在这个宽度内的值使用smoothstep来控制它的alpha值。
#### Normal Vertex Animation
本节中学习如果在normal的方向进行动画。
```
float4 vertexNormalAnimation(float4 vertPos,float4 vertNormal, float2 uv)
{
    //vertPos.x = vertPos.x + sin((vertNormal.x - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.x);
    //vertPos.y = vertPos.y + sin((vertNormal.y - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.y);
    //vertPos.z = vertPos.z + sin((vertNormal.z - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.z);
    //vertPos.w = vertPos.w + sin((vertNormal.w - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.w);

    vertPos += sin((vertNormal - (_Time.y * _Speed)) * _Frequecy) *(_Amplitude * vertNormal);
    return vertPos;
}
```

#ifndef CVGLIGHTING_CGINC
#define CVGLIGHTING_CGINC

float3 normalFromColor(float4 colorVal)
	{
		// 如果不是DTX压缩
		#if defined(UNITY_NO_DXT5nm)
			return colorNewVal = colorVal.rgb * 2 - 1;
		#else
		// DXT:
			// R => X  => A
			// G => Y
			// B => Z
			float3 normalVal;
			normalVal = float3(colorVal.a  * 2.0 - 1.0,
								colorVal.g  * 2.0 - 1.0,
								0);
			// 这个原理是向量中各个分量的平方和的开根号等于这个向量的长度
			// normalVal.z = sqrt(1 - pow(normalVal.a, 2), pow(normalVal.g));
			normalVal.z = sqrt(1 - dot(normalVal, normalVal));
			return normalVal;
		#endif
	}

float3 WorldNormalFromNormalMap(sampler2D normalMap, float2 normalTexCoord, float3 tangentWorld, float3 binormalWorld, float3 normalWorld)
	{
		// 获取normal map中这个像素的颜色
		float4 colorAtPixel = tex2D(normalMap, normalTexCoord);
		// 将颜色转换为法线向量
		float3 normalAtPixel = normalFromColor(colorAtPixel);

		// 组合TBN
		float3x3 TBNWorld = float3x3(tangentWorld, binormalWorld, normalWorld);

		// TBN矩阵与法线相乘
		return normalize(mul(normalAtPixel, TBNWorld));
	}

#endif
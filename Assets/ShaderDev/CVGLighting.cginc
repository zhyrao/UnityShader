#ifndef CVGLIGHTING_CGINC
#define CVGLIGHTING_CGINC

float3 normalFromColor(float4 colorVal)
	{
		// �������DTXѹ��
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
			// ���ԭ���������и���������ƽ���͵Ŀ����ŵ�����������ĳ���
			// normalVal.z = sqrt(1 - pow(normalVal.a, 2), pow(normalVal.g));
			normalVal.z = sqrt(1 - dot(normalVal, normalVal));
			return normalVal;
		#endif
	}

float3 WorldNormalFromNormalMap(sampler2D normalMap, float2 normalTexCoord, float3 tangentWorld, float3 binormalWorld, float3 normalWorld)
	{
		// ��ȡnormal map��������ص���ɫ
		float4 colorAtPixel = tex2D(normalMap, normalTexCoord);
		// ����ɫת��Ϊ��������
		float3 normalAtPixel = normalFromColor(colorAtPixel);

		// ���TBN
		float3x3 TBNWorld = float3x3(tangentWorld, binormalWorld, normalWorld);

		// TBN�����뷨�����
		return normalize(mul(normalAtPixel, TBNWorld));
	}

#endif
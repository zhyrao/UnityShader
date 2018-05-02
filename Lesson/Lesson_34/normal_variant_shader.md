```
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/15NormalMapping_Variant"
{
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}

		_NormalMap("Normal Map", 2D) = "white"{}
		// 声明选项名及选项内容
		[KeywordEnum(ON,OFF)]_UseNormalMap("Use Normal Map?",float) = 0
	}

	// SubShader 
	SubShader
	{	
		Tags {"Quene" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Blend  SrcAlpha OneMinusSrcAlpha 
		Pass
		{

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			// 使用pragma定义多个选项内容
			#pragma multi_compile _USENORMALMAP_ON _USENORMALMAP_OFF

			uniform half4 _Color;
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;

			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 normal: Normal;
        // conditions
				#if _USENORMALMAP_ON
					float4 tangent: TANGENT;
				#endif
        
				float4 texCoord: TEXCOORD0 ; 
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float2 texCoord:TEXCOORD0;
				float4 normalWorld : TEXCOORD1;
        // conditions
				#if _USENORMALMAP_ON
					float2 normalTexCoord:TEXCOORD4;
					float4 tangentWorld:TEXCOORD2;
					float3 binormalWorld:TEXCOORD3;
				#endif
        
			};

			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				o.normalWorld = float4(normalize(mul(i.normal.xyz, (float3x3)unity_WorldToObject)).xyz, 1);
        // conditions				
				#if _USENORMALMAP_ON
					o.tangentWorld = normalize(mul(i.tangent, unity_ObjectToWorld));
					o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * i.tangent.w);
					o.normalTexCoord = (i.texCoord.xy * _NormalMap_ST.xy) + _NormalMap_ST.zw;
				#endif

				return o;
			}

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

			half4 frag(vertexOutput o): COLOR
			{
			  // conditions
				#if _USENORMALMAP_ON
					float4 colorAtPixel = tex2D(_NormalMap, o.normalTexCoord);
					float3 normalAtPixel = normalFromColor(colorAtPixel);
					float3x3 TBNWorld = float3x3(o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz);
					float3 normalAtWorld = normalize(mul(normalAtPixel, TBNWorld));
          
					return half4(normalAtWorld.xyz, 1);
				#else
					return half4(o.normalWorld.xyz,1);
				#endif

				//return tex2D(_MainTex, o.texCoord) * _Color;
				//return _Color;
			}

			ENDCG
		}
	}
}
```

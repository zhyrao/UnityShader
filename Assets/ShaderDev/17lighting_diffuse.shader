// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/17Lighting_Diffuse"
{
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_NormalMap("Normal Map", 2D) = "white"{}
		[KeywordEnum(ON,OFF)]_UseNormalMap("Use Normal Map?",float) = 0

		// 新增diffuse信息及光照选项
		_Diffuse("Diffuse %", Range(0,1)) = 1 
		[KeywordEnum(Off, Vert, Frag)] _Lighting("Lighting Mode", float) = 0
	}

	SubShader
	{	
		// 重要的是ForwardBase
		Tags {"LightMode" = "ForwardBase" "Quene" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Blend  SrcAlpha OneMinusSrcAlpha 
		// 通道
		Pass
		{

			CGPROGRAM
			#include "CVGLighting.cginc"
			#pragma vertex vert 
			#pragma fragment frag 
			#pragma multi_compile _USENORMALMAP_ON _USENORMALMAP_OFF
			#pragma shader_feature _LIGHTING_OFF _LIGHTING_VERT _LIGHTING_FRAG

			uniform half4 _Color;
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;

			uniform float _Diffuse;
			uniform float4 _LightColor0;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 normal: Normal;
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
				#if _USENORMALMAP_ON
					float2 normalTexCoord:TEXCOORD4;
					float4 tangentWorld:TEXCOORD2;
					float3 binormalWorld:TEXCOORD3;
				#endif

				// 增加一个在vertex计算的颜色值
				#if _LIGHTING_VERT
					float4 surfaceColor : COLOR0;
				#endif
			};

			//// 根据diffuse reflection 公式计算光照值
			//float3 DiffuseLambert(float3 lightColor, float diffuseVal, float attenuation, float3 normalVal, float3 lightDir)
			//{
			//	return lightColor * diffuseVal * attenuation * max(0, dot(normalVal, lightDir));
			//}

			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				o.normalWorld = float4(normalize(mul(i.normal.xyz, (float3x3)unity_WorldToObject)).xyz, 1);
				
				#if _USENORMALMAP_ON
					o.tangentWorld = normalize(mul(i.tangent, transpose(unity_ObjectToWorld)));
					//o.tangentWorld = normalize(mul(i.tangent, (unity_ObjectToWorld)));
					//o.tangentWorld = normalize(mul(unity_ObjectToWorld, i.tangent));
					o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * i.tangent.w);
					o.normalTexCoord = (i.texCoord.xy * _NormalMap_ST.xy) + _NormalMap_ST.zw;
				#endif

				#if _LIGHTING_VERT
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float3 lightColor = _LightColor0.xyz;
					float attenuation = 1;
					o.surfaceColor = float4(DiffuseLambert(lightColor, _Diffuse, attenuation, lightDir, o.normalWorld.xyz), 1);
				#endif
				return o;
			}

			half4 frag(vertexOutput o): COLOR
			{
				#if _USENORMALMAP_ON
					float3 normalAtWorld = WorldNormalFromNormalMap(_NormalMap, o.normalTexCoord.xy, o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz);
					//return half4(normalAtWorld.xyz, 1);
				#else
					float3 normalAtWorld = o.normalWorld.xyz;
					//return half4(o.normalWorld.xyz,1);
				#endif

				#if _LIGHTING_FRAG
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float3 lightColor = _LightColor0.xyz;
					float attenuation = 1;
					return half4(DiffuseLambert(lightColor, _Diffuse, attenuation, lightDir, normalAtWorld), 1);
				#elif _LIGHTING_VERT
					return half4(o.surfaceColor);
				#else 
					return half4(normalAtWorld.xyz, 1);
				#endif
			}
			ENDCG
		}
	}
}
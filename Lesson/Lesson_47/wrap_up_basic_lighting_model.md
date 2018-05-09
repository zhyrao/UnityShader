#### Wrap up Basic Lighting Model
我们在本节里面来总结一下Basic Lighting Model(基础光照模型)的相关. 为了方便记忆基础光照模型, 我们简化的基座BEADS:
> Basic Lighting = Emmisive + Ambient + Diffuse + Specular

在前面的章节中, 我们理解了怎么去计算diffuse 和 specular 以及 ambient的光照值, 现在我们只剩下Emmisive. 
>Emmisive是光源的一个属性值, 通常来说在OpenGL 或者其他游戏引擎中, 光源物体是不可见的. 如果要想在游戏中可见, 那么必须创建一个模型, 然后运行漫反射或者高光反射来表现它, 然后在最上面, 可以实现特殊的效果例如halo effect, lens flare, 或者bloom. 所以我们不会给它编写shader因为它们是被引擎提供的.

在编写基础光照的shader中, 我们在最终的颜色值得计算中还剩余两个属性没有计算在内.
1. Main Texture
2. Tint Color

现在我们来在shader中加上它们.

```
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/20Lighting_All"
{
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_NormalMap("Normal Map", 2D) = "white"{}
		[KeywordEnum(ON,OFF)]_UseNormalMap("Use Normal Map?",float) = 0

		_Diffuse("Diffuse %", Range(0,1)) = 1 
		[KeywordEnum(Off, Vert, Frag)] _Lighting("Lighting Mode", float) = 0

		_SpecularMap("Specular Map", 2D) = "black"{}
		_SpecularFactor("Specular %", Range(0,1)) = 1
		_SpecularPower("Specular Power", float) = 100
		[Toggle]_Ambient("Use Ambient?", float) = 0
		_AmbientFactor("Ambient %", Range(0, 1)) = 1
	}

	SubShader
	{	
		Tags {"Quene" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Blend  SrcAlpha OneMinusSrcAlpha 
		// 通道
		Pass
		{
			// 将渲染路径Tags移动到指定的pass内
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "CVGLighting.cginc"
			#pragma vertex vert 
			#pragma fragment frag 
			#pragma shader_feature _USENORMALMAP_ON _USENORMALMAP_OFF
			#pragma shader_feature _LIGHTING_OFF _LIGHTING_VERT _LIGHTING_FRAG
			#pragma shader_feature _AMBIENT_OFF _AMBIENT_ON

			uniform half4 _Color;
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;

			uniform float _Diffuse;
			uniform float4 _LightColor0;

			uniform sampler2D _SpecularMap;
			uniform float _SpecularFactor;
			uniform float _SpecularPower;

			#if _AMBIENT_ON
				uniform float _AmbientFactor;
			#endif

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
					float4 tangentWorld:TEXCOORD2;
					float3 binormalWorld:TEXCOORD3;
					float2 normalTexCoord:TEXCOORD4;
				#endif
				float4 worldPos :TEXCOORD5;
				#if _LIGHTING_VERT
					float4 surfaceColor : COLOR0;
				#endif
			};

			
			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				o.normalWorld = float4(normalize(mul(i.normal.xyz, (float3x3)unity_WorldToObject)).xyz, 1);
				o.worldPos = mul(unity_ObjectToWorld, i.vertex);
				#if _USENORMALMAP_ON
					o.tangentWorld = normalize(mul(i.tangent, transpose(unity_ObjectToWorld)));
					o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * i.tangent.w);
					o.normalTexCoord = (i.texCoord.xy * _NormalMap_ST.xy) + _NormalMap_ST.zw;
				#endif

				#if _LIGHTING_VERT
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

					float3 lightColor = _LightColor0.xyz;
					float attenuation = 1;
					float3 diffuseCol = DiffuseLambert(lightColor, _Diffuse, attenuation, lightDir, o.normalWorld.xyz);

					//float4 specularColor = tex2D(_SpecularMap, o.texCoord.xy);
					float4 specularColor = tex2Dlod(_SpecularMap, float4(o.texCoord.xy,0,0));

					float3 worldSpaceViewDir = normalize(_WorldSpaceCameraPos - o.worldPos);
					float3 specularValue = SpecularBlinnPhong(o.normalWorld, lightDir, worldSpaceViewDir, specularColor.rgb, _SpecularFactor, attenuation, _SpecularPower);
					float3 texColor = tex2Dlod(_MainTex, float4(o.texCoord.xy,0,0));

					o.surfaceColor = float4((diffuseCol + specularValue) * texColor * _Color, 1);

					// 结果再加上ambientColor
					#if _AMBIENT_ON
						float3 ambientColor = _AmbientFactor * UNITY_LIGHTMODEL_AMBIENT;
						o.surfaceColor = float4((o.surfaceColor.rgb + ambientColor) * texColor  * _Color, 1);
					#endif
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
					float3 diffuseCol = DiffuseLambert(lightColor, _Diffuse, attenuation, lightDir, normalAtWorld);

					float4 specularColor = tex2D(_SpecularMap, o.texCoord.xy);
					//float3 worldPos = mul(unity_ObjectToWorld, i.vertex);
					float3 worldSpaceViewDir = normalize(_WorldSpaceCameraPos - o.worldPos);
					float3 specularValue = SpecularBlinnPhong(normalAtWorld, lightDir, worldSpaceViewDir, specularColor.rgb, _SpecularFactor, attenuation, _SpecularPower);

					//return half4(diffuseCol + specularValue, 1);
					// 结果再加上ambientColor
					#if _AMBIENT_ON
						float3 ambientColor = _AmbientFactor * UNITY_LIGHTMODEL_AMBIENT;
						float3 texColor = tex2D(_MainTex, o.texCoord.xy);
						return half4((diffuseCol + specularValue + ambientColor) * texColor * _Color, 1);
					#else
						return half4((diffuseCol + specularValue) * _Color, 1);
					#endif

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
```

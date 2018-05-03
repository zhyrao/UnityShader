#### Diffuse Reflection(code)
在本节中, 我们将学习编写diffuse reflection(漫反射)shader. 在开始之前, 我们来回顾一下[forward rendering](https://github.com/zhyrao/UnityShader/blob/master/Lesson/Lesson_36/lighting_model_rendering_path_1.md)的相关知识, forward rendering 被广泛的应用在移动平台\PC平台\主机平台等.   

所以当我们编写diffuse shader或者其他类型的shader的时候, 我们将使用forward rendering path.  我们已经知道在forward rendering中有两个不同的pass来控制不同的光照计算:  
>1. Forward Base  
>2. Additional Pass

其中在ForwardBase Pass中只会有一个平行光光源, 不会有其他的光源, 并且这个光源的Attenuation一直都是1. 
>如果场景中有其他的光源例如点光源\射灯光源, 那么必须编写additional pass来计算光照值.

所以在本节中我们使用forward base pass来表现diffuse reflection. 为了计算diffuse reflection shader的光照值, 完全控制shader的表现, 以及以后对性能能够优化, 必须提供相关的信息:
- diffuse property
  - (表面rough程度, 表面反射程度)
- lighting(计算光照值的方法)
  - 不计算
  - 在vertex的时候计算
  - 在fragment的时候计算
  >这里的一般应用是如果这个物体在场景中比较突出, 那么选择使用fragment来计算, 这样将更加显示出这个物体的细节; 如果没有那么重要那么选择在vertex的时候计算光照, 这样可以提升性能, 但是没有fragment那么光滑. 

综上所述, 我们使用Forward Rendering path, 然后选择在forwardBase中计算光照值.

首先来回顾一下diffuse reflection的公式:![diffuse](https://camo.githubusercontent.com/618f93ac17b5e501a30109d4a6ea5fa992cf75e2/687474703a2f2f6c617465782e636f6465636f67732e636f6d2f6769662e6c617465783f6425323025334425323025354373756d5f25374269253344302537442535452537426e253744696e74656e736974795f5f2537422532386c6967687425323925374425323025354374696d6573253230446966667573655f2537422532386d6174657269616c25323070726f706572747925323925374425323025354374696d6573253230616c74656e756174696f6e5f2537422532386c6967687425323925374425323025354374696d65732532302535426d6178253238302532432532302532384e25323025354363646f742532304c253239253239253544), 我们可以看到这个公式是由4个部分组成:
- intensity 
  >在unity中, 我们使用unity提供的内置shader变量: _LightColor0 提供的光源强度信息
- diffuse
  >这里我们自己定义这个属性: _Diffuse
- attenuation
  >因为是平行光, 这个衰减度一直是1. 
- max(0, dot(N·L))
  >unity提供了世界坐标系下的光源位置信息(_WorldSpaceLightPos0), 我们可以结合世界法线信息计算;其中_WorldSpaceLightPos0.xyz表示了在空间中的位置,_WorldSpaceLightPos0.w值是0或者1: 0表示了平行光, 1表示了其他类型光源.


##### SHADER
```
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
			uniform float3 _LightColor0;

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

			// 根据diffuse reflection 公式计算光照值
			float3 DiffuseLambert(float3 lightColor, float diffuseVal, float attenuation, float3 normalVal, float3 lightDir)
			{
				return lightColor * diffuseVal * attenuation * max(0, dot(normalVal, lightDir));
			}

			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				o.normalWorld = float4(normalize(mul(i.normal.xyz, (float3x3)unity_WorldToObject)).xyz, 1);
				
				#if _USENORMALMAP_ON
					o.tangentWorld = normalize(mul(i.tangent, unity_ObjectToWorld));
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
```

>注意当我们转动模型的时候, 在一定的情况下发现会有问题, 我们在下节中修复这个问题. 

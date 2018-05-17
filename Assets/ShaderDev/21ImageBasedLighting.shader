// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/21ImageBasedLighting"
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

		[KeywordEnum(Off, Refl, Refr)] _IBLMode("IBL Mode", float) = 0
		_ReflectionFactor("Reflection %", Range(0, 1)) = 1
		_CubeMap("Cube Map", Cube) = ""{}
		_Detail("Reflection Detail", Range(1, 9)) = 1.0
		_ReflectionExposure("HDR Exposure", float) = 1.0
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
			#pragma shader_feature _IBLMODE_OFF _IBLMODE_REFL _IBLMODE_REFR

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

			uniform samplerCUBE _CubeMap;
			uniform half _Detail;
			uniform float _ReflectionFactor;
			uniform float _ReflectionExposure;

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
				#else 
					#if _IBLMODE_REFL
						float4 surfaceColor : COLOR0;
					#endif
				#endif
			};

			float3 IBLRefl(samplerCUBE cubeMap, half detail, float3 worldReflection, float exposure,float reflectionFactor)
			{
				float4 cubeMapCol = texCUBElod(cubeMap, float4(worldReflection.xyz, detail)).rgba;

				return cubeMapCol.rgb * (cubeMapCol.a * exposure) * reflectionFactor;
			}
			
			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				UNITY_INITIALIZE_OUTPUT(vertexOutput, o);
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				o.normalWorld = float4(normalize(mul(normalize(i.normal.xyz), (float3x3)unity_WorldToObject)).xyz, i.normal.w);
				o.worldPos = mul(unity_ObjectToWorld, i.vertex);

				#if _USENORMALMAP_ON
					o.tangentWorld = normalize(mul(i.tangent, transpose(unity_ObjectToWorld)));
					o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * i.tangent.w);
					o.normalTexCoord = (i.texCoord.xy * _NormalMap_ST.xy) + _NormalMap_ST.zw;
				#endif
				float3 worldSpaceViewDir = normalize(_WorldSpaceCameraPos - o.worldPos);
				#if _LIGHTING_VERT
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

					float3 lightColor = _LightColor0.xyz;
					float attenuation = 1;
					float3 diffuseCol = DiffuseLambert(lightColor, _Diffuse, attenuation, lightDir, o.normalWorld.xyz);

					//float4 specularColor = tex2D(_SpecularMap, o.texCoord.xy);
					float4 specularColor = tex2Dlod(_SpecularMap, float4(o.texCoord.xy,0,0));

		
					float3 specularValue = SpecularBlinnPhong(o.normalWorld, lightDir, worldSpaceViewDir, specularColor.rgb, _SpecularFactor, attenuation, _SpecularPower);
					float3 texColor = tex2Dlod(_MainTex, float4(o.texCoord.xy,0,0));

					o.surfaceColor = float4(specularValue + diffuseCol * texColor * _Color, 1);

					// 结果再加上ambientColor
					#if _AMBIENT_ON
						float3 ambientColor = _AmbientFactor * UNITY_LIGHTMODEL_AMBIENT;
						o.surfaceColor = float4(o.surfaceColor.rgb + ambientColor, 1);
					#endif

					#if _IBLMODE_REFL						
						float3 worldReflection = reflect(-worldSpaceViewDir, o.normalWorld.xyz);
						o.surfaceColor.rgb *= IBLRefl(_CubeMap, _Detail, worldReflection, _ReflectionExposure, _ReflectionFactor);
					#endif
				//#elif _LIGHTING_OFF
				//	//#if _AMBIENT_ON
				//	//	float3 ambientColor = _AmbientFactor * UNITY_LIGHTMODEL_AMBIENT;
				//	//	o.surfaceColor.rgb += float4(o.surfaceColor.rgb + ambientColor, 1);
				//	//#endif

				//	#if _IBLMODE_REFL	
				//		float3 worldReflection = reflect(-worldSpaceViewDir, o.normalWorld.xyz);
				//		o.surfaceColor.rgb += IBLRefl(_CubeMap, _Detail, worldReflection, _ReflectionExposure, _ReflectionFactor);
				//	#endif
				#else
					#if _IBLMODE_REFL	
						float3 worldReflection = reflect(-worldSpaceViewDir, o.normalWorld.xyz);
						o.surfaceColor.rgb += IBLRefl(_CubeMap, _Detail, worldReflection, _ReflectionExposure, _ReflectionFactor);
					#endif
				#endif
				return o;
			}

			half4 frag(vertexOutput o): COLOR
			{
				float4 finalColor = float4(0, 0, 0, _Color.a);

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

					float3 texColor = tex2D(_MainTex, o.texCoord.xy);

					finalColor.rgb += specularValue +  diffuseCol * texColor * _Color;
					#if _AMBIENT_ON
						float3 ambientColor = _AmbientFactor * UNITY_LIGHTMODEL_AMBIENT;
						//return half4((diffuseCol + specularValue + ambientColor) * texColor * _Color, 1);
						finalColor.rgb += ambientColor;
					#endif

					#if _IBLMODE_REFL
						float3 worldReflection = reflect(-worldSpaceViewDir, normalAtWorld);
						finalColor.rgb *= IBLRefl(_CubeMap, _Detail, worldReflection, _ReflectionExposure, _ReflectionFactor);
					#endif

				#elif _LIGHTING_VERT
					finalColor = o.surfaceColor;
				#else 
					#if _IBLMODE_REFL	
						float3 worldSpaceViewDir = normalize(_WorldSpaceCameraPos - o.worldPos);
						float3 worldReflection = reflect(-worldSpaceViewDir, normalAtWorld);
						finalColor.rgb += IBLRefl(_CubeMap, _Detail, worldReflection, _ReflectionExposure, _ReflectionFactor);
					#endif
					//return half4(normalAtWorld.xyz, 1);
				#endif

				return finalColor;
			}
			ENDCG
		}
	}
}
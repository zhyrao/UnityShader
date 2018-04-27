// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/14OutlineShader"
{
	// 属性
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_OutlineWidth("Outline Width", float) = 0.05
		_OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
	}

	// SubShader 
	SubShader
	{	
		Tags {"Quene" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		

		// 描边通道
		Pass
		{
			Blend  SrcAlpha OneMinusSrcAlpha 
			Cull Front	// 优化不渲染
			ZWrite off	// 深度不写入
			
			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			uniform float _OutlineWidth;
			uniform float4 _OutlineColor;

			struct vertexInput
			{
				float4 vertex : POSITION;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
			};

			// 组合缩放矩阵，得到缩放后的顶点
			float4 Outline(float4 vertexPos, float outlineWidth)
			{
				float4x4 scaleMat;
				scaleMat[0][0] = 1.0 + outlineWidth;
				scaleMat[0][1] = 0;
				scaleMat[0][2] = 0;
				scaleMat[0][3] = 0;

				scaleMat[1][0] = 0;
				scaleMat[1][1] = 1.0 + outlineWidth;
				scaleMat[1][2] = 0;
				scaleMat[1][3] = 0;

				scaleMat[2][0] = 0;
				scaleMat[2][1] = 0;
				scaleMat[2][2] = 1.0 + outlineWidth;
				scaleMat[2][3] = 0;

				scaleMat[3][0] = 0;
				scaleMat[3][1] = 0;
				scaleMat[3][2] = 0;
				scaleMat[3][3] = 1.0;

				return mul(scaleMat, vertexPos);
			}


			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(Outline(i.vertex, _OutlineWidth));

				return o;
			}

			half4 frag(vertexOutput o): COLOR
			{
				return _OutlineColor;	// 仅仅返回颜色值
				//return _Color;
			}

			ENDCG
		}
		// 正常绘制通道通道
		Pass
		{
			Blend  SrcAlpha OneMinusSrcAlpha 
			Cull Back // 优化（默认也是）
			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			uniform half4 _Color;
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 texCoord: TEXCOORD0 ; 
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float2 texCoord:TEXCOORD0;
			};


			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				return o;
			}

			half4 frag(vertexOutput o): COLOR
			{
				return tex2D(_MainTex, o.texCoord) * _Color;
				//return _Color;
			}

			ENDCG
		}
	}
}
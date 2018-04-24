// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/08CircleFadeEdges"
{
	// 属性
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_Center("Circle Center", float) = 1
		_Radius("Circlle Radius", float) = 0.5
		_Feather("Circle Fade Feather", Range(0.001, 0.1)) = 0.05
	}

	// SubShader 
	SubShader
	{	
		Tags {"Quene" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		// 通道
		Pass
		{
			Blend  SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			uniform half4 _Color;
			uniform sampler2D  _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _Center;
			uniform float _Radius;
			uniform float _Feather;

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

			// float drawLine(float2 uv, float Start, float Width)
			// {
			// 	// 如果两个的条件是&&就是交集，如果是||就是并集
			// 	if ((uv.x > Start && uv.x < Start + Width) || (uv.y > Start && uv.y < Start + Width))
			// 	{
			// 		return 1;
			// 	}

			// 	return 0;
			// }

			// 绘制圆
			float drawCircle(float2 uv, float2 center, float radius)
			{
				float circle = pow((uv.y - center.y), 2) + pow((uv.x - center.x), 2);
				if (circle < pow(radius,2))
					return 1;
				return 0;
			}

			float drawCircleFade(float2 uv, float2 center, float radius, float feather)
			{
				float circle = pow((uv.y - center.y), 2) + pow((uv.x - center.x), 2);
				float radiusSqr = pow(radius,2);
				// if (circle < radiusSqr)
				// 	return smoothstep(radiusSqr, radiusSqr - feather, circle);
				// return 0;
				return smoothstep(radiusSqr, radiusSqr - feather, circle);
			}

			half4 frag(vertexOutput o): COLOR
			{
				float4 col =  tex2D(_MainTex, o.texCoord) * _Color;
				//col.a = o.texCoord.x;
				//col.a = sin(o.texCoord.x * 50);
				//col.a = drawLine(o.texCoord.xy, _StartLine, _Width);
				col.a = drawCircleFade(o.texCoord.xy, _Center, _Radius,_Feather);
				//col.a = smoothstep(0.5, 1, o.texCoord.x);
				//col.a = smoothstep(1, 0.5, o.texCoord.x);
				return col;
			}


			ENDCG
		}
	}
}
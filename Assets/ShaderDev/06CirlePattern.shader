// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/06Circle"
{
	// 属性
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_Center("Circle Center", float) = 1
		_Radius("Circlle Radius", float) = 0.5
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

			half4 frag(vertexOutput o): COLOR
			{
				float4 col =  tex2D(_MainTex, o.texCoord) * _Color;
				//col.a = o.texCoord.x;
				//col.a = sin(o.texCoord.x * 50);
				//col.a = drawLine(o.texCoord.xy, _StartLine, _Width);
				col.a = drawCircle(o.texCoord.xy, _Center, _Radius);
				return col;
			}


			ENDCG
		}
	}
}
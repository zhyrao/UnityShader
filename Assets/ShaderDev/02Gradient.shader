// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/02Gradient"
{
	// 属性
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}

	}

	// SubShader 
	SubShader
	{	
		Tags {"RenderType" = "Transparent" "Quene" = "Transparent"  "IgnoreProjector" = "True" }

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
				float4 col =  tex2D(_MainTex, o.texCoord) * _Color;
				col.a = o.texCoord.x;

				return col;
			}

			ENDCG
		}
	}
}
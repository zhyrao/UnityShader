// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderDev/11VertexNormalAnimation"
{
	// 属性
	Properties
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D ) = "white" {}
		_Frequecy("Frequecy", float) = 1
		_Amplitude("Amplitude", float) = 1 
		_Speed("Speed", float) = 1 
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
			uniform float _Frequecy;
			uniform float _Amplitude;
			uniform float _Speed;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 normal:NORMAL;
				float4 texCoord: TEXCOORD0 ; 
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float2 texCoord:TEXCOORD0;
			};

			float4 vertexFlagAnimation(float4 vertPos, float2 uv)
			{
				vertPos.z = vertPos.z + sin((uv.x - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * uv.x);

				return vertPos;
			}

			float4 vertexNormalAnimation(float4 vertPos,float4 vertNormal, float2 uv)
			{
				//vertPos.x = vertPos.x + sin((vertNormal.x - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.x);
				//vertPos.y = vertPos.y + sin((vertNormal.y - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.y);
				//vertPos.z = vertPos.z + sin((vertNormal.z - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.z);
				//vertPos.w = vertPos.w + sin((vertNormal.w - (_Time.y * _Speed))* _Frequecy) * (_Amplitude * vertNormal.w);


				vertPos += sin((vertNormal - (_Time.y * _Speed)) * _Frequecy) *(_Amplitude * vertNormal);
				return vertPos;
			}

			vertexOutput vert(vertexInput i)
			{
				vertexOutput o;
				//i.vertex = vertexFlagAnimation(i.vertex, i.texCoord);
				i.vertex = vertexNormalAnimation(i.vertex, i.normal, i.texCoord);
				o.pos = UnityObjectToClipPos(i.vertex);
				o.texCoord = (i.texCoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;

				return o;
			}

			
			half4 frag(vertexOutput o): COLOR
			{
				float4 col =  tex2D(_MainTex, o.texCoord) * _Color;

				return col;
			}

			ENDCG
		}
	}
}
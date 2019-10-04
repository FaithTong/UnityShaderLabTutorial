Shader "Custom/Texture"
{
	Properties
	{
		_MainColor ("MainColor", Color) = (1, 1, 1, 1)
		_MainTex ("MainTex", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _MainColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			void vert (in float4 vertex : POSITION,
						in float2 uv : TEXCOORD0,
						out float4 position : SV_POSITION,
						out float2 texcoord : TEXCOORD0)
			{
				position = UnityObjectToClipPos(vertex);
				texcoord = uv * _MainTex_ST.xy + _MainTex_ST.zw;
				// texcoord = (uv + _MainTex_ST.zw) * _MainTex_ST.xy;
			}

			void frag (in float4 position : SV_POSITION,
						in float2 texcoord : TEXCOORD0,
						out fixed4 color : SV_TARGET)
			{
				color = tex2D(_MainTex, texcoord) * _MainColor;
			}
			ENDCG
		}
	}
}

Shader "Surface/Final Color Modify"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert finalcolor:ModifyColor

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4	_ColorTint;

		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		// 最终颜色修改函数
		void ModifyColor (Input IN, SurfaceOutput o, inout fixed4 color)
		{
			color *= _ColorTint;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

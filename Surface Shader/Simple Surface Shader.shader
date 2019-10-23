Shader "Surface/Simple Surface Shader"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Smoothness ("Smoothness", Range(0,1)) = 0
	}
	SubShader
	{
		CGPROGRAM

		// 定义表面函数名为surf，使用物理光照模型
		#pragma surface surf Standard

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Metallic;
		fixed _Smoothness;

		// 表面函数，使用金属性工作流表面结构体
		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

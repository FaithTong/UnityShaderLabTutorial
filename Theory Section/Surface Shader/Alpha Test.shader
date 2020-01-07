Shader "Surface/Alpha Test"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_AlphaTest ("Alpha Test", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags{"Queue" = "AlphaTest"}

		CGPROGRAM

		// 添加alphatest指令开启透明测试
		// 添加addshadow指令修正透明测试所投射的阴影
		#pragma surface surf Lambert alphatest:_AlphaTest addshadow

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

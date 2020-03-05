Shader "Samples/Dynamic Liquid"
{
	Properties
	{
		_Color("Color", Color) = (1, 0, 0, 1)
		_Specular("Specular_Smoothness", Color) = (0, 0, 0, 0)
		_Level("Liquid Level", float) = 0

		[KeywordEnum(X,Z)] _Direction("Ripple Direction", float) = 0
		_Speed("Ripple Speed", float) = 1
		_Height("Ripple Height", float) = 1
	}
	SubShader
	{
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent"}
		Blend SrcColor DstColor

		CGPROGRAM
		#pragma surface surf StandardSpecular noshadow
		#pragma shader_feature _DIRECTION_X _DIRECTION_Z

		struct Input
		{
			float3 worldPos;
		};

		fixed4 _Color;
		fixed4 _Specular;
		half _Level;

		half _Speed;
		half _Height;

		void surf (Input IN, inout SurfaceOutputStandardSpecular o)
		{
			float3 pivot = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
			float3 pos = pivot - IN.worldPos;
			float3 ripple = sin(_Time.y * _Speed) * _Height * pos;

			fixed level;
			#if _DIRECTION_X
			level = step(0, pos.y + ripple.x + _Level * 0.01);
			#else
			level = step(0, pos.y + ripple.z + _Level * 0.01);
			#endif

			clip(level - 0.01);

			o.Albedo = _Color;
			o.Specular = _Specular.rgb;
			o.Smoothness = _Specular.a;
		}
		ENDCG
	}
}
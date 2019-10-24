Shader "Surface/Vertex Modify"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_Expansion ("Expansion", Range(0, 0.1)) = 0
	}
	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed _Expansion;

		void vert (inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _Expansion;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

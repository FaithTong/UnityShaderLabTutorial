Shader "Surface/Edge Length Based Tessellation"
{
	Properties
	{
		_MainTex ("Color", 2D) = "white" {}

		_EdgeLength ("Edge Length", Range(1, 32)) = 1
		_HeightMap ("Height Map", 2D) = "gray" {}
		_Height ("Height", Range(0, 1.0)) = 0

		_NormalMap ("Normal Map", 2D) = "bump" {}
		_Bumpiness ("Bumpiness", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 300
		CGPROGRAM

		// 声明曲面细分函数和顶点修改函数的编译指令
		#pragma surface surf Lambert tessellate:tessellateEdge vertex:height addshadow nolightmap fullforwardshadows
		#include "Tessellation.cginc"
		// #pragma target 4.6

		struct appdata {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };
		half _EdgeLength;

		// 曲面细分函数
		float4 tessellateEdge (appdata v0, appdata v1, appdata v2)
		{
			return UnityEdgeLengthBasedTess (v0.vertex. v1.vertex, v2.vertex, _EdgeLength);
		}

		sampler2D _HeightMap;
		float4 _HeightMap_ST;
		fixed _Height;

		// 顶点修改函数
		void height (inout appdata v)
		{
			float2 texcoord = TRANSFORM_TEX(v.texcoord, _HeightMap);

			// 对_HeightMap采样，然后乘以_Height
			float h = tex2Dlod(_HeightMap, float4(texcoord, 0, 0)).r * _Height;

			// 顶点延着法线方向偏移h
			v.vertex.xyz += v.normal * h;
		}

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		sampler2D _MainTex;
		sampler2D _NormalMap;
		fixed _Bumpiness;

		void surf (Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;

			float3 n = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			n.xy *= fixed2(_Bumpiness, _Bumpiness);
			o.Normal = n;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

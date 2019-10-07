Shader "Custom/Blending Transparent"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_MainColor ("MainColor(RGB_A)", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"IgnoreProjector" = "True"
		}

		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbasse
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 vertex : TEXCOORD0;
				float2 texcoord : TEXCOORD1;
				float3 normal : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _MainColor;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.vertex = v.vertex;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldNromal = UnityObjectToWorldNormal(i.normal);
				worldNromal = normalize(worldNromal);

				float3 worldLightDir = WorldSpaceLightDir(i.vertex);
				worldLightDir = normalize(worldLightDir);

				fixed NdotL = saturate(dot(worldNromal, worldLightDir));

				fixed4 color = tex2D(_MainTex, i.texcoord);

				color.rgb *= _MainColor.rgb * NdotL * _LightColor0;
				color.rgb += unity_AmbientSky;

				color.a *= _MainColor.a;

				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}

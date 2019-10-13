Shader "Custom/Stencil-Test B"
{
	Properties
	{
		_MainColor ("Main Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags {"Queue" = "Geometry"}

		Pass
		{
			Stencil
			{
				Ref 1
				Comp NotEqual
				Pass Keep
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
			};

			fixed4 _MainColor;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldNormal = normalize(worldNormal);
				
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldLight = UnityWorldSpaceLightDir(i.worldPos.xyz);
				worldLight = normalize(worldLight);

				fixed NdotL = saturate(dot(i.worldNormal, worldLight));
				
				fixed4 color = _MainColor * NdotL * _LightColor0;
				color += unity_AmbientSky;
				
				return color;
			}
			ENDCG
		}
	}
	// FallBack "Diffuse"
}

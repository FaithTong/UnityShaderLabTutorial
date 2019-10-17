Shader "Custom/Cubemap"
{
	Properties
	{
		_MainColor ("MainColor", Color) = (1, 1, 1, 1)
		_Cubemap ("Cubemap", Cube) = "" {}
		_Reflection ("Reflection", Range(0, 1)) = 0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _MainColor;
			samplerCUBE _Cubemap;

			void vert (in float4 vertex : POSITION,
						out float4 position : SV_POSITION,
						out float4 worldPos : TEXCOORD0,
						out float3 worldNormal : TEXCOORD1)
			{
				position = UnityObjectToClipPos(vertex);
				
			}

			void frag (in float4 position : SV_POSITION,
						out fixed4 color : SV_TARGET)
			{
				float3 viewDir = UnityWorldSpaceViewDir(worldPos.xyz));
				float3 refDir = reflect(-viewDir.xyz, worldNormal);
				color = lerp(_MainColor, ref, _Reflection);
			}
			ENDCG
		}
	}
}

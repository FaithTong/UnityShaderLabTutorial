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
			fixed _Reflection;

			void vert (in float4 vertex : POSITION,
						in float3 normal : NORMAL,
						out float4 position : SV_POSITION,
						out float4 worldPos : TEXCOORD0,
						out float3 worldNormal : TEXCOORD1)
			{
				position = UnityObjectToClipPos(vertex);
				worldPos = mul(unity_ObjectToWorld, vertex);
				worldNroal = UnityObjectToWorldNormal(normal);
				
			}

			void frag (in float4 position : SV_POSITION,
						in float4 worldPos : TEXCOORD0,
						in float3 worldNormal : TEXCOORD1,
						out fixed4 color : SV_TARGET)
			{
				float3 viewDir = UnityWorldSpaceViewDir(worldPos.xyz));
				float3 refDir = reflect(-viewDir.xyz, worldNormal);

				fixed4 reflection = texCUBE(_Cubemap, refDir);
				color = lerp(_MainColor, ref, _Reflection);
			}
			ENDCG
		}
	}
}

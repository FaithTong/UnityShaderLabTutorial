Shader "Custom/ModifiableColor"
{
	Properties
	{
		_MainColor ("MainColor", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _MainColor;

			void vert (in float4 vertex : POSITION,
					out float4 position : SV_POSITION)
			{
				position = UnityObjectToClipPos(vertex);
			}

			void frag (out fixed4 color : SV_TARGET)
			{
				color = _MainColor;
			}
			ENDCG
		}
	}
}

Shader "Custom/Stencil-Test A"
{
	SubShader
	{
		Tags {"Queue" = "Geometry-1"}

		Pass
		{
			Stencil
			{
				Ref 1
				Comp Always
				Pass Replace
			}

			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			float4 vert (in float4 vertex : POSITION) : SV_POSITION
			{
				float4 pos = UnityObjectToClipPos(vertex);
				return pos;
			}

			void frag (out fixed4 color : SV_Target)
			{
				
			}
			ENDCG
		}
	}
}

Shader "Custom/GrabPass"
{
	Properties
	{
		_GrayScale ("Gray Scale", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags {"Queue" = "Transparent"}

		GrabPass{"_MainTex"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 grabPos : TEXCOORD0;
			};


			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);

				return o;
			}

			fixed _GrayScale;
			sampler2D _MainTex;

			half4 frag (v2f i) : SV_TARGET
			{
				half4 source = tex2Dproj(_MainTex, i.grabPos);

				half grayscale = Luminance(source.rgb);
				half4 destination = half4(grayscale, grayscale, grayscale, 1);

				return lerp(source, destination, _GrayScale);
			}
			ENDCG
		}
	}
}

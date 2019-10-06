Shader "Custom/alpha-test Transparent"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_AlphaTest("Alpha Test", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags
		{
			"Queue" = "AlphaTest"
			"RenderType" = "TrannsparentCutout"
			"IgnoreProjector" = "True"
		}

		Pass
		{
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _AlphaTest;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.texcoord);
				clip(color.a - _AlphaTest);
				return color;
			}
			ENDCG
		}
	}
}

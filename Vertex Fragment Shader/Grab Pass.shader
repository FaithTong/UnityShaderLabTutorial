Shader "Custom/GrabPass"
{
	Properties
	{
		_GrayScale ("Gray Scale", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags {"Queue" = "Transparent"}

		// 调用GrabPass，并定义抓取图像的名称
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


			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(vertex);

				//计算抓取图像在屏幕上的位置
				o.grabPos = ComputeGrabScreenPos(o.pos);

				return o;
			}

			fixed _GrayScale;

			// 声明抓取图像
			sampler2D _MainTex;

			half4 frag (v2f i) : SV_TARGET
			{
				// 采样抓取图像
				half4 source = tex2Dproj(_MainTex, i.grabPos);

				half grayscale = Luminance(source.rgb);
				half4 destination = half4(grayscale, grayscale, grayscale, 1);

				return lerp(source, destination, _GrayScale);
			}
			ENDCG
		}
	}
}

Shader "post-processing/BrightnessSaturationContrast"
{
	Properties 
	{
		_MainTex("MainTex", 2D) = "white"{}
		_Brightness("Brightness", float) = 1
		_Saturation("Saturatioon", float) = 1
		_Contrast("Contrast", float) = 1
	}

	Subshader 
	{
		Pass
		{
			Cull Off
			ZTest Always
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert_img // 使用包含文件内置的顶点着色器
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex; // 声明RenderTexture
			half _Brightness;
			half _Saturation;
			half _Contrast;

			// 将vert_img的输出结构体v2f_img输入到片段着色器
			half4 frag(v2f_img i) : SV_Target
			{
				// 使用v2f_img结构体内的纹理坐标对RenderTexture采样
				half4 renderTex = tex2D(_MainTex, i.uv);

				// 亮度
				half3 finalColor = renderTex.rgb * _Brightness;
				
				// 饱和度
				half luminance = Luminance(finalColor);
				finalColor = lerp(luminance, finalColor, _Saturation);

				// 对比度
				half3 grayColor = half3(0.5, 0.5, 0.5);
				finalColor = lerp(grayColor, finalColor, _Contrast);

				return half4(finalColor, 1);
			}
			ENDCG
		}
	}
}

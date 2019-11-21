Shader "PostEffectShader/BrightnessSaturationContrast"
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
		Tags{"RenderType" = "Opaque"}
		LOD 200

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#pragma target 3.0

			sampler2D _MainTex;
			half _Brightness;
			half _Saturation;
			half _Contrast;

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				fixed3 finalColor = renderTex.rgb * _Brightness;
			
				fixed luminance = dot(finalColor, fixed3(0.2125, 0.7154, 0.0721));
				fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
				finalColor = lerp(luminanceColor, finalColor, _Saturation);

				fixed3 grayColor = fixed3(0.5, 0.5, 0.5);
				finalColor = lerp(grayColor, finalColor, _Contrast);

				return fixed4(finalColor, renderTex.a);
			}
			ENDCG
		}
	}
	Fallback off
}

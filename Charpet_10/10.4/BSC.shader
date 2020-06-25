Shader "Hidden/BSC-HLSL"
{
    HLSLINCLUDE

        #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        // 属性声明
        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        half _Brightness;
        half _Saturation;
        half _Contrast;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            // 采样RenderTexture
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

            // 亮度
            color.rgb *= _Brightness;

            // 饱和度
            float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750));
            color.rgb = lerp(luminance, color.rgb, _Saturation);

            // 对比度
            half3 grayColor = half3(0.5, 0.5, 0.5);
            color.rgb = lerp(grayColor, color.rgb, _Contrast);

            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}

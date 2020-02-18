Shader "Samples/Dissolve"
{
    Properties
    {
        // -------------------- PBS Textures --------------------
        [Header(PBS Textures)]
        [Space(10)]
        [NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
        [NoScaleOffset]_Specular("Specular_Smoothness", 2D) = "black" {}
        [NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
        [NoScaleOffset]_AO("AO", 2D) = "white" {}

        // -------------------- Dissolve Properties --------------------
        [Header(Dissolve Properties)]
        [Space(10)]
        _Noise("Dissolve Noise", 2D) = "white" {}
        _Dissolve("Dissolve", Range(0, 1)) = 0
        [NoScaleOffset]_Gradient("Edge Gradient", 2D) = "black" {}
        _Range("Edge Range", Range(2, 100)) = 6
        _Brightness("Brightness", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags
        { 
            "RenderType"="TransparentCutout" "Queue" = "AlphaTest"
        }

        CGPROGRAM
        #pragma surface surf StandardSpecular  addshadow fullforwardshadows

        struct Input
        {
            float2 uv_Albedo;
            float2 uv_Noise;
        };

        sampler2D _Albedo;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        sampler2D _Noise;
        fixed _Dissolve;
        sampler2D _Gradient;
        float _Range;
        float _Brightness;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // Clip Mask
            fixed noise = tex2D(_Noise, IN.uv_Noise).r;
            fixed dissolve = _Dissolve * 2 - 1;
            fixed mask = saturate(noise - dissolve);
            clip(mask - 0.5);

            // Burn Effect
            fixed texcoord = saturate(mask * _Range - 0.5 * _Range);
            o.Emission = tex2D(_Gradient, fixed2(texcoord, 0.5)) * _Brightness;

            fixed4 c = tex2D (_Albedo, IN.uv_Albedo);
            o.Albedo = c.rgb;

            fixed4 specular = tex2D(_Specular, IN.uv_Albedo);
            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Albedo));

            o.Occlusion = tex2D(_AO, IN.uv_Albedo);
        }
        ENDCG
    }
}

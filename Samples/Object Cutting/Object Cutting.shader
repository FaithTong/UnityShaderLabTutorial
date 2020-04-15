Shader "Samples/Object Cutting"
{
    Properties
    {
        [Header(Textures)] [Space(10)]
        [NoScaleOffset] _Albedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset] _Reflection ("Specular_Smoothness", 2D) = "black" {}
        [NoScaleOffset] _Normal ("Normal", 2D) = "bump" {}
        [NoScaleOffset] _Occlusion ("Ambient Occlusion", 2D) = "white" {}

        [Header(Cutting)] [Space(10)]
        [KeywordEnum(X, Y, Z)] _Direction ("Cutting Direction", Float) = 1
        [Toggle] _Invert ("Invert Direction", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        Cull Off

        CGPROGRAM
        #pragma surface surf StandardSpecular addshadow fullforwardshadows

        #pragma shader_feature _DIRECTION_X _DIRECTION_Y _DIRECTION_Z
        #pragma shader_feature _INVERT_ON
        
        sampler2D _Albedo;
        sampler2D _Reflection;
        sampler2D _Normal;
        sampler2D _Occlusion;

        float3 _Position;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldPos;
        };

        void surf (Input i, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 col = tex2D(_Albedo, i.uv_Albedo);
            o.Albedo =  col.rgb;

            // 判断切割方向
            #if _DIRECTION_X
                col.a = step(_Position.x, i.worldPos.x);
            #elif _DIRECTION_Y
                col.a = step(_Position.y, i.worldPos.y);
            #else 
            col.a = step(_Position.z, i.worldPos.z);
            #endif

            // 将切割方向反转
            #if _INVERT_ON
            col.a = 1 - col.a;
            #endif

            clip(col.a - 0.001);
            
            fixed4 reflection = tex2D(_Reflection, i.uv_Albedo);
            o.Specular = reflection.rgb;
            o.Smoothness = reflection.a;

            o.Normal = UnpackNormal(tex2D(_Normal, i.uv_Albedo));

            o.Occlusion = tex2D(_Occlusion, i.uv_Albedo);
        }
        ENDCG
    }
}

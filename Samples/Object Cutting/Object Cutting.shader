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
        #pragma target 3.0

        #pragma multi_compile _DIRECTION_X _DIRECTION_Y _DIRECTION_Z
        
        sampler2D _Albedo;
        sampler2D _Reflection;
        sampler2D _Normal;
        sampler2D _Occlusion;

        float3 _Position;
        fixed _Invert;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldPos;
            fixed face : VFACE;
        };

        void surf (Input i, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 col = tex2D(_Albedo, i.uv_Albedo);
            o.Albedo =  i.face > 0 ? col.rgb : fixed3(0,0,0);

            // 判断切割方向
            #if _DIRECTION_X
                col.a = step(_Position.x, i.worldPos.x);
            #elif _DIRECTION_Y
                col.a = step(_Position.y, i.worldPos.y);
            #else 
            col.a = step(_Position.z, i.worldPos.z);
            #endif

            // 判断是否反转切割方向
            col.a = _Invert? 1 - col.a : col.a;

            clip(col.a - 0.001);
            
            fixed4 reflection = tex2D(_Reflection, i.uv_Albedo);
            o.Specular = i.face > 0 ? reflection.rgb : fixed3(0,0,0);
            o.Smoothness = i.face > 0 ? reflection.a : 0;

            o.Normal = UnpackNormal(tex2D(_Normal, i.uv_Albedo));

            o.Occlusion = tex2D(_Occlusion, i.uv_Albedo);
        }
        ENDCG
    }
}

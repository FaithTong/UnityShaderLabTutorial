Shader "Samples/Dynamic Liquid"
{
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _Specular("Specular_Smoothness", Color) = (0, 0, 0, 0)
        _Level("Liquid Level", float) = 0

        // 定义关键词枚举的名称
        [KeywordEnum(X,Z)] _Direction("Ripple Direction", float) = 0

        _Speed("Ripple Speed", float) = 1
        _Height("Ripple Height", float) = 1
    }
    SubShader
    {
        Tags{"RenderType" = "Transparent" "Queue" = "Transparent"}
        Blend DstColor SrcColor

        CGPROGRAM
        #pragma surface surf StandardSpecular noshadow

        // 定义关键词
        #pragma shader_feature _DIRECTION_X _DIRECTION_Z

        struct Input
        {
            float3 worldPos;
        };

        fixed4 _Color;
        fixed4 _Specular;
        half _Level;

        half _Speed;
        half _Height;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // 液面效果
            float3 pivot = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
            float liquid = pivot.y - IN.worldPos.y + _Level * 0.01;

            // 波纹效果
            float3 ripple = sin(_Time.y * _Speed) * _Height * IN.worldPos;

            // 根据波纹的不同方向进行判断
            #if _DIRECTION_X
            liquid += ripple.x;
            #else
            liquid += ripple.z;
            #endif

            // 像素剔除
            liquid = step(0, liquid);
            clip(liquid - 0.001);

            o.Albedo = _Color.rgb;
            o.Specular = _Specular.rgb;
            o.Smoothness = _Specular.a;
        }
        ENDCG
    }
}

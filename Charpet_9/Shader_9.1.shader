Shader "Surface Shader/Simplest Surface Shader"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM

        // 定义表面函数名为surf，使用Lambert光照模型
        #pragma surface surf Lambert

        // Input结构体
        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Color;

        // 表面函数
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

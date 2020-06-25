Shader "Surface Shader/Transparent"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Color ("Color(RGB-A)", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags{"Queue" = "Transparent"}

        CGPROGRAM

        // 添加alpha指令开启透明效果
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb * _Color.rgb;
            o.Alpha = c.a * _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

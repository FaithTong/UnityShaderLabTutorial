Shader "Surface Shader/Custom Lambert"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM

        // 声明自定义光照模型为CustomLambert
        #pragma surface surf CustomLambert

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        // 自定义光照函数
        half4 LightingCustomLambert (SurfaceOutput s, half3 lightDir, half atten)
        {
            fixed NdotL = saturate(dot(s.Normal, lightDir));

            half4 c;
            c.rgb = s.Albedo * _LightColor0 * NdotL * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

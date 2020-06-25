Shader "Surface Shader/Phong Tessellation"
{
    Properties
    {
        _MainTex ("Color", 2D) = "white" {}
        _Tessellation ("Tessellation", Range(1, 32)) = 1
        _Phong ("Phong Tessellation", Range(0, 1)) = 0.2
    }
    SubShader
    {
        CGPROGRAM

        // 声明曲面细分函数和Phong细分编译指令
        #pragma surface surf Lambert tessellate:tessellation tessphong:_Phong

        half _Tessellation;
        fixed _Phong;

        // 曲面细分函数
        float4 tessellation ()
        {
            return _Tessellation;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

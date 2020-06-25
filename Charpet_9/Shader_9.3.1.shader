Shader "Surface Shader/Vertex Modify"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Expansion ("Expansion", Range(0, 0.1)) = 0
    }
    SubShader
    {
        CGPROGRAM

        // 添加自定义顶点修函数vert
        #pragma surface surf Lambert vertex:vert

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed _Expansion;

        // 顶点修改函数，输入/输出appdata_full结构体
        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * _Expansion;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

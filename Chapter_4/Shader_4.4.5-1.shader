 Shader "Custom/In Out Struct"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // 定义顶点着色器的输入结构体
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // 定义顶点着色器的输出结构体
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            fixed4 _MainColor;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 使用结构体传入传出参数
            void vert (in appdata v, out v2f o)
            {
                o.position = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
            }

            void frag (in v2f i, out fixed4 color : SV_TARGET)
            {
                color = tex2D(_MainTex, i.texcoord) * _MainColor;
            }
            ENDCG
        }
    }
}

 Shader "Custom/Return Struct"
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            fixed4 _MainColor;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                // 声明结构体名称
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                // 返回结构体
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
                return tex2D(_MainTex, i.texcoord) * _MainColor;
            }
            ENDCG
        }
    }
}

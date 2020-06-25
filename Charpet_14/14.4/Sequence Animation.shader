Shader "Samples/Sequence Animation"
{
    Properties
    {
        [NoScaleOffset] _Tex ("Sequence Image", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _Row ("Row Amount", float) = 1
        _Column ("Column Amount", float) = 1
        _Rate ("Animation Rate", float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "DisableBatching" = "True"
        }
        Blend OneMinusDstColor One
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _Tex;
            fixed4 _Tint;
            float _Row;
            float _Column;
            float _Rate;

            v2f vert (appdata v)
            {
                v2f o;

                // ---------- Billboard 部分 ----------
                float3 forward = mul(unity_WorldToObject,
                                     float4(_WorldSpaceCameraPos, 1)).xyz;
                forward.y = 0;
                forward = normalize(forward);

                float3 up = abs(forward.y) > 0.999 ? float3(0, 0, 1) : float3(0, 1, 0);
                float3 right = normalize(cross(forward, up));
                up = normalize(cross(right, forward));

                float3 vertex = v.vertex.x * right + v.vertex.y * up;
                o.vertex = UnityObjectToClipPos(vertex);

                // ---------- 序列帧 部分 ----------

                // 计算序列帧的行索引和列索引
                float time = floor(_Time.y * _Rate);
                float row = floor(time / _Column);
                float column = fmod(time, _Column);

                // 计算序列帧的纹理坐标
                float texcoordU = (v.texcoord.x + column) / _Column;
                float texcoordV = (v.texcoord.y - 1 - row) / _Row;
                o.texcoord = float2(texcoordU, texcoordV);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return tex2D(_Tex, i.texcoord) * _Tint;
            }
            ENDCG
        }
    }
}

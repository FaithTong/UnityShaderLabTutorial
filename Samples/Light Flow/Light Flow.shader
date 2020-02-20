Shader "Samples/Light Flow"
{
    Properties
    {
        _Tex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (0, 1, 1, 1)

        // 关键词枚举，0为x方向，1为y方向
        [KeywordEnum(X,Y)] _DIRECTION("Flow Direction", float) = 0
        _Speed("Flow Speed", float) = 1
    }
    SubShader
    {
        Tags {"Type" = "Transparent" "Queue" = "Transparent"}

        Blend OneMinusDstColor One
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // 定义枚举关键词
            #pragma shader_feature _DIRECTION_X _DIRECTION_Y

            #include "unityCG.cginc"

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _Tex;
            float4 _Tex_ST;
            fixed4 _Color;
            float _Speed;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.texcoord = TRANSFORM_TEX(v.texcoord, _Tex);
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 texcoord;
                
                // 判断流动方向
                #if _DIRECTION_X
                texcoord = float2(i.texcoord.x + _Time.x * _Speed, i.texcoord.y);
                #elif _DIRECTION_Y
                texcoord = float2(i.texcoord.x, i.texcoord.y + _Time.x * _Speed);
                #endif

                return tex2D(_Tex, texcoord) * _Color;
            }
            ENDCG
        }
    }
}

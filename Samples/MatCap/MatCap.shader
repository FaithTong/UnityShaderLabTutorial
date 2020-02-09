Shader "Samples/MatCap"
{
    Properties
    {
        [NoScaleOffset]_MatCap ("MatCap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MatCap;

            v2f vert (appdata_base v)
            {
                v2f o;

                // 使用UNITY_MATRIX_MV的逆转置矩阵
                // 变换非统一缩放物体的法线向量
                o.texcoord = mul(UNITY_MATRIX_IT_MV, float4(v.normal, 1)).xy;

                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 texcoord = i.texcoord * 0.5 + 0.5;
                return tex2D(_MatCap, texcoord);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}

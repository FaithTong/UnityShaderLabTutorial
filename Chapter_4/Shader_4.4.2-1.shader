Shader "Custom/Simplest  Shader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            void vert (in float4 vertex : POSITION,
                    out float4 position : SV_POSITION)
            {
                position = UnityObjectToClipPos(vertex);
            }

            void frag (in float4 vertex : SV_POSITION,
                    out fixed4 color : SV_TARGET)
            {
                color = fixed4(1, 0, 0, 1);
            }
            ENDCG
        }
    }
}

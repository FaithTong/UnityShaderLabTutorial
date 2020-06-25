Shader "Custom/return value"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert (in float4 vertex : POSITION) : SV_POSITION
            {
                // 返回裁切空间顶点坐标
                return UnityObjectToClipPos(vertex);
            }

            fixed4 frag (in float4 vertex : SV_POSITION) : SV_TARGET
            {
                // 返回颜色值
                return fixed4(1, 0, 0, 1);
            }
            ENDCG
        }
    }
}

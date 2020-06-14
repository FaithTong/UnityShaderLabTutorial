 Shader "Custom/cginc"
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

            // 声明包含文件
            #include "UnityCG.cginc"

            fixed4 _MainColor;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 使用包含文件中的结构体传递数据
            v2f_img vert (appdata_img v)
            {
                v2f_img o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // 使用包含文件中的宏计算纹理坐标
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag (v2f_img i) : SV_TARGET
            {
                return tex2D(_MainTex, i.uv) * _MainColor;
            }
            ENDCG
        }
    }
}

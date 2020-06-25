Shader "Custom/GrabPass"
{
    Properties
    {
        _GrayScale ("Gray Scale", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags {"Queue" = "Transparent"}

        // 调用GrabPass，并定义抓取图像的名称
        GrabPass{"_ScreenTex"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 grabPos : TEXCOORD0;
            };


            v2f vert (float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);

                //计算抓取图像在屏幕上的位置
                o.grabPos = ComputeGrabScreenPos(o.pos);

                return o;
            }

            fixed _GrayScale;

            // 声明抓取图像
            sampler2D _ScreenTex;

            half4 frag (v2f i) : SV_TARGET
            {
                // 采样抓取图像
                half4 src = tex2Dproj(_ScreenTex, i.grabPos);

                half grayscale = Luminance(src.rgb);
                half4 dst = half4(grayscale, grayscale, grayscale, 1);

                return lerp(src, dst, _GrayScale);
            }
            ENDCG
        }
    }
}

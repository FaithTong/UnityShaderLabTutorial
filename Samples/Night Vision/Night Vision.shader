Shader "Hidden/Night Vision"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
	}
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                half4 screenPos : TEXCOORD1;
			};

            v2f vert (appdata_img v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.screenPos = ComputeScreenPos(o.vertex);

                return o;
			}

            sampler2D _MainTex;

            fixed _Brightness;
            fixed _Saturation;
            fixed _Contrast;

            fixed4 _Tint;

            half _VignetteFalloff;
            half _VignetteIntensity;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                // 亮度、饱和度、对比度
                color.rgb += _Brightness;

                fixed luminance = Luminance(color.rgb).xxx;
                color.rgb = lerp(luminance, color.rgb, _Saturation);

                fixed3 gray = fixed3(0.5,0.5,0.5);
                color.rgb = lerp(gray, color.rgb, _Contrast);

                // 着色
                color.rgb *= _Tint.rgb;

                // 晕影
                half circle = distance(i.screenPos.xy, fixed2(0.5,0.5));
                fixed vignette = 1 - saturate(pow(circle, _VignetteFalloff));
                color.rgb *= pow(vignette, _VignetteIntensity);

                return color;
            }
            ENDCG
        }
    }
}

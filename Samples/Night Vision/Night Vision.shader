﻿Shader "Hidden/Night Vision"
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
            half _Distortion;
            half _Intensity;

            fixed _Brightness;
            fixed _Saturation;
            fixed _Contrast;

            fixed4 _Tint;

            half _VignetteFalloff;
            half _VignetteIntensity;

            sampler2D _Noise;
            half _NoiseAmount;
            half _NoiseSpeed;
            half _RandomValue;

            fixed4 frag (v2f i) : SV_Target
            {
                // 镜头扭曲
                fixed2 center = i.uv - 0.5;
                half radius2 = pow(center.x, 2) + pow(center.y, 2);
                half distortion = 1 + sqrt(radius2) * radius2 * _Distortion;

                half2 uvColor = center * distortion * _Intensity  + 0.5;
                fixed4 screen = tex2D(_MainTex, uvColor);

                // 亮度、饱和度、对比度
                screen += _Brightness;

                fixed luminance = Luminance(screen.rgb).xxx;
                screen = lerp(luminance, screen.rgb, _Saturation);

                fixed3 gray = fixed3(0.5,0.5,0.5);
                screen = lerp(gray, screen.rgb, _Contrast);

                // 着色
                screen *= _Tint.rgb;

                // 晕影
                half circle = distance(i.screenPos.xy, fixed2(0.5,0.5));
                fixed vignette = 1 - saturate(pow(circle, _VignetteFalloff));
                screen *= pow(vignette, _VignetteIntensity);

                // 噪点颗粒
                float2 uvNoise = i.uv * _NoiseAmount;
                uvNoise.x += sin(_RandomValue);
                uvNoise.y -= sin(_RandomValue + 1);

                fixed noise = tex2D(_Noise, uvNoise).r;
                screen *= noise;

                return screen;
            }
            ENDCG
        }
    }
}

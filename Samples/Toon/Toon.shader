Shader "Samples/Toon"
{
    Properties
    {
        [Header(Diffuse)]
        [Space(10)] _Albedo ("Albedo", 2D) = "white" {}
        _Ramp ("Toon Ramp", 2D) = "white" {}

        [Header(Rim)]
        [Space(10)][HDR] _RimColor ("Rim Color", Color) = (0,2,2,1)
        _RimWidth ("Rim Width", Range(0,1)) = 0
        _RimFalloff ("Rim Falloff", Range(0.01,10)) = 1

        [Header(Outline)]
        [Space(10)] _OutlineColor ("Outline Color", Color) = (0,0,0,0)
        _OutlineWidth ("Outline, Width", Float) = 0.02

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        // ---------- Outline 部分----------
        Pass
        {
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _OutlineColor;
            half _OutlineWidth;

            float4 vert (appdata_base v) : SV_POSITION
            {
                v.vertex.xyz += v.normal * _OutlineWidth;
                return UnityObjectToClipPos(v.vertex);
            }

            float4 frag () : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }

        // ---------- Surface 部分----------
        CGPROGRAM
        #pragma surface surf Toon

        sampler2D _Albedo;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldNormal;
            float3 viewDir;
        };

        // 自定义的表面函数输出结构体
        struct SurfaceOutputToon
        {
            half3 Albedo;
            half3 Normal;
            half3 Emission;
            fixed Alpha;
            
            // 将Input结构体包含进来
            Input SurfaceInput;

            // 内置的全局照明结构体
            UnityGIInput GIdata;
        };

        void surf (Input i, inout SurfaceOutputToon o)
        {
            o.SurfaceInput = i;
            o.Albedo = tex2D(_Albedo, i.uv_Albedo);
        }

        void LightingToon_GI (inout SurfaceOutputToon s, UnityGIInput GIdata, UnityGI gi)
        {
            s.GIdata = GIdata;
        }

        sampler2D _Ramp;
        half4 _RimColor;
        fixed _RimWidth;
        half _RimFalloff;

        half4 LightingToon (SurfaceOutputToon s, UnityGI gi)
        {
            // 重新赋值，方便后续调用结构体内的变量
            UnityGIInput GIdata = s.GIdata;
            Input i = s.SurfaceInput;

            // 使用内置的UnityGI_Base()函数计算GI
            gi = UnityGI_Base(GIdata, GIdata.ambient, i.worldNormal);

            // 将光照转为Ramp
            fixed NdotL = dot(i.worldNormal, gi.light.dir);
            fixed2 rampTexcoord = float2(NdotL * 0.5 + 0.5, 0.5);
            fixed3 ramp = tex2D(_Ramp, rampTexcoord).rgb;

            // 计算漫反射
            half3 diffuse = s.Albedo * ramp * _LightColor0.rgb *
                            (GIdata.atten + gi.indirect.diffuse);

            // 计算边缘高光
            fixed NdotV = dot(i.worldNormal , i.viewDir);
            fixed rimMask = pow((1.0 - saturate((NdotV + _RimWidth))), _RimFalloff);
            half3 rim = saturate(rimMask * NdotL) * _RimColor *
                        _LightColor0.rgb * GIdata.atten;

            // 输出漫反射与边缘高光的和
            return half4(diffuse + rim, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

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

        // ---------- 正常部分----------
        

        sampler2D _Albedo;
        sampler2D _Ramp;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldNormal;
            float3 worldPos;
        };

        struct SurfaceOutputToon
        {
            half3 Albedo;
            half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
            Input SurfaceInput;
            UnityGIInput GIData;
        };

        half4 _RimColor;
        fixed _RimWidth;
        half _RimFalloff;

        float4 LightingToon (inout SurfaceOutputToon s, half3 viewDir, half3 lightDir, UnityGI gi)
        {
            UnityGIInput data = s.GIData;
            Input i = s.SurfaceInput;

            #ifdef UNITY_PASS_FORWARDBASE
            float atten = data.atten;
            if( _LightColor0.a == 0)
			atten = 0;
            #endif

            fixed NdotL = dot(s.Normal, lightDir);
            fixed2 rampTexcoord = (NdotL*0.5+0.5).xx;
            
            fixed ramp = tex2D(_Ramp, rampTexcoord);
            
            gi = UnityGI_Base(data, 1, i.worldNormal);
            float3 indirDiffuse = gi.indirect.diffuse;

			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i_worldPos ) );
            fixed NdotV = dot(i.worldNormal, worldViewDir);

            fixed4 diffuse = tex2D(_Albedo, i.uv_Albedo) * ramp * _LightColor0 * (atten + indirDiffuse);


            fixed rimMask = power(1 - saturate(NdotV + _RimWidth), _RimFalloff);
            float4 rim = saturate(NdotL * rimMask) * _RimColor * _LightColor0 * atten;

            float4 c;
            c.rgb += diffuse.rgb + rim.rgb;
            c.a = o.Alpha;
            return c;
        }

        void LightingToon_GI (inout SurfaceOutputToon s, UnityGIInput data, inout UnityGI gi)
        {
            s.GIData = data;
        }

        void surf (Input IN, inout SurfaceOutputToon o)
        {
            o.SurfaceInput = IN;
        }
        ENDCG


    }
    FallBack "Diffuse"
}

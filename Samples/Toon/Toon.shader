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
        CGPROGRAM
        #pragma surface surf Toon

        sampler2D _Albedo;
        sampler2D _Ramp;

        struct Input
        {
            float2 uv_Albedo;
            float3 worldNormal;
            INTERNAL_DATA

            float3 worldPos;
        };

        struct SurfaceOutputToon
        {
            half3 Albedo;
            half3 Normal;
            half3 Emission;
            fixed Alpha;
            Input SurfaceInput;
            UnityGIInput GIData;
        };

        half4 _RimColor;
        fixed _RimWidth;
        half _RimFalloff;

        half4 LightingToon ( inout SurfaceOutputToon s, half3 viewDir, UnityGI gi )
        {
            UnityGIInput data = s.GIData;
            Input i = s.SurfaceInput;

            half4 c = 0;
            
            float3 worldlightDir = normalize( UnityWorldSpaceLightDir( i.worldPos ) );
            float NdotL = dot( i.worldNormal , worldlightDir );
            float2 rampTexcoord = ((NdotL*0.5 + 0.5)).xx;
            
            UnityGI gi11 = gi;
            gi11 = UnityGI_Base( data, 1, i.worldNormal );
            float3 indirectDiffuse11 = gi11.indirect.diffuse + i.worldNormal * 0.0001;
            float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
            float NdotV = dot( i.worldNormal , worldViewDir );
            float rimMask = pow((1.0 - saturate( ( NdotV + _RimWidth ))), _RimFalloff );
            c.rgb = ( ( tex2D( _Albedo, i.uv_Albedo ) * tex2D( _Ramp, rampTexcoord ) * ( _LightColor0 * float4( ( data.atten + indirectDiffuse11 ) , 0.0 ) ) ) + ( _RimColor * saturate( ( NdotL * rimMask ) ) * _LightColor0 * data.atten ) ).rgb;
            c.a = 1;
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

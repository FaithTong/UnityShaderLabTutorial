Shader "Samples/X-Ray"
{
    Properties
    {
        [Header(The Blocked Part)]
        [Space(10)]
        _Color("Occlusion Color", Color) = (0,1,1,1)
        _Width("Occlusion Width", Range(0, 10)) = 1
        _Intensity("Occlusion Intensity",Range(0, 10)) = 1

        [Header(The Normal Part)]
        [Space(10)]
        _Albedo("Albedo", 2D) = "white"{}
        [NoScaleOffset]_Specular("Specular (RGB-A)", 2D) = "black"{}
        [NoScaleOffset]_Normal("Nromal", 2D) = "bump"{}
        [NoScaleOffset]_AO("AO", 2D) = "white"{}
    }
    SubShader
    {
        Tags{"Queue" = "Transparent"}

        //---------- The Blocked Part ----------
        Pass
        {
            ZTest Greater
            ZWrite Off

            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 worldPos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float3 worldNor : TEXCOORD1;
            };

            fixed4 _Color;
            fixed _Width;
            half _Intensity;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.worldPos = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.worldNor = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                half NDotV = saturate( dot(i.worldNor, i.viewDir));
                NDotV = pow(1 - NDotV, _Width) * _Intensity;

                fixed4 color;
                color.rgb = _Color.rgb;
                color.a = NDotV;
                return color;
            }
            ENDCG
        }

        //---------- The Normal Part ----------
        CGPROGRAM
        #pragma surface surf StandardSpecular
        #pragma target 3.0

        struct Input
        {
            float2 uv_Albedo;
        };

        sampler2D _Albedo;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = tex2D(_Albedo, IN.uv_Albedo).rgb;

            fixed4 specular = tex2D(_Specular, IN.uv_Albedo);
            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Albedo));
        }
        ENDCG
    }
}

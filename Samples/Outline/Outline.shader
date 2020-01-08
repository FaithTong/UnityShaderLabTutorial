Shader "Samples/Outline"
{
    Properties
    {
        [Header(Texture Group)]
        [Space(10)]
        _Albedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_Specular ("Specular (RGB-A)", 2D) = "black" {}
        [NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}
        [NoScaleOffset]_AO ("Ambient Occlusion", 2D) = "white" {}

        [Header(Outline Properties)]
        [Space(10)]
        _OutlineColor ("Outline Color", Color) = (1,0,1,1)
        _OutlineWidth ("Outline Width", Range(0, 0.1)) = 0.01
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry+1"}

        //---------- Outline Layer ----------
        Pass
        {
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            fixed4 _OutlineColor;
            fixed _OutlineWidth;

            v2f vert(appdata_base v)
            {
                v2f o;
                v.vertex.xyz += v.normal * _OutlineWidth;
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }

        //---------- Regular Layer ----------
        CGPROGRAM
        #pragma surface surf StandardSpecular fullforwardshadows

        struct Input
        {
            float2 uv_Albedo;
        };

        sampler2D _Albedo;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 c = tex2D (_Albedo, IN.uv_Albedo);
            o.Albedo = c.rgb;

            fixed4 specular = tex2D (_Specular, IN.uv_Albedo);
            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

            o.Normal = UnpackNormal(tex2D (_Normal, IN.uv_Albedo));
            o.Occlusion = tex2D (_AO, IN.uv_Albedo);
        }

        ENDCG
    }
}

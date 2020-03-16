Shader "Samples/Billboard"
{
    Properties
    {
        [NoScaleOffset] _Tex ("Texture", 2D) = "white" {}
        _Tint ("Tine", Color) = (1, 1, 1, 1)
        [KeywordEnum(Spherical, Cylindrical)] _Type ("Type", float) = 0
    }
    SubShader
    {
        Tags {"RenderType" = "Transparent" "Queue" = "Transparent"}
        ZWrite Off
        Blend One One

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _TYPE_SPHERICAL _TYPE_CYLINDRICAL
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _Tex;
            fixed4 _Tint;

            v2f vert (appdata v)
            {
                v2f o;

                float3 forward = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;

                #if _TYPE_CYLINDRICAL
                forward.y = 0;
                #endif

                forward = normalize(forward);
                float3 up = abs(forward.y) > 0.999 ? float3(0, 0, 1) : float3(0, 1, 0);
                float3 right = normalize(cross(forward, up));
                up = normalize(cross(right, forward));

                float3 vertex = v.vertex.x * right + v.vertex.y * up;

                o.vertex = UnityObjectToClipPos(vertex);
                o.texcoord = v.texcoord;

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return tex2D(_Tex, i.texcoord) * _Tint;
            }
            ENDCG
        }
    }
}
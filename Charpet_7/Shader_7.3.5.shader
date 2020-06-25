Shader "Custom/Blending Transparent"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _MainColor ("MainColor(RGB_A)", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        // 设置渲染标签
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}

            // 设置渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbasse
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
                float2 texcoord : TEXCOORD1;
                float3 worldNromal : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                float3 worldNromal = UnityObjectToWorldNormal(v.normal);
                o.worldNromal = normalize(worldNromal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos.xyz);
                worldLight = normalize(worldLight);

                fixed NdotL = saturate(dot(i.worldNromal, worldLight));

                fixed4 color = tex2D(_MainTex, i.texcoord);

                color.rgb *= _MainColor.rgb * NdotL * _LightColor0;
                color.rgb += unity_AmbientSky;

                // 通过_MainColor属性的a分量控制透明度
                color.a *= _MainColor.a;

                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

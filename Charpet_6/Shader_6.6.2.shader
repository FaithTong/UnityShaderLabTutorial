Shader "Custom/Blinn-Phong"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        _SpecularColor ("Specular Color", Color) = (0, 0, 0, 0)
        _Shininess ("Shininess", Range(1, 100)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 color : COLOR0;
            };

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            half _Shininess;		

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // 计算公式中的所有变量
                fixed3 n = normalize(v.normal);
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 view = normalize(WorldSpaceViewDir(v.vertex));
                fixed3 h = normalize(view + l);

                // 漫反射部分
                fixed ndotl = saturate(dot(n, l));
                fixed4 dif = _LightColor0 * _MainColor * ndotl;

                // 镜面反射部分
                fixed ndoth = saturate(dot(n, h));
                fixed4 spec = _LightColor0 * _SpecularColor * pow(ndoth, _Shininess);

                // 环境光+漫反射+镜面反射
                o.color = unity_AmbientSky + dif + spec;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
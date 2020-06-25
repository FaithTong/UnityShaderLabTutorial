Shader "Samples/Tri-Planar Mapping"
{
    Properties
    {
        _Tiling ("Tiling", float) = 1
        [NoScaleOffset]_Albedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}
        _Bumpiness ("Bumpiness", Range(0.01, 10)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert fullforwardshadows
        
        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
            INTERNAL_DATA
        };

        float _Tiling;
        sampler2D _Albedo;
        sampler2D _Normal;
        half _Bumpiness;

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 texCoord = IN.worldPos * _Tiling;

            // -------------------- Mask --------------------
            float3 normal = abs(WorldNormalVector(IN, o.Normal));
            fixed maskX = saturate(dot(normal, fixed3(1, 0, 0)));
            fixed maskY = saturate(dot(normal, fixed3(0, 1, 0)));

            // -------------------- Albedo --------------------
            fixed4 colorXY = tex2D (_Albedo, texCoord.xy);
            fixed4 colorYZ = tex2D (_Albedo, texCoord.yz);
            fixed4 colorXZ = tex2D (_Albedo, texCoord.xz);

            fixed4 c;
            c = lerp(colorXY, colorYZ, maskX);
            c = lerp(c, colorXZ, maskY);

            o.Albedo = c.rgb;

            // -------------------- Normal --------------------
            fixed3 normalXY = UnpackNormal(tex2D(_Normal, texCoord.xy));
            fixed3 normalYZ = UnpackNormal(tex2D(_Normal, texCoord.yz));
            fixed3 normalXZ = UnpackNormal(tex2D(_Normal, texCoord.xz));

            fixed3 n;
            n = lerp(normalXY, normalYZ, maskX);
            n = lerp(n, normalXZ, maskY);

            o.Normal = n * half3(_Bumpiness, _Bumpiness, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

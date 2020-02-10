Shader "Custom/Dissolve Shader"
{
    Properties
    {
		_NoiseTex("Noise", 2D) = "white"{}
		_RampTex("Ramp", 2D) = "black"{}
		_Dissolve("Dissolve", Range(0, 1)) = 0
		_Emission("Emission", float) = 1

        _MainTex("Albedo", 2D) = "white"{}
		_Specular("Specular", 2D) = "black"{}
		_Normal("Normal", 2D) = "bump"{}
		_AO("AO", 2D) = "white"{}
    }
    SubShader
    {
        Tags
		{ 
			"RenderType"="Opaque"
			"Queue" = "AlphaTest"
		}

        LOD 200

        CGPROGRAM
        #pragma surface surf StandardSpecular  addshadow fullforwardshadows

        #pragma target 3.0

		sampler2D _NoiseTex;
		sampler2D _RampTex;
		fixed _Dissolve;
		float _Emission;

        sampler2D _MainTex;
		sampler2D _Specular;
		sampler2D _Normal;
		sampler2D _AO;


        struct Input
        {
            float2 uv_MainTex;
			float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
			fixed Noise = tex2D(_NoiseTex, IN.uv_NoiseTex).r;
			fixed dissolve = _Dissolve * 2 - 1;
			clip(Noise - dissolve - 0.5);

			fixed border = 1 - saturate(saturate(((Noise - dissolve)) * 8 - 4));
			o.Emission = tex2D(_RampTex, fixed2(border, 0.5)) * _Emission;

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

			fixed4 specular = tex2D(_Specular, IN.uv_MainTex);

            o.Specular = specular.rgb;
            o.Smoothness = specular.a;

			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));

			o.Occlusion = tex2D(_AO, IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/Puddle"
{
	Properties
	{
		[Header(Color Properties)]
		_MainTex ("Main Texture", 2D) = "gray" {}

		// 波纹属性
		[Space(20)]
		[Header(Ripple Properties)]
		_Normal ("Normal", 2D) = "bump" {}
		_NormalIntensity ("Normal Intensity", Range(0, 1)) = 0
		_NormalSpeedX ("Normal Speed X", Range(0,1)) = 0
		_NormalSpeedY ("Normal Speed Y", Range(0,1)) = 0

		// 水坑属性
		[Space(20]
		[Header(Puddle Properties)]
		[NoScaleOffset]_NormalMask ("Normal Mask", 2D) = "white" {}
		_Depth ("Depth", Range(0, 1)) = 0

		// 反射属性
		[Space(20)]
		[Header(reflection Properties)]
		[NoScaleOffset]_Cubemap ("Cubemap", Cube) = "" {}
		_Reflection ("Reflection", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags {"Queue" = "Geometry"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;

				float4 mainnormalCoord : TEXCOORD0; // 颜色和法线的纹理坐标
				float2 maskCoord : TEXCOORD1; // Mask的纹理坐标

				float4 worldPos : TEXCOORD2; // 世界空间顶点坐标
				float3 worldNormal : TEXCOORD3; // 世界空间法线坐标
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _Normal;
			float4 _Normal_ST;
			fixed _NormalIntensity;
			fixed _NormalSpeedX;
			fixed _NormalSpeedY;

			sampler2D _NormalMask;
			fixed _Depth;

			samplerCUBE _Cubemap;
			fixed _Reflection;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex.xyz);

				// 计算贴图的纹理坐标
				o.mainnormalCoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.mainnormalCoord.zw = TRANSFORM_TEX(v.texcoord, _Normal);
				o.mainnormalCoord.zw += float2(_NormalSpeedX, _NormalSpeedY) * _Time.x;
				o.maskCoord = v.texcoord.xy;

				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// 计算法线强度
				fixed2 normal = UnpackNormal(tex2D(_Normal, i.mainnormalCoord.zw)).xy;
				fixed mask = tex2D(_NormalMask, i.maskCoord);
				normal *= _NormalIntensity * mask * 0.01;

				// 计算颜色
				float2 mainCoord = i.mainnormalCoord.xy + normal;
				fixed4 color = tex2D(_MainTex, mainCoord);
				color.rgb -= (mask * _Depth);

				// 计算反射
				float3 viewDir = UnityWorldSpaceViewDir(i.worldPos.xyz);
				viewDir = normalize(viewDir);
				fixed3 refDir = reflect(-viewDir.xyz, i.worldNormal);
				fixed4 ref = texCUBE(_Cubemap, refDir);

				// 颜色与反射混合
				return lerp(color, ref, mask * _Reflection);
			}
			ENDCG
		}
	}
}

Shader "Custom/Shadow Shader"
{
	Properties
	{
		_MainColor ("Main Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 vertex : TEXCOORD1;
				SHADOW_COORDS(2) // 使用预定义宏保存阴影坐标
			};

			fixed4 _MainColor;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.vertex = v.vertex;
				TRANSFER_SHADOW(o) // 使用预定义宏变换阴影坐标

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// 准备变量
				float3 n = UnityObjectToWorldNormal(i.normal);
				n = normalize(n);
				float3 l = WorldSpaceLightDir(i.vertex);
				l = normalize(l);
				float4 worldPos = mul(unity_ObjectToWorld, i.vertex);

				// Lambert光照
				fixed ndotl = saturate(dot(n, l));
				fixed4 color = _LightColor0 * _MainColor * ndotl;

				// 加上4个点光源的光照
				color.rgb += Shade4PointLights(
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb,
				unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, worldPos.rgb, n) * _MainColor;

				// 加上环境光照
				color += unity_AmbientSky;
				
				// 使用预定义宏计算阴影系数
				UNITY_LIGHT_ATTENUATION(shadowmask, i, worldPos.rgb)

				// 阴影合成
				color.rgb *= shadowmask;

				return color;
			}
			ENDCG
		}

		// -------- 为其他灯光产生投影 --------
		Pass
		{
			Tags{"LightMode" = "ForwardAdd"}
			Blend One One // 与上一个Pass完全混合

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd_fullshadows
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 vertex : TEXCOORD1;
				SHADOW_COORDS(2) // 使用预定义宏保存阴影坐标
			};

			fixed4 _MainColor;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.vertex = v.vertex;
				TRANSFER_SHADOW(o) // 使用预定义宏变换阴影坐标

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// 准备变量
				float3 n = UnityObjectToWorldNormal(i.normal);
				n = normalize(n);
				float3 l = WorldSpaceLightDir(i.vertex);
				l = normalize(l);
				float4 worldPos = mul(unity_ObjectToWorld, i.vertex);

				// Lambert光照
				fixed ndotl = saturate(dot(n, l));
				fixed4 color = _LightColor0 * _MainColor * ndotl;

				// 加上4个点光源的光照
				color.rgb += Shade4PointLights(
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb,
				unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, worldPos.rgb, n) * _MainColor;

				// 使用预定义宏计算阴影系数
				UNITY_LIGHT_ATTENUATION(shadowmask, i, worldPos.rgb)

				// 阴影合成
				color.rgb *= shadowmask;

				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Tri-Planar Mapping_ASE"
{
	Properties
	{
		_Tiling("Tiling", Float) = 1
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		_Bumpiness("Bumpiness", Range( 0.01 , 10)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float _Bumpiness;
		uniform float _Tiling;
		uniform sampler2D _Albedo;

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_4_0 = ( ase_worldPos * _Tiling );
			float2 texcoord_XY57 = (temp_output_4_0).xy;
			float2 texcoord_YZ59 = (temp_output_4_0).yz;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_25_0 = abs( ase_worldNormal );
			float dotResult26 = dot( temp_output_25_0 , float3(1,0,0) );
			float maskX35 = dotResult26;
			float3 lerpResult46 = lerp( UnpackScaleNormal( tex2D( _Normal, texcoord_XY57 ), _Bumpiness ) , UnpackScaleNormal( tex2D( _Normal, texcoord_YZ59 ), _Bumpiness ) , maskX35);
			float2 texcoord_XZ60 = (temp_output_4_0).xz;
			float dotResult28 = dot( temp_output_25_0 , float3(0,1,0) );
			float maskY37 = dotResult28;
			float3 lerpResult49 = lerp( lerpResult46 , UnpackScaleNormal( tex2D( _Normal, texcoord_XZ60 ), _Bumpiness ) , maskY37);
			o.Normal = lerpResult49;
			float4 lerpResult21 = lerp( tex2D( _Albedo, texcoord_XY57 ) , tex2D( _Albedo, texcoord_YZ59 ) , maskX35);
			float4 lerpResult22 = lerp( lerpResult21 , tex2D( _Albedo, texcoord_XZ60 ) , maskY37);
			o.Albedo = lerpResult22.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
0;6;1920;1023;3604.906;395.5324;2.055614;True;False
Node;AmplifyShaderEditor.CommentaryNode;58;-2859.569,-46.19662;Inherit;False;860.1636;400.0002;TexCoord;9;5;3;4;13;14;11;57;59;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-2809.569,87.80371;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-2771.569,237.8036;Inherit;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;False;0;1;1.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2853.387,402.3202;Inherit;False;871.8575;466.0151;Mask;8;37;28;35;29;26;27;25;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2589.571,87.80371;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;30;-2803.387,455.1339;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;13;-2383.572,81.80371;Inherit;False;FLOAT2;1;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;14;-2382.572,164.8037;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;25;-2579.868,456.309;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;27;-2613.892,556.5625;Inherit;False;Constant;_X;X;1;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-2213.559,82.71625;Inherit;False;texcoord_YZ;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2213.559,168.7163;Inherit;False;texcoord_XZ;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;11;-2385.572,3.80336;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-2212.405,3.89238;Inherit;False;texcoord_XY;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-1622.145,921.1782;Inherit;False;59;texcoord_YZ;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1624.048,999.5708;Inherit;False;60;texcoord_XZ;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1711.572,1099.603;Inherit;False;Property;_Bumpiness;Bumpiness;3;0;Create;True;0;0;False;0;1;10;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;50;-1658.769,624.5656;Inherit;True;Property;_Normal;Normal;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;f5453dca2ac649e4182c56a3966ad395;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1618.363,291.2578;Inherit;False;59;texcoord_YZ;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1620.266,369.6505;Inherit;False;60;texcoord_XZ;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;26;-2348.745,460.6742;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1655.864,0.6558925;Inherit;True;Property;_Albedo;Albedo;1;1;[NoScaleOffset];Create;True;0;0;False;0;None;c68296334e691ed45b62266cbc716628;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector3Node;29;-2612.578,702.5022;Inherit;False;Constant;_Y;Y;1;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1616.035,208.5011;Inherit;False;57;texcoord_XY;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1619.817,838.4214;Inherit;False;57;texcoord_XY;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-1224.317,406.7924;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-1222.307,827.8728;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1224.317,208.7927;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2195.41,452.3203;Inherit;False;maskX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-1222.307,1025.874;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;28;-2350.409,653.1263;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-2194.629,647.4373;Inherit;False;maskY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;31;-881.5644,118.3149;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;-1221.04,630.1968;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;43;-880.3571,854.4017;Inherit;False;35;maskX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1223.05,11.11656;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;36;-870.0394,207.5842;Inherit;False;35;maskX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;44;-879.5546,737.3951;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;45;-816.3875,1009.626;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;39;-779.8735,361.2661;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;46;-699.4992,634.384;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;32;-545.7569,131.6771;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;48;-556.0748,763.0849;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-617.777,866.7487;Inherit;False;37;maskY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-567.3943,226.0946;Inherit;False;37;maskY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-676.8538,12.2219;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;-384.0905,9.246107;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;49;-403.6541,634.4902;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-151.0126,6.163778;Float;False;True;2;ASEMaterialInspector;0;0;Lambert;Samples/Tri-Planar Mapping_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;13;0;4;0
WireConnection;14;0;4;0
WireConnection;25;0;30;0
WireConnection;59;0;13;0
WireConnection;60;0;14;0
WireConnection;11;0;4;0
WireConnection;57;0;11;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;20;0;16;0
WireConnection;20;1;63;0
WireConnection;41;0;50;0
WireConnection;41;1;65;0
WireConnection;41;5;56;0
WireConnection;19;0;16;0
WireConnection;19;1;62;0
WireConnection;35;0;26;0
WireConnection;40;0;50;0
WireConnection;40;1;66;0
WireConnection;40;5;56;0
WireConnection;28;0;25;0
WireConnection;28;1;29;0
WireConnection;37;0;28;0
WireConnection;31;0;19;0
WireConnection;42;0;50;0
WireConnection;42;1;64;0
WireConnection;42;5;56;0
WireConnection;17;0;16;0
WireConnection;17;1;61;0
WireConnection;44;0;41;0
WireConnection;45;0;40;0
WireConnection;39;0;20;0
WireConnection;46;0;42;0
WireConnection;46;1;44;0
WireConnection;46;2;43;0
WireConnection;32;0;39;0
WireConnection;48;0;45;0
WireConnection;21;0;17;0
WireConnection;21;1;31;0
WireConnection;21;2;36;0
WireConnection;22;0;21;0
WireConnection;22;1;32;0
WireConnection;22;2;38;0
WireConnection;49;0;46;0
WireConnection;49;1;48;0
WireConnection;49;2;47;0
WireConnection;0;0;22;0
WireConnection;0;1;49;0
ASEEND*/
//CHKSM=E96E3ED534BDF38988DBD0C2EDF75A60012171A1
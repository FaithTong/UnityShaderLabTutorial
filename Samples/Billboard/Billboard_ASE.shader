// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Billboard_ASE"
{
	Properties
	{
		[NoScaleOffset]_Texture("Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)
		[KeywordEnum(Spherical,Cylindrical)] _Type("Type", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend OneMinusDstColor One
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature_local _TYPE_SPHERICAL _TYPE_CYLINDRICAL


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _Texture;
			uniform float4 _Tint;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 worldToObj11 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float3 appendResult20 = (float3(worldToObj11.x , 0.0 , worldToObj11.z));
				#if defined(_TYPE_SPHERICAL)
				float3 staticSwitch18 = worldToObj11;
				#elif defined(_TYPE_CYLINDRICAL)
				float3 staticSwitch18 = appendResult20;
				#else
				float3 staticSwitch18 = worldToObj11;
				#endif
				float3 normalizeResult15 = normalize( staticSwitch18 );
				float3 Forward28 = normalizeResult15;
				float3 _Vector1 = float3(0,1,0);
				float3 ifLocalVar17 = 0;
				if( abs( (Forward28).y ) <= 0.999 )
				ifLocalVar17 = _Vector1;
				else
				ifLocalVar17 = float3(0,0,1);
				float3 normalizeResult47 = normalize( cross( Forward28 , ifLocalVar17 ) );
				float3 Right34 = normalizeResult47;
				float3 normalizeResult48 = normalize( cross( Right34 , Forward28 ) );
				float3 Up37 = normalizeResult48;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( (v.vertex.xyz).x * Right34 ) + ( (v.vertex.xyz).y * Up37 ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 uv_Texture50 = i.ase_texcoord.xy;
				
				
				finalColor = ( tex2D( _Texture, uv_Texture50 ) * _Tint );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
0;6;1920;1023;2217.866;146.7608;1.334794;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-1630.649,-235.1213;Inherit;False;1282.334;258.4194;Forward Vector;6;28;15;20;18;11;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;2;-1580.649,-181.1213;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;11;-1335.649,-185.1213;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1092.316,-106.7019;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;18;-929.3159,-186.702;Inherit;False;Property;_Type;Type;2;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;Spherical;Cylindrical;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;15;-691.3158,-182.702;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-543.802,-189.102;Inherit;False;Forward;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1629.652,36.27511;Inherit;False;1280.569;495.9248;Right Vector;9;34;47;14;17;25;23;24;22;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1579.652,86.51923;Inherit;False;28;Forward;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-1389.166,158.4193;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;24;-1346.5,379.0003;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;23;-1346.5,235.0001;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;25;-1194.378,163.7469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;17;-1050.5,163.9999;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0.999;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;14;-871.6996,96.89989;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;47;-700.4393,96.9556;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1630.558,548.4423;Inherit;False;733.0153;213;Up Vector;5;37;48;32;33;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-538.8821,91.27509;Inherit;False;Right;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1580.558,598.4422;Inherit;False;34;Right;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-1580.558,678.4421;Inherit;False;28;Forward;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;32;-1403.242,624.9174;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;48;-1239.726,624.2109;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;39;-1588.8,934.9399;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1089.543,618.8156;Inherit;False;Up;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;41;-1388.8,981.9399;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-1388.8,883.9399;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-793.7612,746.3718;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-881.2693,550.058;Inherit;True;Property;_Texture;Texture;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;1e6b17a344389264e97cd237f3e639d9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1164.8,967.9401;Inherit;False;34;Right;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1162.8,1088.939;Inherit;False;37;Up;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-571.2693,657.058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-992.8007,1027.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-993.8005,889.9399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;51;-628.5549,951.7861;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-822.8014,960.9401;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-547.5944,935.7391;Float;False;True;-1;2;ASEMaterialInspector;100;1;Samples/Billboard_ASE;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;5;4;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;0;1;True;False;;0
WireConnection;11;0;2;0
WireConnection;20;0;11;1
WireConnection;20;2;11;3
WireConnection;18;1;11;0
WireConnection;18;0;20;0
WireConnection;15;0;18;0
WireConnection;28;0;15;0
WireConnection;22;0;29;0
WireConnection;25;0;22;0
WireConnection;17;0;25;0
WireConnection;17;2;23;0
WireConnection;17;3;24;0
WireConnection;17;4;24;0
WireConnection;14;0;29;0
WireConnection;14;1;17;0
WireConnection;47;0;14;0
WireConnection;34;0;47;0
WireConnection;32;0;35;0
WireConnection;32;1;33;0
WireConnection;48;0;32;0
WireConnection;37;0;48;0
WireConnection;41;0;39;0
WireConnection;40;0;39;0
WireConnection;49;0;50;0
WireConnection;49;1;13;0
WireConnection;44;0;41;0
WireConnection;44;1;45;0
WireConnection;42;0;40;0
WireConnection;42;1;43;0
WireConnection;51;0;49;0
WireConnection;46;0;42;0
WireConnection;46;1;44;0
WireConnection;1;0;51;0
WireConnection;1;1;46;0
ASEEND*/
//CHKSM=79D2494CE2679638756D4A9CE6822734CD4B8AD6
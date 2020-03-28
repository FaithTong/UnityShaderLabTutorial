// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Sequence Animation_ASE"
{
	Properties
	{
		[NoScaleOffset]_SequenceImage("Sequence Image", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)
		_Row("Row", Float) = 2
		_Column("Column", Float) = 2
		_AnimationRate("Animation Rate", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="True" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend OneMinusDstColor One
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _SequenceImage;
			uniform float _Column;
			uniform float _AnimationRate;
			uniform float _Row;
			uniform float4 _Tint;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				//Calculate new billboard vertex position and normal;
				float3 upCamVec = float3( 0, 1, 0 );
				float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
				float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
				float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
				v.ase_normal = normalize( mul( float4( v.ase_normal , 0 ), rotationCamMatrix )).xyz;
				//This unfortunately must be made to take non-uniform scaling into account;
				//Transform to world coords, apply rotation and transform back to local;
				v.vertex = mul( v.vertex , unity_ObjectToWorld );
				v.vertex = mul( v.vertex , rotationCamMatrix );
				v.vertex = mul( v.vertex , unity_WorldToObject );
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = 0;
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
				float mulTime11 = _Time.y * _AnimationRate;
				float Time43 = floor( mulTime11 );
				float fmodResult32 = frac(Time43/_Column)*_Column;
				float2 appendResult36 = (float2(( ( i.ase_texcoord.xy.x / _Column ) + ( fmodResult32 / _Column ) ) , ( ( i.ase_texcoord.xy.y / _Row ) - ( ( floor( ( Time43 / _Column ) ) + 1.0 ) / _Row ) )));
				
				
				finalColor = ( tex2D( _SequenceImage, appendResult36 ) * _Tint );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
0;0;1920;1029;2123.754;507.3596;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;46;-1400,-467.5;Inherit;False;677.2461;133.1404;Time;4;43;30;11;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1376,-417.5;Inherit;False;Property;_AnimationRate;Animation Rate;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1206,-412.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;30;-1039.754,-412.3596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1553.754,50.5;Inherit;False;829;360.1404;V;9;35;23;38;29;42;15;17;18;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-921.7539,-417.3596;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1540.754,307.6404;Inherit;False;43;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1532,-27.5;Inherit;False;Property;_Column;Column;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-1369,312.5;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1396.754,-321.3596;Inherit;False;673;362.8596;U;6;32;34;39;28;47;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FloorOpNode;17;-1247,312.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1375.754,-128.3596;Inherit;False;43;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;32;-1184.754,-122.3596;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-1123.754,312.6404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;47;-1193.754,-271.3596;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-1192,100.5;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1137,222.5;Inherit;False;Property;_Row;Row;2;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-985,-246.5;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-978.7539,311.6404;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;39;-984.7539,-122.3596;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-977,202.5;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-855.7539,254.6404;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-843.7539,-196.3596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-665.7539,-15.3596;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-442,143.5;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-529,-44.5;Inherit;True;Property;_SequenceImage;Sequence Image;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BillboardNode;14;-418,314.5;Inherit;False;Cylindrical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-205,-40.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-57,-41;Float;False;True;-1;2;ASEMaterialInspector;100;1;Custom/Sequence Animation_ASE;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;5;4;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;DisableBatching=True;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;11;0;13;0
WireConnection;30;0;11;0
WireConnection;43;0;30;0
WireConnection;18;0;44;0
WireConnection;18;1;16;0
WireConnection;17;0;18;0
WireConnection;32;0;45;0
WireConnection;32;1;16;0
WireConnection;42;0;17;0
WireConnection;28;0;47;1
WireConnection;28;1;16;0
WireConnection;38;0;42;0
WireConnection;38;1;15;0
WireConnection;39;0;32;0
WireConnection;39;1;16;0
WireConnection;23;0;29;2
WireConnection;23;1;15;0
WireConnection;35;0;23;0
WireConnection;35;1;38;0
WireConnection;34;0;28;0
WireConnection;34;1;39;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;9;1;36;0
WireConnection;10;0;9;0
WireConnection;10;1;6;0
WireConnection;1;0;10;0
WireConnection;1;1;14;0
ASEEND*/
//CHKSM=9A3D19DB68E69B6EAD011692E1EEC3CB8920A59F
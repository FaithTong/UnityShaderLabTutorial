// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Dynamic Liquid_ASE"
{
	Properties
	{
		_Color("Color", Color) = (0.4396583,0.9811321,0.9575117,0)
		_Specular_Smoothness("Specular_Smoothness", Color) = (0,0,0,0)
		_LiquidLevel("Liquid Level", Float) = 1
		[KeywordEnum(X,Z)] _RippleDirection("Ripple Direction", Float) = 0
		_RippleSpeed("Ripple Speed", Float) = 1
		_RippleHeight("Ripple Height", Float) = 0.5
		_Cutoff( "Mask Clip Value", Float ) = 0.01
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend DstColor SrcColor
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RIPPLEDIRECTION_X _RIPPLEDIRECTION_Z
		#pragma surface surf StandardSpecular keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform float4 _Specular_Smoothness;
		uniform float _RippleHeight;
		uniform float _RippleSpeed;
		uniform float _LiquidLevel;
		uniform float _Cutoff = 0.01;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Albedo = _Color.rgb;
			o.Specular = _Specular_Smoothness.rgb;
			o.Smoothness = _Specular_Smoothness.a;
			o.Alpha = 1;
			float4 transform25 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float4 temp_output_5_0 = ( transform25 - float4( ase_worldPos , 0.0 ) );
			float mulTime2 = _Time.y * _RippleSpeed;
			float4 temp_output_113_0 = step( float4( 0,0,0,0 ) , ( ( (temp_output_5_0).y + ( temp_output_5_0 * _RippleHeight * sin( mulTime2 ) ) ) + ( _LiquidLevel / 100.0 ) ) );
			#if defined(_RIPPLEDIRECTION_X)
				float staticSwitch105 = (temp_output_113_0).x;
			#elif defined(_RIPPLEDIRECTION_Z)
				float staticSwitch105 = (temp_output_113_0).z;
			#else
				float staticSwitch105 = (temp_output_113_0).x;
			#endif
			clip( staticSwitch105 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
14;18;1906;1011;638.997;862.5056;1.3;False;False
Node;AmplifyShaderEditor.CommentaryNode;119;-244.7954,-557.6581;Inherit;False;1102.367;482.9223;Dynamic Liquid;12;118;117;9;4;10;5;3;6;25;8;2;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-175.7754,-157.5359;Float;False;Property;_RippleSpeed;Ripple Speed;4;0;Create;True;0;0;False;0;1;8.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-7.775497,-153.5359;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-183.4262,-320.1447;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;-194.7954,-502.5911;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;113.2784,-277.0115;Float;False;Property;_RippleHeight;Ripple Height;5;0;Create;True;0;0;False;0;0.5;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;184.2242,-153.5359;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;65.57174,-425.1443;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;337.6642,-507.6582;Inherit;True;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;371.5711,-311.1447;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;638.572,-432.1443;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;11.20766,27.98087;Float;False;Property;_LiquidLevel;Liquid Level;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;826.9759,-188.2578;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;110;206.4361,34.24297;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;118;370.1116,-114.8085;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;419.3663,11.73576;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;-1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;113;591.3514,-12.94792;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;103;759.3574,28.47051;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;760.3485,-50.56631;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;105;982.1859,-30.23865;Inherit;False;Property;_RippleDirection;Ripple Direction;3;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;2;X;Z;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;106;919.0565,-346.1645;Inherit;False;Property;_Specular_Smoothness;Specular_Smoothness;1;0;Create;True;0;0;False;0;0,0,0,0;0.245283,0.18483,0.05437878,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;76;922.2639,-552.4756;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.4396583,0.9811321,0.9575117,0;0.894,0.191316,0.4021213,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;98;1231.913,-415.7706;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dynamic Liquid_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.01;True;False;0;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;7;2;False;-1;3;False;-1;0;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;6;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.04;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;5;0;25;0
WireConnection;5;1;8;0
WireConnection;10;0;5;0
WireConnection;4;0;5;0
WireConnection;4;1;6;0
WireConnection;4;2;3;0
WireConnection;9;0;10;0
WireConnection;9;1;4;0
WireConnection;117;0;9;0
WireConnection;110;0;13;0
WireConnection;118;0;117;0
WireConnection;26;0;118;0
WireConnection;26;1;110;0
WireConnection;113;1;26;0
WireConnection;103;0;113;0
WireConnection;33;0;113;0
WireConnection;105;1;33;0
WireConnection;105;0;103;0
WireConnection;98;0;76;0
WireConnection;98;3;106;0
WireConnection;98;4;106;4
WireConnection;98;10;105;0
ASEEND*/
//CHKSM=6D0C28533954BEAAB69AF56F08593640F5ACE7F7
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
		uniform float _LiquidLevel;
		uniform float _RippleSpeed;
		uniform float _RippleHeight;
		uniform float _Cutoff = 0.01;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Albedo = _Color.rgb;
			o.Specular = _Specular_Smoothness.rgb;
			o.Smoothness = _Specular_Smoothness.a;
			o.Alpha = 1;
			float4 transform25 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float Liquid139 = ( ( transform25.y - ase_worldPos.y ) + ( _LiquidLevel / 100.0 ) );
			float mulTime124 = _Time.y * _RippleSpeed;
			float3 Ripple140 = ( ase_worldPos * ( sin( mulTime124 ) * _RippleHeight ) );
			float3 temp_output_138_0 = ( Liquid139 + Ripple140 );
			#if defined(_RIPPLEDIRECTION_X)
				float staticSwitch105 = (temp_output_138_0).x;
			#elif defined(_RIPPLEDIRECTION_Z)
				float staticSwitch105 = (temp_output_138_0).z;
			#else
				float staticSwitch105 = (temp_output_138_0).x;
			#endif
			clip( step( 0.0 , staticSwitch105 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
0;0;1920;1029;471.751;971.927;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;144;-82.87497,-514.8999;Inherit;False;1005.406;350.8276;Ripple;8;140;4;137;6;127;124;1;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-32.87492,-326.1965;Float;False;Property;_RippleSpeed;Ripple Speed;4;0;Create;True;0;0;False;0;1;8.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;78.19611,-999.3275;Inherit;False;839.1482;475.7414;Liquid;7;139;9;13;25;8;5;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;124;121.1258,-321.1965;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;241.3042,-245.808;Float;False;Property;_RippleHeight;Ripple Height;5;0;Create;True;0;0;False;0;0.5;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;245.5797,-628.9267;Float;False;Property;_LiquidLevel;Liquid Level;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;127;282.045,-321.4204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;128.1962,-949.3278;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;8;137.6654,-775.3823;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;137;382.7997,-464.9;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;422.0445,-302.4203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;357.0632,-850.2813;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;110;440.2083,-625.2647;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;602.344,-729.9517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;586.4959,-391.2411;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;728.6835,-397.0103;Inherit;False;Ripple;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;726.33,-734.8212;Inherit;False;Liquid;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;155.3393,-103.4838;Inherit;False;139;Liquid;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;160.3393,-21.4838;Inherit;False;140;Ripple;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;329.3393,-74.48383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;475.8,-149.5;Inherit;True;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;103;475.8,42.50001;Inherit;True;False;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;105;730.6656,-59.3087;Inherit;False;Property;_RippleDirection;Ripple Direction;3;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;2;X;Z;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;106;941.5203,-375.8823;Inherit;False;Property;_Specular_Smoothness;Specular_Smoothness;1;0;Create;True;0;0;False;0;0,0,0,0;0.245283,0.18483,0.05437878,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;76;947.2869,-561.6471;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.4396583,0.9811321,0.9575117,0;0.894,0.191316,0.4021213,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;113;961.1319,-78.71803;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;98;1219.913,-442.7706;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dynamic Liquid_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.01;True;False;0;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;7;2;False;-1;3;False;-1;0;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;6;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.04;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;124;0;1;0
WireConnection;127;0;124;0
WireConnection;126;0;127;0
WireConnection;126;1;6;0
WireConnection;5;0;25;2
WireConnection;5;1;8;2
WireConnection;110;0;13;0
WireConnection;9;0;5;0
WireConnection;9;1;110;0
WireConnection;4;0;137;0
WireConnection;4;1;126;0
WireConnection;140;0;4;0
WireConnection;139;0;9;0
WireConnection;138;0;141;0
WireConnection;138;1;142;0
WireConnection;33;0;138;0
WireConnection;103;0;138;0
WireConnection;105;1;33;0
WireConnection;105;0;103;0
WireConnection;113;1;105;0
WireConnection;98;0;76;0
WireConnection;98;3;106;0
WireConnection;98;4;106;4
WireConnection;98;10;113;0
ASEEND*/
//CHKSM=2496451CC181F25326CDEAF9B5250EF286BF3B7A
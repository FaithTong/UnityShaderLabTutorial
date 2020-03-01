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
		uniform float _RippleSpeed;
		uniform float _RippleHeight;
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
			float temp_output_24_0 = saturate( ( ( ( (temp_output_5_0).y + ( temp_output_5_0 * sin( mulTime2 ) * _RippleHeight ) ) + ( _LiquidLevel - 1.0 ) ) / 0.001 ) );
			#if defined(_RIPPLEDIRECTION_X)
				float staticSwitch105 = temp_output_24_0;
			#elif defined(_RIPPLEDIRECTION_Z)
				float staticSwitch105 = temp_output_24_0;
			#else
				float staticSwitch105 = temp_output_24_0;
			#endif
			clip( staticSwitch105 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
214;73;1428;665;2044.034;531.9533;3.197153;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-1057.033,207.9163;Float;False;Property;_RippleSpeed;Ripple Speed;4;0;Create;True;0;0;False;0;1;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-1121.032,28.91632;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;-1137.401,-153.5306;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-872.9109,214.1047;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-704.3261,302.0496;Float;False;Property;_RippleHeight;Ripple Height;5;0;Create;True;0;0;False;0;0.5;-0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-784.033,-114.0837;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;3;-688.033,214.9163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-439.0334,45.9163;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-439.9402,-105.5976;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-215.1452,164.9236;Float;False;Property;_LiquidLevel;Liquid Level;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-33.40162,170.4694;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-152.0326,-105.0837;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;139.1716,190.3213;Float;False;Constant;_Falloff;Falloff;5;0;Create;True;0;0;False;0;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;123.5983,-108.5306;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;-1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;361.4918,-1.732147;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;24;504.4457,7.138203;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;678.0227,-21.95369;Inherit;False;True;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;103;677.0315,57.08321;Inherit;False;False;False;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;880.4775,-483.6257;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.4396583,0.9811321,0.9575117,0;1,0.3160377,0.9942691,0.4470588;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;106;885.8599,-312.626;Inherit;False;Property;_Specular_Smoothness;Specular_Smoothness;1;0;Create;True;0;0;False;0;0,0,0,0;0.2358491,0.2358491,0.2358491,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;105;940.8599,-0.6259766;Inherit;True;Property;_RippleDirection;Ripple Direction;3;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;2;X;Z;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;98;1265.3,-377.8993;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dynamic Liquid_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.01;True;False;0;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;7;2;False;-1;3;False;-1;0;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;6;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.04;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;5;0;25;0
WireConnection;5;1;8;0
WireConnection;3;0;2;0
WireConnection;4;0;5;0
WireConnection;4;1;3;0
WireConnection;4;2;6;0
WireConnection;10;0;5;0
WireConnection;28;0;13;0
WireConnection;9;0;10;0
WireConnection;9;1;4;0
WireConnection;26;0;9;0
WireConnection;26;1;28;0
WireConnection;14;0;26;0
WireConnection;14;1;16;0
WireConnection;24;0;14;0
WireConnection;33;0;24;0
WireConnection;103;0;24;0
WireConnection;105;1;33;0
WireConnection;105;0;103;0
WireConnection;98;0;76;0
WireConnection;98;3;106;0
WireConnection;98;4;106;4
WireConnection;98;10;105;0
ASEEND*/
//CHKSM=D25D6670BF29111B655E2BAE6E384C4B289C8E3C
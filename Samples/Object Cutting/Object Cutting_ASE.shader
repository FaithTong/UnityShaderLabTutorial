// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Object Cutting_ASE"
{
	Properties
	{
		[NoScaleOffset][Header(Textures)][Space(10)]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Specular_Smoothness("Specular_Smoothness", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		[Header(Cutting)][Space(10)][KeywordEnum(X,Y,Z)] _CuttingDirection("Cutting Direction", Float) = 0
		[HideInInspector]_Position("Position", Vector) = (0,0,0,0)
		[Toggle]_InvertDIrection("Invert DIrection", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.001
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _CUTTINGDIRECTION_X _CUTTINGDIRECTION_Y _CUTTINGDIRECTION_Z
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform sampler2D _Specular_Smoothness;
		uniform sampler2D _AmbientOcclusion;
		uniform float _InvertDIrection;
		uniform float3 _Position;
		uniform float _Cutoff = 0.001;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal9 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal9 ) );
			float2 uv_Albedo8 = i.uv_texcoord;
			o.Albedo = tex2D( _Albedo, uv_Albedo8 ).rgb;
			float2 uv_Specular_Smoothness10 = i.uv_texcoord;
			float4 tex2DNode10 = tex2D( _Specular_Smoothness, uv_Specular_Smoothness10 );
			o.Specular = tex2DNode10.rgb;
			o.Smoothness = tex2DNode10.a;
			float2 uv_AmbientOcclusion11 = i.uv_texcoord;
			o.Occlusion = tex2D( _AmbientOcclusion, uv_AmbientOcclusion11 ).r;
			o.Alpha = 1;
			#if defined(_CUTTINGDIRECTION_X)
				float staticSwitch16 = _Position.x;
			#elif defined(_CUTTINGDIRECTION_Y)
				float staticSwitch16 = _Position.y;
			#elif defined(_CUTTINGDIRECTION_Z)
				float staticSwitch16 = _Position.z;
			#else
				float staticSwitch16 = _Position.x;
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(_CUTTINGDIRECTION_X)
				float staticSwitch17 = ase_worldPos.x;
			#elif defined(_CUTTINGDIRECTION_Y)
				float staticSwitch17 = ase_worldPos.y;
			#elif defined(_CUTTINGDIRECTION_Z)
				float staticSwitch17 = ase_worldPos.z;
			#else
				float staticSwitch17 = ase_worldPos.x;
			#endif
			float2 _value = float2(0,1);
			float ifLocalVar13 = 0;
			if( staticSwitch16 <= staticSwitch17 )
				ifLocalVar13 = _value.y;
			else
				ifLocalVar13 = _value.x;
			clip( (( _InvertDIrection )?( ( 1.0 - ifLocalVar13 ) ):( ifLocalVar13 )) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1920;1029;2104.244;288.774;1.3;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-1192.579,470.6976;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;14;-1227.579,311.6977;Inherit;False;Property;_Position;Position;5;1;[HideInInspector];Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;17;-995.579,488.6976;Inherit;False;Property;_Keyword0;Keyword 0;4;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;3;X;Y;Z;Reference;16;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-962.5791,617.6973;Inherit;False;Constant;_value;value;7;0;Create;True;0;0;False;0;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;16;-1041.579,334.6978;Inherit;False;Property;_CuttingDirection;Cutting Direction;4;0;Create;True;0;0;False;2;Header(Cutting);Space(10);0;0;0;True;;KeywordEnum;3;X;Y;Z;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;13;-723.579,489.6978;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-523.579,559.6976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-434.4001,-99.10003;Inherit;True;Property;_Normal;Normal;2;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-434.948,90.32421;Inherit;True;Property;_Specular_Smoothness;Specular_Smoothness;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-435.0244,279.4399;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;20;-349.5792,483.6978;Inherit;False;Property;_InvertDIrection;Invert DIrection;6;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-435.9737,-293.0412;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;False;2;Header(Textures);Space(10);-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;7;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Object Cutting_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.001;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;7;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;1;12;1
WireConnection;17;0;12;2
WireConnection;17;2;12;3
WireConnection;16;1;14;1
WireConnection;16;0;14;2
WireConnection;16;2;14;3
WireConnection;13;0;16;0
WireConnection;13;1;17;0
WireConnection;13;2;18;1
WireConnection;13;3;18;2
WireConnection;13;4;18;2
WireConnection;21;0;13;0
WireConnection;20;0;13;0
WireConnection;20;1;21;0
WireConnection;7;0;8;0
WireConnection;7;1;9;0
WireConnection;7;3;10;0
WireConnection;7;4;10;4
WireConnection;7;5;11;0
WireConnection;7;10;20;0
ASEEND*/
//CHKSM=D761159523507B6A98DD372AD0E243547658B6ED
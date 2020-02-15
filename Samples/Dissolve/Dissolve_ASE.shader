// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Samples/Dissolve_ASE"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Specular_Smoothness("Specular_Smoothness", 2D) = "black" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_AO("AO", 2D) = "white" {}
		_DissolveNoise("Dissolve Noise", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[NoScaleOffset]_EdgeGradient("Edge Gradient", 2D) = "black" {}
		_EdgeRange("Edge Range", Range( 2 , 100)) = 10
		_Brightness("Brightness", Range( 0 , 10)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform sampler2D _EdgeGradient;
		uniform sampler2D _DissolveNoise;
		uniform float4 _DissolveNoise_ST;
		uniform float _Dissolve;
		uniform float _EdgeRange;
		uniform float _Brightness;
		uniform sampler2D _Specular_Smoothness;
		uniform sampler2D _AO;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal131 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal131 ) );
			float2 uv_Albedo78 = i.uv_texcoord;
			o.Albedo = tex2D( _Albedo, uv_Albedo78 ).rgb;
			float2 uv_DissolveNoise = i.uv_texcoord * _DissolveNoise_ST.xy + _DissolveNoise_ST.zw;
			float ClipMask134 = saturate( ( tex2D( _DissolveNoise, uv_DissolveNoise ).r - (_Dissolve*2.0 + -1.0) ) );
			float2 temp_cast_1 = (saturate( (ClipMask134*_EdgeRange + ( _EdgeRange * -0.5 )) )).xx;
			o.Emission = ( tex2D( _EdgeGradient, temp_cast_1 ) * _Brightness ).rgb;
			float2 uv_Specular_Smoothness140 = i.uv_texcoord;
			float4 tex2DNode140 = tex2D( _Specular_Smoothness, uv_Specular_Smoothness140 );
			o.Specular = tex2DNode140.rgb;
			o.Smoothness = tex2DNode140.a;
			float2 uv_AO139 = i.uv_texcoord;
			o.Occlusion = tex2D( _AO, uv_AO139 ).r;
			o.Alpha = 1;
			clip( ClipMask134 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
0;6;1920;1023;1808.103;288.1266;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;145;-1250.107,-256.8468;Inherit;False;1050;412;Clip Mask;6;134;142;141;133;2;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1218.107,1.152576;Float;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;False;0;0;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;133;-930.1061,1.152576;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1218.107,-206.8467;Inherit;True;Property;_DissolveNoise;Dissolve Noise;4;0;Create;True;0;0;False;0;-1;5af962d54400e5a4eb74cebb60dbe3a5;5af962d54400e5a4eb74cebb60dbe3a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;141;-706.1064,-174.8467;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;142;-562.1064,-174.8467;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-1416.926,181.0026;Inherit;False;1222;326.1213;Dissolve Edge;8;148;151;136;137;138;143;114;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-424.1066,-180.8467;Inherit;False;ClipMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-1394.413,357.6067;Inherit;False;Property;_EdgeRange;Edge Range;7;0;Create;True;0;0;False;0;10;7.1;2;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-1190.926,230.8447;Inherit;False;134;ClipMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1105.103,395.8734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;151;-1135.034,345.6749;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;137;-973.926,257.8447;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;8;False;2;FLOAT;-4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;-785.926,257.8447;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-653.8062,229.0026;Inherit;True;Property;_EdgeGradient;Edge Gradient;6;1;[NoScaleOffset];Create;True;0;0;False;0;-1;7ff563100950c2241acae4cd12ed908d;7ff563100950c2241acae4cd12ed908d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;143;-625.6595,422.1237;Inherit;False;Property;_Brightness;Brightness;8;0;Create;True;0;0;False;0;0;0.87;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;144;-162.1903,-279.4872;Inherit;False;339.365;912.0745;Textures;5;135;139;140;131;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;78;-128.4165,-229.4871;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;cc7fd9f2dbb0739409bde66b9ce45fa6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;-128.4165,-37.48717;Inherit;True;Property;_Normal;Normal;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;b1355a406b9846049adcdd135e0f6ce7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;140;-128.4165,154.5128;Inherit;True;Property;_Specular_Smoothness;Specular_Smoothness;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;0c990365c2c53aa4093e01c6d55160fd;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;139;-128.4165,346.5127;Inherit;True;Property;_AO;AO;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;671d54a8eea59b840b55dfb969e610f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;135;-3.112951,539.3205;Inherit;False;134;ClipMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-340.927,232.8448;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;300.6459,-7.286041;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dissolve_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;9;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;133;0;4;0
WireConnection;141;0;2;1
WireConnection;141;1;133;0
WireConnection;142;0;141;0
WireConnection;134;0;142;0
WireConnection;152;0;148;0
WireConnection;151;0;148;0
WireConnection;137;0;136;0
WireConnection;137;1;151;0
WireConnection;137;2;152;0
WireConnection;138;0;137;0
WireConnection;114;1;138;0
WireConnection;126;0;114;0
WireConnection;126;1;143;0
WireConnection;0;0;78;0
WireConnection;0;1;131;0
WireConnection;0;2;126;0
WireConnection;0;3;140;0
WireConnection;0;4;140;4
WireConnection;0;5;139;1
WireConnection;0;10;135;0
ASEEND*/
//CHKSM=CDC439EA241C1EB96A8809DC16AAFF8998A2DACB
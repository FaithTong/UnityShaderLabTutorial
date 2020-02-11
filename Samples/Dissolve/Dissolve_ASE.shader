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
			float Clip134 = saturate( ( tex2D( _DissolveNoise, uv_DissolveNoise ).r - (_Dissolve*2.0 + -1.0) ) );
			float2 temp_cast_1 = (saturate( (Clip134*_EdgeRange + ( _EdgeRange / -2.0 )) )).xx;
			o.Emission = ( tex2D( _EdgeGradient, temp_cast_1 ) * _Brightness ).rgb;
			float2 uv_Specular_Smoothness140 = i.uv_texcoord;
			float4 tex2DNode140 = tex2D( _Specular_Smoothness, uv_Specular_Smoothness140 );
			o.Specular = tex2DNode140.rgb;
			o.Smoothness = tex2DNode140.a;
			float2 uv_AO139 = i.uv_texcoord;
			o.Occlusion = tex2D( _AO, uv_AO139 ).r;
			o.Alpha = 1;
			clip( Clip134 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
0;0;1920;1029;1996.946;213.7025;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;145;-1250.107,-256.8468;Inherit;False;1050;412;Clip Mask;6;134;142;141;133;2;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1218.107,1.152576;Float;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1218.107,-206.8467;Inherit;True;Property;_DissolveNoise;Dissolve Noise;4;0;Create;True;0;0;False;0;-1;None;5af962d54400e5a4eb74cebb60dbe3a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;133;-930.1061,1.152576;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;141;-706.1064,-174.8467;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;142;-562.1064,-174.8467;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;146;-1479.926,181.0026;Inherit;False;1285;325.1213;Dissolve Edge;9;148;151;149;126;114;143;138;137;136;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-1456.413,346.6067;Inherit;False;Property;_EdgeRange;Edge Range;7;0;Create;True;0;0;False;0;10;7.1;2;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-424.1066,-180.8467;Inherit;False;Clip;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-1399.926,254.8447;Inherit;False;134;Clip;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;151;-1202.034,332.6749;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;149;-1163.413,348.6067;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;137;-1031.926,257.8447;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;8;False;2;FLOAT;-4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;-844.926,259.8447;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-704.8062,231.0026;Inherit;True;Property;_EdgeGradient;Edge Gradient;6;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;7ff563100950c2241acae4cd12ed908d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;143;-682.6595,422.1237;Inherit;False;Property;_Brightness;Brightness;8;0;Create;True;0;0;False;0;0;0.8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;144;-178.4165,-279.4872;Inherit;False;361;835;Textures;4;78;131;140;139;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-356.927,234.8448;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;195.6582,475.7679;Inherit;False;134;Clip;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;131;-128.4165,-37.48717;Inherit;True;Property;_Normal;Normal;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;b1355a406b9846049adcdd135e0f6ce7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;147;196.723,90.91972;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;140;-128.4165,154.5128;Inherit;True;Property;_Specular_Smoothness;Specular_Smoothness;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;0c990365c2c53aa4093e01c6d55160fd;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;139;-128.4165,346.5127;Inherit;True;Property;_AO;AO;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;671d54a8eea59b840b55dfb969e610f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-128.4165,-229.4871;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;cc7fd9f2dbb0739409bde66b9ce45fa6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;398.003,-51.90813;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Samples/Dissolve_ASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;9;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;133;0;4;0
WireConnection;141;0;2;1
WireConnection;141;1;133;0
WireConnection;142;0;141;0
WireConnection;134;0;142;0
WireConnection;151;0;148;0
WireConnection;149;0;148;0
WireConnection;137;0;136;0
WireConnection;137;1;151;0
WireConnection;137;2;149;0
WireConnection;138;0;137;0
WireConnection;114;1;138;0
WireConnection;126;0;114;0
WireConnection;126;1;143;0
WireConnection;147;0;126;0
WireConnection;0;0;78;0
WireConnection;0;1;131;0
WireConnection;0;2;147;0
WireConnection;0;3;140;0
WireConnection;0;4;140;4
WireConnection;0;5;139;1
WireConnection;0;10;135;0
ASEEND*/
//CHKSM=E84D73122101AADFDD308E3C9051D0964A7C8738
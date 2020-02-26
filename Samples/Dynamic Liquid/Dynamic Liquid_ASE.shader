// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShader/Water"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.01
		_Color_Alpha("Color_Alpha", Color) = (0.4396583,0.9811321,0.9575117,0)
		_Speed("Speed", Float) = 1
		_Size("Size", Float) = 0.5
		_Height("Height", Float) = 1
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Reflaction("Reflaction", Float) = 0.15
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+1" "IgnoreProjector" = "True" }
		Cull Off
		Blend One OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#pragma surface surf Standard keepalpha finalcolor:RefractionF noshadow exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float4 _Color_Alpha;
		uniform float _Speed;
		uniform float _Size;
		uniform float _Height;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _Reflaction;
		uniform float _Cutoff = 0.01;

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			color.rgb = color.rgb + Refraction( i, o, _Reflaction, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			o.Albedo = _Color_Alpha.rgb;
			o.Smoothness = 1.0;
			o.Alpha = _Color_Alpha.a;
			float4 transform25 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float4 temp_output_5_0 = ( transform25 - float4( ase_worldPos , 0.0 ) );
			float mulTime2 = _Time.y * _Speed;
			clip( (saturate( ( ( ( (temp_output_5_0).y + ( temp_output_5_0 * sin( mulTime2 ) * _Size ) ) + ( _Height - 1.0 ) ) / 0.001 ) )).x - _Cutoff );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
632;327;1211;779;2094.167;984.4164;2.520065;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-746.3397,196.8771;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-810.3395,17.87708;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;-826.7086,-164.5698;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-562.2175,203.0655;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-473.3398,-125.1229;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-393.6328,291.0103;Float;False;Property;_Size;Size;3;0;Create;True;0;0;False;0;0.5;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;-377.3398,203.8771;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-129.2472,-116.6368;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-128.3403,34.87707;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;125.5477,155.8844;Float;False;Property;_Height;Height;4;0;Create;True;0;0;False;0;1;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;158.6602,-116.1229;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;277.2912,159.4302;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;434.2911,-119.5698;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;-1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;590.8644,206.2821;Float;False;Constant;_Falloff;Falloff;5;0;Create;True;0;0;False;0;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;774.1849,-18.77139;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;24;1036.016,-20.26233;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;1206.593,-34.35422;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;880.4775,-483.6257;Inherit;False;Property;_Color_Alpha;Color_Alpha;1;0;Create;True;0;0;False;0;0.4396583,0.9811321,0.9575117,0;0.05727127,0.2086152,0.3679245,0.2392157;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;1264.268,-195.1045;Inherit;False;Property;_Reflaction;Reflaction;7;0;Create;True;0;0;False;0;0.15;1.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;1298.655,-368.4568;Inherit;False;Constant;_Amoothness;Amoothness;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;98;1465.3,-461.8993;Float;False;True;2;ASEMaterialInspector;0;0;Standard;MyShader/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.01;True;False;1;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;3;1;False;-1;10;False;-1;0;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;5;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.04;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;5;0;25;0
WireConnection;5;1;8;0
WireConnection;3;0;2;0
WireConnection;10;0;5;0
WireConnection;4;0;5;0
WireConnection;4;1;3;0
WireConnection;4;2;6;0
WireConnection;9;0;10;0
WireConnection;9;1;4;0
WireConnection;28;0;13;0
WireConnection;26;0;9;0
WireConnection;26;1;28;0
WireConnection;14;0;26;0
WireConnection;14;1;16;0
WireConnection;24;0;14;0
WireConnection;33;0;24;0
WireConnection;98;0;76;0
WireConnection;98;4;101;0
WireConnection;98;8;102;0
WireConnection;98;9;76;4
WireConnection;98;10;33;0
ASEEND*/
//CHKSM=F8B5D764DD0CBD72A9A1C5740621D7FC2C4354B2
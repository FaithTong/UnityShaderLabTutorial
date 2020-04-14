// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Night Vision_ASE"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Distortion("Distortion", Float) = 1
		_Scale("Scale", Float) = 0.31
		_Brightness("Brightness", Float) = 1
		_Saturation("Saturation", Float) = 1
		_Contrast("Contrast", Float) = 1
		_Tint("Tint", Color) = (1,1,1,1)
		_VignetteIntensity("VignetteIntensity", Float) = 1
		_VignetteFalloff("VignetteFalloff", Float) = 1
		_Noise("Noise", 2D) = "white" {}
		_NoiseAmount("NoiseAmount", Float) = 1
		_RandomValue("RandomValue", Float) = 1

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _Noise;
			uniform float _NoiseAmount;
			uniform float _RandomValue;
			uniform float _Contrast;
			uniform float _Distortion;
			uniform float _Scale;
			uniform float _Brightness;
			uniform float _Saturation;
			uniform float4 _Tint;
			uniform float _VignetteFalloff;
			uniform float _VignetteIntensity;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 temp_output_77_0 = ( i.uv.xy * _NoiseAmount );
				float2 appendResult93 = (float2(( (temp_output_77_0).x + sin( _RandomValue ) ) , ( (temp_output_77_0).y - sin( ( _RandomValue + 1.0 ) ) )));
				float2 temp_output_26_0 = ( i.uv.xy - float2( 0.5,0.5 ) );
				float2 temp_output_31_0 = pow( temp_output_26_0 , 2.0 );
				float temp_output_30_0 = ( (temp_output_31_0).x + (temp_output_31_0).y );
				float Warp_Distortion45 = ( ( sqrt( temp_output_30_0 ) * temp_output_30_0 * _Distortion ) + 1.0 );
				float4 ScreenWarp48 = tex2D( _MainTex, ( ( temp_output_26_0 * Warp_Distortion45 * _Scale ) + float2( 0.5,0.5 ) ) );
				float4 temp_output_97_0 = ( ScreenWarp48 + _Brightness );
				float grayscale99 = Luminance(temp_output_97_0.rgb);
				float4 temp_cast_1 = (grayscale99).xxxx;
				float4 lerpResult100 = lerp( temp_cast_1 , temp_output_97_0 , _Saturation);
				float4 ImageAdjust66 = ( CalculateContrast(_Contrast,lerpResult100) * _Tint );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 Vignette74 = ( ImageAdjust66 * pow( ( 1.0 - saturate( pow( distance( (ase_screenPosNorm).xy , float2( 0.5,0.5 ) ) , _VignetteFalloff ) ) ) , _VignetteIntensity ) );
				

				finalColor = ( tex2D( _Noise, appendResult93 ) * Vignette74 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17800
0;6;1920;1023;2075.676;-517.0558;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;47;-1492.6,299.8724;Inherit;False;1531.099;488.6302;Screen Warp;18;37;45;35;32;34;30;87;88;31;38;25;26;44;40;39;46;48;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;25;-1473.1,506.5001;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-1249.1,506.5001;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;31;-1064.127,415.8724;Inherit;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;88;-904.3524,454.6798;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;87;-905.3524,374.6798;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-762.6451,398.8138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-640.9741,469.2336;Inherit;False;Property;_Distortion;Distortion;0;0;Create;True;0;0;False;0;1;7.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;32;-620.5573,358.0189;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-482.6453,372.8138;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-336.6451,372.8138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-203.1111,367.2726;Inherit;False;Warp_Distortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1319.566,634.2592;Inherit;False;45;Warp_Distortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1269.699,710.9222;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;False;0;0.31;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1065.839,616.5363;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;44;-785.1238,565.8389;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-896.3118,617.3436;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-636.9177,588.5621;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;6b2910686f14f5844bf4707db2d5e2ba;6b2910686f14f5844bf4707db2d5e2ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-301.7304,588.2835;Inherit;False;ScreenWarp;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1490.231,816;Inherit;False;1532.231;301.1462;Image Adjust;11;66;63;64;62;61;49;51;55;97;99;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;73;-1491.774,1135.893;Inherit;False;1532.744;313.4244;Vignette;12;72;70;69;71;74;23;68;22;21;20;19;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1444.131,982.1831;Inherit;False;Property;_Brightness;Brightness;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-1470.231,897.0834;Inherit;False;48;ScreenWarp;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1269.498,924.583;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;18;-1467.931,1257.788;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-1085.769,984.146;Inherit;False;Property;_Saturation;Saturation;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;99;-1118.676,866.0558;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;20;-1285.334,1258.136;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;19;-1109.306,1263.217;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-887.769,989.146;Inherit;False;Property;_Contrast;Contrast;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;100;-902.676,871.0558;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1146.534,1363.536;Inherit;False;Property;_VignetteFalloff;VignetteFalloff;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1489.53,1467.328;Inherit;False;1522.726;444.2883;Noise;16;81;80;79;82;14;95;75;94;91;93;90;77;78;89;85;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;21;-957.2325,1263.836;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;55;-719.769,870.1463;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;3.36;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;64;-529.769,936.1462;Inherit;False;Property;_Tint;Tint;5;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-318.769,869.1463;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1425.131,1731.826;Inherit;False;Property;_RandomValue;RandomValue;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;-801.2299,1263.193;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;76;-1470.567,1517.328;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;-1447.055,1638.435;Inherit;False;Property;_NoiseAmount;NoiseAmount;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-665.5798,1263.558;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-1234.131,1812.826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-148,864;Inherit;False;ImageAdjust;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1255.427,1569.88;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-709.2299,1338.193;Inherit;False;Property;_VignetteIntensity;VignetteIntensity;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;79;-1104.131,1736.826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;70;-498.2301,1264.193;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-531.2301,1187.193;Inherit;False;66;ImageAdjust;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;85;-1116.331,1565.126;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;82;-1104.131,1811.826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;89;-1116.65,1659.615;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-316.2301,1193.193;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-888.6501,1569.615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;91;-903.6501,1664.615;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-164.1921,1188.867;Inherit;False;Vignette;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-745.6501,1600.615;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;94;-604.6501,1571.615;Inherit;True;Property;_Noise;Noise;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;75;-481.2582,1769.906;Inherit;False;74;Vignette;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-288.6779,1575.56;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;14;-146.2152,1576.51;Float;False;True;-1;2;ASEMaterialInspector;0;2;Hidden/Night Vision_ASE;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;26;0;25;0
WireConnection;31;0;26;0
WireConnection;88;0;31;0
WireConnection;87;0;31;0
WireConnection;30;0;87;0
WireConnection;30;1;88;0
WireConnection;32;0;30;0
WireConnection;34;0;32;0
WireConnection;34;1;30;0
WireConnection;34;2;35;0
WireConnection;37;0;34;0
WireConnection;45;0;37;0
WireConnection;38;0;26;0
WireConnection;38;1;46;0
WireConnection;38;2;39;0
WireConnection;40;0;38;0
WireConnection;24;0;44;0
WireConnection;24;1;40;0
WireConnection;48;0;24;0
WireConnection;97;0;49;0
WireConnection;97;1;51;0
WireConnection;99;0;97;0
WireConnection;20;0;18;0
WireConnection;19;0;20;0
WireConnection;100;0;99;0
WireConnection;100;1;97;0
WireConnection;100;2;61;0
WireConnection;21;0;19;0
WireConnection;21;1;22;0
WireConnection;55;1;100;0
WireConnection;55;0;62;0
WireConnection;63;0;55;0
WireConnection;63;1;64;0
WireConnection;68;0;21;0
WireConnection;23;0;68;0
WireConnection;81;0;80;0
WireConnection;66;0;63;0
WireConnection;77;0;76;0
WireConnection;77;1;78;0
WireConnection;79;0;80;0
WireConnection;70;0;23;0
WireConnection;70;1;72;0
WireConnection;85;0;77;0
WireConnection;82;0;81;0
WireConnection;89;0;77;0
WireConnection;71;0;69;0
WireConnection;71;1;70;0
WireConnection;90;0;85;0
WireConnection;90;1;79;0
WireConnection;91;0;89;0
WireConnection;91;1;82;0
WireConnection;74;0;71;0
WireConnection;93;0;90;0
WireConnection;93;1;91;0
WireConnection;94;1;93;0
WireConnection;95;0;94;0
WireConnection;95;1;75;0
WireConnection;14;0;95;0
ASEEND*/
//CHKSM=A2E22EE7259F8B44302E18E5B07D5575E642A90E
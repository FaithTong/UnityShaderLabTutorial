Shader "Custom/Custom Material Inspector"
{
	Properties
	{
		// 在材质面板插入一行标题
		[Header(Custom Material Inspector)]

		// 在材质面板插入一行空行，多用于区分不同类属性
		[Space]

		_MainTex ("Main Tex", 2D) = "white" {}

		// 在材质面板上隐藏Tiling和Offset
		[NoScaleOffset]_SecondTex ("Second Tex", 2D) = "white" {}

		// 在材质面板插入多行空行，括号内为空行数
		[Space(50)]

		// 布尔也是浮点型数据，只是在材质面板上以开关的形式显示
		// 开关只会用到两个数：0和1，开启即为1，关闭即为0
		// 当开关开启，shader关键词会被设定为："property name" + "_ON"，必须大写
		[Toggle] _Invert ("Invert color?", Float) = 0

		// 或者重新指定一个shader关键词，括号内为shader关键词
		[Toggle(ENABLE_FANCY)] _Fancy ("Fancy?", Float) = 0

		// 枚举也是浮点型数据，只是在材质面板上以下拉列表的形式显示
		// 可以直接使用Unity内置的枚举类
		[Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("Src Blend Mode", Float)=1
		[Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("Dst Blend Mode", Float)=1
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 0

		// 也可以自定义枚举的名称/数值对
		// 但是最多只支持7个名称/数值对
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
		
		// 关键词枚举也是浮点型数据，只是在材质面板上以下拉列表的形式显示
		// shader关键词格式为："property name" + 下划线 + “枚举名称”，必须大写
		// 但是最多支持9个枚举名称
		[KeywordEnum(None, Add, Multiply)] _Overlay ("Overlay mode", Float) = 0

		// 指数滑动条也是浮点型数据，只是在材质面板上作为非线性响应的滑动条显示
		// 括号内为指数
		[PowerSlider(3.0)] _Brightness ("Brightness", Range (0.01, 1)) = 0.1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Blend [_SrcBlend] [_DstBlend]
		Cull [_Cull]
		ZTest [_ZTest]
		ZWrite [_ZWrite]

		Pass
		{
			CGPROGRAM

			// 通过"#pragma shader_feature"定义 _INVERT_ON shader关键词
			#pragma shader_feature _INVERT_ON

			// 通过"#pragma shader_feature"定义 ENABLE_FANCY shader关键词
			#pragma shader_feature ENABLE_FANCY

			// 通过"#pragma multi_compile"定义关键词枚举的每一个shader关键词
			// shader关键词之间以空格间隔开
			#pragma multi_compile _OVERLAY_NONE _OVERLAY_ADD _OVERLAY_MULTIPLY

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SecondTex;
			float4 _SecondTex_ST;
			float _Brightness;

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _SecondTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex, i.uv.xy);

				// 通过 #if, #ifdef 或者 #if defined 来使用
				#if _INVERT_ON
				col = 1 - col;
				#endif

				#if ENABLE_FANCY
				col.r = 0.5;
				#endif

				fixed4 secCol = tex2D(_SecondTex, i.uv.zw);

				#if _OVERLAY_ADD
				col += secCol;
				#elif _OVERLAY_MULTIPLY
				col *= secCol;
				#endif

				col *= _Brightness;

				return col;
			}
			ENDCG
		}
	}
}

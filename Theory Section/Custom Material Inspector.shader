Shader "Custom/Custom Material Inspector"
{
    Properties
    {
        // 在材质面板插入一行标题
        [Header(Custom Material Inspector)]

        // 在材质面板插入一行空白行，可以写在单独一行
        [Space]

        _MainTex ("Main Tex", 2D) = "white" {}

        // 在材质面板上隐藏Tiling和Offset
        [NoScaleOffset] _SecondTex ("Second Tex", 2D) = "white" {}

        // 在材质面板插入30行空白行，可以写在单独一行
        [Space(30)]

        // 开关
        [Toggle] _Invert ("Invert color?", Float) = 0

        // 自定义Shader关键词的开关
        [Toggle(ENABLE_FANCY)] _Fancy ("Fancy?", Float) = 0

        // Unity内置的枚举下拉菜单
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float)=1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float)=1
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 0

        // 自定义枚举下拉菜单
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        
        // 关键词枚举下拉菜单
        [KeywordEnum(None, Add, Multiply)] _Overlay ("Overlay mode", Float) = 0

        // 指数滑动条
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

                // 通过 #if, #ifdef 或者 #if defined启用某一部分代码
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

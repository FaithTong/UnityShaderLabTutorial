Shader "Custom/CG Properties"
{
    Properties
    {
        _MyFloat ("Float Property", Float) = 1 // 浮点类型
        _MyRange ("Range Property", Range(0, 1)) = 0.1 // 范围类型
        _MyColor ("Color Property", Color) = (1, 1, 1, 1) // 颜色类型
        _MyVector ("Vector Property", Vector) = (0, 1, 0, 0) //向量类型
        _MyTex ("Texture Property", 2D) = "white" {} // 2D贴图类型
        _MyCube ("Cube Property", Cube) = "" {} // 立方体贴图类型
        _My3D ("3D Property", 3D) = "" {} // 3D贴图类型
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // 在CG中声明属性变量
            float _MyFloat; // 浮点类型
            float _MyRange; // 范围类型
            fixed4 _MyColor; // 颜色类型
            float4 _MyVector; //向量类型
            sampler2D _MyTex; // 2D贴图类型
            samplerCUBE _MyCube; // 立方体贴图类型
            sampler3D _My3D; // 3D贴图类型

            void vert ()
            {

            }

            void frag ()
            {
                
            }

            ENDCG
        }
    }
}

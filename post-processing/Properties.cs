using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))] // 如果没有摄像机组件会自动创建
[ExecuteInEditMode] // 在编辑状态也能执行脚本
public class Properties : MonoBehaviour // 类名称要与脚本名称一致
{
	[Range(0.0f, 1.0f)] // 将数值转变为滑动条，只对下方第一个属性有效
	public float myRange = 0.5f;

	public float myNumber = 0f; // 数值属性
	public bool myToggle = false; // bool型开关属性
	public Color myColor = Color.white; // 颜色属性
	public Texture2D myTexture; // 关联纹理
	public Shader myShader; // 关联Shader文件
	public Material myMaterial; // 关联材质
	public MeshFilter myMesh; // 关联场景中的模型
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))] // 如果没有摄像机组件会自动创建
[ExecuteInEditMode] // 在编辑状态也能执行
public class Properties : MonoBehaviour // 类名称要与脚本名称一致
{
	[Range(0.0f, 1.0f)] // 数值范围滑动条，只对下方第一个属性有效
	public float myRange = 0;

	public float myNumber = 0;
	public bool myToggle = false;
	public Color myColor = Color.white;
	public Texture2D myTexture;
	public Shader myShader;
	public Material myMaterial;
	public MeshFilter myMesh; // Mesh
}

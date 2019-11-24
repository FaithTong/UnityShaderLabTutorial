using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class BrightnessSaturationContrast : MonoBehaviour
{
	//关联后期处理Shader
	public Shader EffectShader;

	//亮度、饱和度、对比度属性
	public float Brightness = 1f;
	public float Saturation = 1f;
	public float Contrast = 1f;

	//后期处理的材质
	private Material currentMaterial;

	//基于Shader生成的Material
	Material EffectMaterial
    {
		get
		{
			//判断Material是否为空，如果为空则创建Material
			if (currentMaterial == null)
			{
                currentMaterial = new Material(EffectShader)
				{
					//不会在hierarchy中显示，也不会保存到场景中
					hideFlags = HideFlags.HideAndDontSave
				};
			}
			return currentMaterial;
		}
	}

	//调用Shader进行后期处理
	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		//判断有无关联Shader文件
		//如果有，则进行属性传递
		//如果没有，则不执行任何处理
		if (EffectShader)
		{
            //将脚本中的属性传递给Shader
            EffectMaterial.SetFloat("_Brightness", Brightness);
            EffectMaterial.SetFloat("_Saturation", Saturation);
            EffectMaterial.SetFloat("_Contrast", Contrast);

			Graphics.Blit(source, destination, EffectMaterial);
		}
		else
			Graphics.Blit(source, destination);
	}

	//对开放的参数进行范围控制
	private void Update()
	{
		Brightness = Mathf.Clamp(Brightness, 0f, 2f);
		Saturation = Mathf.Clamp(Saturation, 0f, 2f);
		Contrast = Mathf.Clamp(Contrast, 0f, 2f);
	}
}

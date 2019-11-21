using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BrightnessSaturationContrast : MonoBehaviour
{
    #region
    public Shader EffectShader;
    public float Brightness = 1f;
    public float Saturation = 1f;
    public float Contrast = 1f;
    private Material currentMaterial;
    #endregion

    Material EffectMaterial
    {
        get
        {
            if (currentMaterial == null)
            {
                currentMaterial = new Material(EffectShader)
                {
                    hideFlags = HideFlags.HideAndDontSave
                };
            }
            return currentMaterial;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (EffectShader)
        {
            EffectMaterial.SetFloat("_Brightness", Brightness);
            EffectMaterial.SetFloat("_Saturation", Saturation);
            EffectMaterial.SetFloat("_Contrast", Contrast);

            Graphics.Blit(source, destination, EffectMaterial);
        }
        else
            Graphics.Blit(source, destination);
    }

    private void Update()
    {
        Brightness = Mathf.Clamp(Brightness, 0f, 2f);
        Saturation = Mathf.Clamp(Saturation, 0f, 2f);
        Contrast = Mathf.Clamp(Contrast, 0f, 2f);
    }
}

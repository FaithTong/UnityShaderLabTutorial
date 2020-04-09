using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class OldFilmEffect : MonoBehaviour
{
    public Shader OldFilmShader;
    public float EffectIntensity = 0.3f;
    public Color SepiaColor = Color.white;
    public float Contrast = 1.0f;

    public Texture2D VignetteTexture;
    public float VignetteIntensity = 1.0f;

    public Texture2D ScratchTexture;
    public float ScratchXSpeed = 1.0f;
    public float ScratchYSpeed = 1.0f;

    public Texture2D DustTexture;
    public float DustXSpeed = 1.0f;
    public float DustYSpeed = 1.0f;

    private Material currentMaterial;
    private float RandomValue;

    Material OldFilmEffectMaterial
    {
        get
        {
            if (currentMaterial == null)
            {
                currentMaterial = new Material(OldFilmShader)
                {
                    hideFlags = HideFlags.HideAndDontSave
                };
            }
            return currentMaterial;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (OldFilmShader != null)
        {
            OldFilmEffectMaterial.SetColor("_SepiaColor", SepiaColor);
            OldFilmEffectMaterial.SetFloat("_EffectIntensity", EffectIntensity);
            OldFilmEffectMaterial.SetFloat("_Contrast", Contrast);
            OldFilmEffectMaterial.SetFloat("_RandomValue", RandomValue);

            if (VignetteTexture != null)
            {
                OldFilmEffectMaterial.SetTexture("_VignetteTexture", VignetteTexture);
                OldFilmEffectMaterial.SetFloat("_VignetteIntensity", VignetteIntensity);
            }

            if (ScratchTexture != null)
            {
                OldFilmEffectMaterial.SetTexture("_ScratchTexture", ScratchTexture);
                OldFilmEffectMaterial.SetFloat("_ScratchXSpeed", ScratchXSpeed);
                OldFilmEffectMaterial.SetFloat("_ScratchYSpeed", ScratchYSpeed);
            }

            if (DustTexture != null)
            {
                OldFilmEffectMaterial.SetTexture("_DustTexture", DustTexture);
                OldFilmEffectMaterial.SetFloat("_DustXSpeed", DustXSpeed);
                OldFilmEffectMaterial.SetFloat("_DustYSpeed", DustYSpeed);
            }

            Graphics.Blit(source, destination, OldFilmEffectMaterial);
        }

        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        VignetteIntensity = Mathf.Clamp01(VignetteIntensity);
        EffectIntensity = Mathf.Clamp(EffectIntensity, 0.0f, 1.0f);
        Contrast = Mathf.Clamp(Contrast, 0.0f, 2.0f);
        RandomValue = Random.Range(-1.0f, 1.0f);
    }
}
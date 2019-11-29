using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]

//在下拉列表中显示的路径
[PostProcess(typeof(GrayscaleRenderer), PostProcessEvent.AfterStack, "Custom/BSC")]
public sealed class BSC : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Grayscale effect intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.5f };
}

public sealed class GrayscaleRenderer : PostProcessEffectRenderer<BSC>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/BSC-HLSL"));
        sheet.properties.SetFloat("_Blend", settings.blend);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}
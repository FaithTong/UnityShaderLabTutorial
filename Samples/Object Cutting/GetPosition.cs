using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GetPosition : MonoBehaviour
{
    public GameObject CuttingPosition;

    private Material Material;
    private Vector3 Center = new Vector3(0, 0, 0);
    void Start()
    {
        //获取当前物体材质
        Material = this.GetComponent<Renderer>().sharedMaterial;
    }

    void Update()
    {
        if (CuttingPosition)

            //获取CuttingPosition的坐标并传递给Shade
            Material.SetVector("_Position", CuttingPosition.transform.position);
        else
            Material.SetVector("_Position", Center);
    }
}

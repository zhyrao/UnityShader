using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour {

    private GameObject obj;
	// Use this for initialization
	void Start () {
        obj = this.gameObject;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        obj.transform.Rotate(Vector3.up, 1, Space.Self);
	}
}

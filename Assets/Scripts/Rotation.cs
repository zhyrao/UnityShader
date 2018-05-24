using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour {

    private GameObject obj;
    public float speed = 0.2f;
	// Use this for initialization
	void Start () {
        obj = this.gameObject;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        obj.transform.Rotate(Vector3.up, speed, Space.Self);
	}
}

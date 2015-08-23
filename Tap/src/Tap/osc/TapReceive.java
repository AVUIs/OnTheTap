package Tap.osc;

import processing.core.PApplet;


public class TapReceive extends PApplet {
	
	OSCReceiver receiver;
	
	public float a = 1.0f;
	public float b = 1.0f;
	public float c = 1.0f;
	public float d = 1.0f;

	float cx,cy,qw,qh;


	public void setup() {
		size(400,400);
		  
		receiver = new OSCReceiver(this);
		  
		cx = width * .5f;
		cy = height * .5f;
		qw = cx * .5f;
		qh = cy * .5f;
	}

	public void draw() {
		background(127);
		quad(cx - (qw * a),cy - (qh * a),
			 cx + (qw * b),cy - (qh * b),
	         cx + (qw * c),cy + (qh * c),
	         cx - (qw * d),cy + (qh * d));
	}
	
	public static void main(String _args[]) {
		PApplet.main(new String[] { Tap.osc.TapReceive.class.getName() });
	}
}

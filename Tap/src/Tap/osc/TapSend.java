package Tap.osc;

import processing.core.PApplet;


public class TapSend extends PApplet {
	OSCSender sender;
	
	public float x = 1.0f;
	public float y = 1.0f;
	public float velocity = 1.0f;
	public float amplitude = 1.0f;
	
	public void setup() {
		size(400,400);
		sender = new OSCSender(this);
		sender.setPrefix("/input/tap");
	}
	public void draw() {
		background(127);
		ellipse(x * width,y * width, amplitude * 100, amplitude * 100);
	}
	public void mouseDragged(){
		x = (float)mouseX/width;
		y = (float)mouseY/height;
		velocity = random(1.0f);
		amplitude = random(1.0f);
		sender.send(true);
	}
	
	public static void main(String _args[]) {
		PApplet.main(new String[] { Tap.osc.TapSend.class.getName() });
	}
}

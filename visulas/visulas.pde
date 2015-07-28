import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


import oscP5.*;
import netP5.*;

OscP5 oscP5;

float onAmp;
float vall;
float theX;
float theY;


float theWidth;
float theHeight;

Minim minim;
AudioSample kick;
AudioSample snare;
AudioInput in;




int[] numbers = { 
  6, 3, 6, 3, 6
};  

void setup() {

  size(1280, 800, P3D);  
  minim = new Minim(this);

  in = minim.getLineIn();



  oscP5 = new OscP5(this, 12001);
  oscP5.plug(this, "onX", "/input/tap/x");
  oscP5.plug(this, "onY", "/input/tap/y");
  oscP5.plug(this, "onVelocity", "/input/tap/velocity");
  oscP5.plug(this, "onAmplitude", "/input/amplitude");



}


void onX(int note, float value, int state) {
  //  println("x: " + value + " state: " + state);
theX = value;
}
void onY(int note, float value, int state) {
  // println("y: " + value + " state: " + state);

theY = value;

}
void onVelocity(int note, float value, int state) {

  vall = value;
  println(value);
}


void onAmplitude(int note, float value, int state) {

  //  println(value);
  onAmp = value;
  //  vall = note;

  //println("amplitude: " + value + " state: " + state);
}



void draw() {
  smooth();
  background(0);
println("theY + " + theY); 


theWidth = width;
theHeight = height;

fill(255);
ellipse(width/2,height/2,100+ 100*onAmp,100+ 100*onAmp);
textAlign(CENTER);
textSize(12);
text("onAmp", width/2, height/2+100); 

ellipse(width/3,height/2,100+ 100*vall,100+ 100*vall);

fill(255,0,0);

ellipse(theX*theWidth,theY*theHeight,100,100);
}
 


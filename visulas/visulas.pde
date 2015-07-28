import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;


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


ControlFrame cf;

RadioButton r;

int myColorBackground = color(0, 0, 0);


int one = 50;
int two = 100;
int three = 150;
int four = 250;



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

  cp5 = new ControlP5(this);
  cf = addControlFrame("extra", 500, 300);
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



  background(myColorBackground);




  fill(255);
  ellipse(width/2, height/2, 100+one*onAmp, 100+one*onAmp);
  textAlign(CENTER);
  textSize(20);
  text("Amplitude", width/2, height/2+100); 

  ellipse(width/3, height/2, 100+two*vall, two+ 100*vall);
  text("Velocity", width/3, height/2+100); 
  fill(255, 0, 0);

  ellipse(10+theX*theWidth, 10+theY*theHeight, three, three);
  text("X & Y", theX*theWidth, theY*theHeight+50);




  fill(255,0,0);
  rectMode(CENTER);
  rect( width/2+200,height/2, 20+four, 20+four);
}


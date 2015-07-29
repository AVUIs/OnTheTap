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
float x;
float onAmp;
float onVall;
float theX;
float theY;

Interface iface = new Interface(1280, 800, 20);

float theWidth;
float theHeight;

Minim minim;
AudioSample kick;
AudioSample snare;
AudioInput in;

Visuals h1 = new Visuals(20, 2.0); 

ControlFrame cf;

RadioButton r;

int myColorBackground = color(0, 0, 0);
int change;


int one = 50;
int two = 100;
int three = 150;
int four = 250;
int newTouch;

Bird iBird = new Bird(1280, 800, 20);
float screenThird;
float sY = 10;
float sX = 10;


float posX, posY;
float radiusX, radiusY;
float theta;


int[] numbers = { 
  6, 3, 6, 3, 6
};  



float sizeY = 20;
float sizeX = 20;
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


  posX = posY = 0;

  radiusX = 0;
  radiusY = 70;

  theta = 0;

  in = minim.getLineIn();
  iface.setupAudio();
}




void onX(int note, float value, int state) {

  theX = value;
}
void onY(int note, float value, int state) {

  theY = value;
}

void onVelocity(int note, float value, int state) {


  onVall = value;
  newTouch = state;
}

void onAmplitude(int note, float value, int state) {

  onAmp = value;
}



void draw() {
  smooth();
  background(0);

  screenThird = width/2+width/4;  


  theWidth = width;
  theHeight = height;


  background(myColorBackground);



  if (change == 1) {
    h1.update1();
  }

  if (change == 2) {
    h1.update2();
  }

  if (change == 3) {
    h1.update3();
  }

  if (change == 4) {
    h1.update4();
  }

  if (change == 5) {
    h1.update5();
  }


  println("Welcome, to OnTheTap");
  println("Use the Controller to select visuals");
}

class Visuals { 
  float ypos, speed; 
  Visuals (float y, float s) {  
    ypos = y; 
    speed = s;
  } 


  // 5 functions that are called to trigure visuals

    void update1() { 

    iface.BgDisplay();
    iface.display();
  } 

  void update2() { 

    background(0);
    for (int i = 0; i < 200; i=i+10) {

      strokeWeight(1);
      stroke(one,two,255);
      float x1 = map(i, 0, 100, 100, width/2);
      float x2 = map(i+1, 0, 100, 100, width/2);

      int offNum = 50;

      line(x1, height/2 - onAmp*150-offNum, theX*theWidth, offNum);
      line(x2, height/2 - onAmp*-150+offNum, theX*theWidth, height-offNum);
      
      noStroke();
      fill(190,three,50+four);
      ellipse(x1, height/2 - onAmp*150-offNum, 20+10*onVall, 20+100*onVall);
      ellipse(x2, height/2 - onAmp*-150+offNum, 20+10*onVall, 20+100*onVall);
    }
  }

  void update3() { 


    //    newTouch
    //    onAmp;
    //    onVall;
    //    theX;
    //    theY;

    iBird.display();
  }
  void update4() { 



    if (newTouch == 1) {


      x = x=x+10;

      if (x > width) {
        x = 0;
      }
      ellipse(x, height/2, 10, 10);
    }

    //this is an extra one for george

    //    newTouch
    //    onAmp;
    //    onVall;
    //    theX;
    //    theY;


   
  }
  void update5() { 


    //this is an extra one for george

    //    onAmp;
    //    onVall;
    //    theX;
    //    theY;
  }
} 


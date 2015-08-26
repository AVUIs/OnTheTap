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
FFT fft;
float[] fftFilter;
float decay = 0.97;

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

//int[] colors = {0xFF468966,0xFFFFF0A5,0xFFFFB03B,0xFFB64926,0xFF8E2800};
//int currentColors = 2;
//int currentDist = 5;
//String[] colorDist = {"horizontal","vertical","diagonal","random","p1","p2","p3","p4","p5","p6","p7","sin","cos"};
//String[] coordDist = {"accident1","accident2","accident3","accident4","accident5","accident6","accident7"};




float sizeY = 20;
float sizeX = 20;
void setup() {

  size(1280, 800, P3D);
  frameRate(60);  
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
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fftFilter = new float[fft.specSize()];
  
  iface.setupAudio();
}




void onX(int note, float value, int state) {
 println("received X: " + value);
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
  
  frame.setTitle((int)frameRate+"fps");

}

void updateFFT(){
  fft.forward(in.mix);
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
  }
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
//    updateFFT();
    fft.forward(in.mix);
    for (int i = 0; i < fftFilter.length; i++) {
      fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
    }
    println(in.mix.level());
    float ew = (float)width/fftFilter.length;
    pushStyle();
    noStroke();
    for (int i = 0; i < fftFilter.length; i++){
      fill(fftFilter[i] * 64);
      rect(ew*i,0,ew,height);
    }
    popStyle();

   
  }
  void update5() { 


    //this is an extra one for george
    
    //    onAmp;
    //    onVall;
    //    theX;
    //    theY;
    fft.forward(in.mix);
    for (int i = 0; i < fftFilter.length; i++) {
      fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
    }
    pushStyle();
      pattern(30,20,theX * width,theY * height,colors,colorDist[currentColors],mousePressed,coordDist[currentDist]);
    popStyle();
  }
  int currentColors = 2;
  int currentDist = 5;
  String[] colorDist = {"horizontal","vertical","diagonal","random","p1","p2","p3","p4","p5","p6","p7","sin","cos"};
  String[] coordDist = {"accident1","accident2","accident3","accident4","accident5","accident6","accident7"};
  int[] colors = {0xFF468966,0xFFFFF0A5,0xFFFFB03B,0xFFB64926,0xFF8E2800};
  
  void pattern(float radius,float spacing, float width, float height, int[] colors, String rule, Boolean cp, String ac){
      int xNum = floor(width / (radius * .5 + spacing));
      int yNum = floor(height / (radius * .5 + spacing));
      //translate(spacing,spacing);
      //translate(width * .5, height * .5);
      int c = 0;
      for(int j = 0 ; j < yNum ; j++){
        for(int i = 0 ; i < xNum ; i++){
          c++;
          int clr = 0;
          if(rule == "horizontal") clr = colors[i%colors.length];//x patten
          if(rule == "vertical") clr = colors[j%colors.length];//y patten
          if(rule == "diagonal") clr = colors[c%colors.length];//diag
          if(rule == "random") clr = colors[floor(random(colors.length))];//random
          if(rule == "p1") clr = colors[floor(c%colors.length/i)];//r1
          if(rule == "p2") clr = colors[floor(c%colors.length/j)];//r2
          if(rule == "p3") clr = colors[floor(c%colors.length/i*j)];//r3
          if(rule == "p4") clr = colors[floor(c%colors.length*i/j)];//r4
          if(rule == "p5") clr = colors[floor(c%colors.length*j/i)];//r5
          if(rule == "p6") clr = colors[floor(i%colors.length*j/c*j)];//r6
          if(rule == "p7") clr = colors[floor(j%colors.length*i/c*i)];//r7
          if(rule == "sin") clr = colors[floor(spacing * sin(radius + c))];//amp * sin(freq + phase) // amp = spacing, freq = radius, phase, c
          if(rule == "cos") clr = colors[floor(j * cos(radius + c))];
            fill(red(clr),green(clr),blue(clr));
          if(!cp) {
            ellipse(i*(radius+spacing),j*(radius+spacing),radius,radius);
          }else{
            //var cx:int = stage.stageWidth * .5, cy:int = stage.stageHeight* .5;var a:Number;
            int cx = int(width * .5), cy = int(height* .5);
            float a = 0.0f;
            if(ac == "accident1") a = atan2(j*(radius+spacing)-cy, i*(radius+spacing)-cx);//accident1
      if(ac == "accident2") a = radians(c%360);//(c%360) * PI / 180;//accident 2
      if(ac == "accident3") a = radians((i+j)%360);//accident 3
      if(ac == "accident4") a = radians(int(i+""+j)%360);//accident 4, similar to 2. colours look better
      if(ac == "accident5") {
              a = float(i)/float(xNum) * TWO_PI;//accident 4, similar to 2. colours look better
              //println("i: " + i + " / xNum: " + xNum + " (i/xNum): " + (i/xNum));
             }
      if(ac == "accident7") {
              a = float(c)/float(i)*float(j) * TWO_PI;//accident 4, similar to 2. colours look better
        ellipse(cx + cos(a) * j * (radius+spacing) ,cy + sin(a) * j * (radius+spacing),radius,radius);
      }
      if(ac == "accident6") {
              a = float(i)/float(xNum) * TWO_PI;//accident 4, similar to 2. colours look better
        ellipse(cx + cos(a) * j * (radius+spacing) ,cy + sin(a) * j * (radius+spacing),radius,radius);
            }else{
              ellipse(cx + cos(a) * i*(radius+spacing),cy + sin(a) * j*(radius+spacing),radius,radius);
            }
          }
        }
      }
    }

} 


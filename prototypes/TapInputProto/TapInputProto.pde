import ddf.minim.*;
import oscP5.*;
import netP5.*;

Minim minim;
AudioInput in;
float amplitude;

float threshold = 0.35;
float maxAmp = 0;

OscP5 osc;
int PORT_IN = 12000;
int PORT_OUT = 12001;
String TAP = "/input/tap";
String AMP = "/input/amplitude";
OscMessage tapMessage = new OscMessage(TAP);
OscMessage ampMessage = new OscMessage(AMP);
NetAddress broadcast = new NetAddress("255.255.255.255", PORT_OUT);

void setup(){
  //setup preview
  size(400,400); 
  noStroke();fill(255);
  //audio setup
  setupAudio();
  //setup osc
  osc = new OscP5(this,PORT_IN); 
}
void setupAudio(){
  minim      = new Minim(this);
  in         = minim.getLineIn(Minim.STEREO, 1024);
}
void draw(){
  //update
  amplitude = in.mix.level() * 2;
  
  if(mousePressed){
    if(amplitude > maxAmp) maxAmp = amplitude;
  }
  
  ampMessage.clear();
  ampMessage.setAddrPattern(AMP);
  ampMessage.add(constrain(amplitude,0.0,1.0));
  osc.send(tapMessage,broadcast);
  //draw
  background(amplitude * 127);text(amplitude,10,10);
  
  //basic test, volume threshold
  if(amplitude > threshold){
    rect(10,10,100,100);
  }
  
  
  
}
void mousePressed(){
  tapMessage.clear();
  tapMessage.setAddrPattern(TAP);
  tapMessage.add(constrain((float)mouseX/width,0.0,1.0));
  tapMessage.add(constrain((float)mouseY/height,0.0,1.0));
  tapMessage.add(constrain(amplitude,0.0,1.0));
  osc.send(tapMessage,broadcast);
  tapMessage.print();
}
void mouseReleased(){
  tapMessage.clear();
  tapMessage.setAddrPattern(TAP);
  tapMessage.add(constrain((float)mouseX/width,0.0,1.0));
  tapMessage.add(constrain((float)mouseY/height,0.0,1.0));
  tapMessage.add(0.0);
  osc.send(tapMessage,broadcast);
  tapMessage.print();
}


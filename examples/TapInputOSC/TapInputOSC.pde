import ddf.minim.*;
import oscP5.*;
import netP5.*;

Minim minim;
AudioInput in;
float amplitude;

float threshold = 0.35;
float lastAmp = 0;

OscP5 osc;
int PORT_IN = 12000;
int PORT_OUT = 12001;
String TAP = "/input/tap";
String AMP = "/input/amplitude";
OscMessage tapMessage = new OscMessage(TAP);
OscMessage ampMessage = new OscMessage(AMP);
//NetAddress broadcast = new NetAddress("255.255.255.255", PORT_OUT);
NetAddress broadcast = new NetAddress("10.0.1.91", PORT_OUT);
//NetAddress broadcast = new NetAddress("10.0.1.50", PORT_OUT);

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
  
  ampMessage.clear();
  ampMessage.setAddrPattern(AMP);
  ampMessage.add(0);
  ampMessage.add(constrain(amplitude,0.0,1.0));
  ampMessage.add(1);
  osc.send(ampMessage,broadcast);
  //draw
  background(amplitude * 127);text(amplitude,10,10);
  
  //basic test, volume threshold
  if(amplitude > threshold){
    rect(10,10,100,100);
  }
  
  
  
}
void mousePressed(){
  lastAmp = amplitude;
  sendTap();
}
void mouseDragged(){
  sendTap();
}
void sendMidiArg(OscMessage m,String prefix,String suffix,float arg,int state){
  m.clear();
  m.setAddrPattern(prefix+suffix);
  m.add(0);
  m.add(arg);
  m.add(state);
  m.print();
  osc.send(tapMessage,broadcast);
}
void sendTap(){
  sendMidiArg(tapMessage,TAP,"/x",constrain((float)mouseX/width,0.0,1.0),1);
  sendMidiArg(tapMessage,TAP,"/y",constrain((float)mouseY/height,0.0,1.0),1);
  sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,1);
  println(lastAmp);
}
void mouseReleased(){
  sendMidiArg(tapMessage,TAP,"/x",constrain((float)mouseX/width,0.0,1.0),0);
  sendMidiArg(tapMessage,TAP,"/y",constrain((float)mouseY/height,0.0,1.0),0);
  sendMidiArg(tapMessage,TAP,"/velocity",lastAmp,0);
}
void stop(){
  ampMessage.clear();
  ampMessage.setAddrPattern(AMP);
  ampMessage.add(0);
  ampMessage.add(constrain(amplitude,0.0,1.0));
  ampMessage.add(0);
  osc.send(ampMessage,broadcast);
}


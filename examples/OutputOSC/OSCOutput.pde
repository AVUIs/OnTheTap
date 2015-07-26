import oscP5.*;
import netP5.*;

import java.lang.reflect.*;

class OSCOutput{
  
  OscP5 osc;
  int PORT_IN = 12001;
  int PORT_OUT = 12000;
  String ip = "255.255.255.255";
  NetAddress address = new NetAddress(ip, PORT_OUT);
  
  PApplet parent;
  
  OSCOutput(PApplet parent,JSONObject settings){
    PORT_IN  = settings.getInt("port in",PORT_IN);
    PORT_OUT = settings.getInt("port out",PORT_OUT);
    ip       = settings.getString("ip",ip);
    address = new NetAddress(ip, PORT_OUT);
    this.parent = parent;
    osc = new OscP5(parent,PORT_IN);
  }
  
  OSCOutput(PApplet parent){
    this.parent = parent;
    osc = new OscP5(parent,PORT_IN);
  }
  public void addListener(String methodName){
    osc.plug(parent,methodName,"/output/"+methodName);
  }
  
  void oscEvent(OscMessage m) {
    m.print();
  }
  
}

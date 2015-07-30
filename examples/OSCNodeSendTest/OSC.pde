package org.GenAV.OnTheTap.tapinput;
import processing.core.PApplet;
import processing.core.PVector;
import processing.event.MouseEvent;
/*
discover -> returns a list of available servers, each list which a list of properties to subscribe to
ui -> displays a list of public variables plus a list of properties to subscribe to
   -> on connection made -> subscribe to server(s)
                         -> save settings to json file
   -> use icon to toggle ui
   -> (for now) use shift+click connection to disconnect
-> for subscribe and discover repeat until confirmed

settings:
{
  "port in":12000,
  "port out":12001,
  "map":
  {
    "a":"x",
    "b":"y",
    "c":"vel",
    "d":"amp"
  }
}
*/
import oscP5.*;
import netP5.*;

import java.lang.reflect.*;
import java.util.*;


public class OSCNode implements GUIListener{
  
  private static final int PORT_IN = 12000;
  private static final int PORT_OUT = 12001;
  
  
  private final NetAddress broadcast;
  private final String TAG_SEARCH = "/search";
  private final String TAG_RESULT = "/result";
  private final String TAG_SUBSCRIBE = "/subscribe";
  private final String TAG_UNSUBSCRIBE = "/unssubscribe";
  private final OscMessage SEARCH = new OscMessage(TAG_SEARCH,new Object[]{PORT_IN});
  
  public final static int INPUT = 0;
  public final static int OUTPUT = 1;
  private int type;
  
  private OscP5 osc;
  
  
  private HashMap<String,Field> parameterMap = new HashMap<String,Field>();

  private ArrayList<RemoteSource> sources = new ArrayList<RemoteSource>();
  private HashMap<String,NetAddress> remoteParameters = new HashMap<String,NetAddress>();
  
  private HashMap<String,String> mapping = new HashMap<String,String>();
  
  private PApplet parent;

  private String prefix = "";
  
  //UI
  private float buttonWidth = 150;
  private float buttonHeight= 20;
  private TapButton tap;
  private Button search;
  private GUIGroup localControls = new GUIGroup(); 
  private GUIGroup remoteControls = new GUIGroup(); 
  private GUIElement lastPress,lastRelease;
  private HashMap<PVector,PVector> connectionUI = new HashMap<PVector,PVector>();  
  
  @SuppressWarnings("deprecation")
  OSCNode(PApplet parent,int type){
  
    this.parent = parent;
    this.type = type;
    osc = new OscP5(this,type == OSCNode.INPUT ? PORT_IN : PORT_OUT);
    broadcast = new NetAddress("255.255.255.255",type == OSCNode.INPUT ? PORT_OUT : PORT_IN);
//    broadcast = new NetAddress("127.0.0.1",type == OSCNode.INPUT ? PORT_OUT : PORT_IN);
    PApplet.println(broadcast);
    parent.registerDraw(this);
    parent.registerDispose(this);
    parent.registerMethod("mouseEvent", this);
    
    try{
      for (Field f : parent.getClass().getDeclaredFields()) {
        if(f.getModifiers() == Modifier.PUBLIC) {
          parameterMap.put(f.getName(),f);
        }
      }
    }catch(Exception e){
      e.printStackTrace();
    }
    
    tap = new TapButton(parent, "", 10, 10, 32, 32);
//    tap.setListener(this);
    localControls.x = 10;
    remoteControls.x = parent.width - buttonWidth - remoteControls.pad;
    localControls.y = remoteControls.y = 75;
    if(type == OSCNode.OUTPUT){
      search = new Button(parent, "search", 10, 45, buttonWidth, buttonHeight);
      search.setListener(this);
      for(String localParam : parameterMap.keySet()) {
        Button b = new Button(parent, localParam, 0, 0, buttonWidth, buttonHeight);
        b.setListener(this);
        localControls.add(b);
      }
      localControls.valign();
    }
  }
  
  public void mouseEvent(MouseEvent e){
    tap.update(e);
    if(tap.isOn){
      localControls.update(e);
      remoteControls.update(e);
      if(type == OSCNode.OUTPUT) search.update(e);
    }
    if(e.getAction() == MouseEvent.RELEASE && lastRelease == null && lastPress != null){
      parent.println(lastPress.label+" is in localControls:"+localControls.contains(lastPress));
      lastPress = null;
    }
  }
  public void onGUIEvent(GUIElement e,int type){
    parent.println(e.label + ":"+type);
    if(e.equals(search) && type == MouseEvent.CLICK) search();
    else{
      if(type == MouseEvent.PRESS){
        if(lastPress == null) lastPress = e;
      }
      if(type == MouseEvent.RELEASE){
//        if(lastRelease== null) lastRelease = e;
        if(lastPress != null && remoteControls.contains(e)){
          connectionUI.put(new PVector(lastPress.x+lastPress.w, lastPress.y+(lastPress.h * .5f)), new PVector(e.x, e.y + (e.h * .5f)));
          map(e.label,lastPress.label);
          parent.println("connecting " + lastPress.label + " to " + e.label);
        }
      }
    }
  }
  
  void draw(){
    tap.draw();
    if(tap.isOn){
      localControls.draw();
      remoteControls.draw();
      if(type == OSCNode.OUTPUT) search.draw();
    }
    if(lastPress != null){
      parent.pushStyle();
      parent.line(lastPress.x + lastPress.w, lastPress.y+(lastPress.h * .5f), parent.mouseX, parent.mouseY);
      parent.popStyle();
    }
    drawConnections();
  }
  private void drawConnections() {
    for (PVector from : connectionUI.keySet()){
      PVector to = connectionUI.get(from);
      parent.pushStyle();
      parent.line(from.x,from.y,to.x,to.y);
      parent.popStyle();
    }
  }

  void search(){
    osc.send(SEARCH,broadcast);
  }
  
  void map(String remoteParameter,String localParameter){
    if(remoteParameters.get(remoteParameter) != null){
      NetAddress to = remoteParameters.get(remoteParameter);
      osc.send(new OscMessage(TAG_SUBSCRIBE,new Object[]{remoteParameter}),to);
      mapping.put(remoteParameter,localParameter);
    }
//      osc.send(new OscMessage(TAG_SUBSCRIBE,
  }
  void unmap(String remoteParameter,String localParameter){
    if(remoteParameters.get(remoteParameter) != null){
        NetAddress to = remoteParameters.get(remoteParameter);
        osc.send(new OscMessage(TAG_UNSUBSCRIBE,new Object[]{remoteParameter}),to);
//        mapping.put(remoteParameter,localParameter);
        mapping.remove(remoteParameter);
      } 
  }

  void send(boolean on){
    PApplet.println("sending, sources:"+sources.size());
    for(RemoteSource src : sources){
      for(String lparam: src.parameters){
        String param = lparam.substring(prefix.length()+1);
        PApplet.println(param);
        if(parameterMap.get(param) != null){
          try{
            float value = parameterMap.get(param).getFloat(parent);
            PApplet.println(value+":"+src.netAddress);
            osc.send(new OscMessage(lparam,new Object[]{0,value,on ? 1 : 0}),src.netAddress);
          }catch(Exception e){
            e.printStackTrace();
          }
        }
      }
    }
  }
  
  NetAddress getAddressFromBroadcast(OscMessage m){
    String ip = m.address().substring(1);//address starts with a / so we discard it
      int port  = broadcast.port();
      return new NetAddress(ip,port);
  }
  
  void oscEvent(OscMessage m){
    System.err.println("OSCNodeReceiveTest");
//    m.print();
//    out += "received: " + m + "\n";
    if(m.checkAddrPattern(TAG_RESULT)){
      int argsLen = m.arguments().length;
      //FIXME check for duplicates first
      NetAddress to = getAddressFromBroadcast(m);
      RemoteSource src = new RemoteSource(to);
      
      for(int i = 0 ; i < argsLen; i++){
//        println("read param:" + m.get(i));
        String remoteParam = m.get(i).stringValue();
        src.parameters.add(remoteParam);
        remoteParameters.put(remoteParam,to);
        Button b = new Button(parent, remoteParam, 0, 0, buttonWidth, buttonHeight);
        b.setListener(this);
        remoteControls.add(b);
      }
      remoteControls.valign();
      
      
      sources.add(src);
    }

     if(m.checkAddrPattern(TAG_SEARCH)){
        NetAddress from = m.netAddress();
        OscMessage result = new OscMessage(TAG_RESULT);
        for(String s: parameterMap.keySet()) result.add(prefix+"/"+s);
        osc.send(result,getAddressFromBroadcast(m));
        PApplet.println(from + " is searching");
        PApplet.println(result);
//        out += from + " is searching\n";
//        out += "result " + result;
      }
      if(m.checkAddrPattern(TAG_SUBSCRIBE)){
        String field = m.get(0).stringValue();
        PApplet.println("request to subscribe to " + field);
        
        //TODO check if exists first
        String ip = m.address().substring(1);//address starts with a / so we discard it
        
      //check if ip was already subscribed
        RemoteSource existing = null;
        if(sources.size() > 0){
          for(RemoteSource s : sources){
            if(s.netAddress.address().contains(ip)){
              PApplet.println("client " + ip + " already subscribed");
              existing = s;
              break;
            }
          }
        }
        if(existing == null){
          RemoteSource src = new RemoteSource(new NetAddress(ip,broadcast.port()));
          src.parameters.add(field);
          
          sources.add(src);
          PApplet.println(sources+":"+src.parameters);
        }else{
          if(existing.parameters.indexOf(field) == -1){
            existing.parameters.add(field);
            PApplet.println("added" + field + " to " + ip);
          }
        }
      }

    
    Set<String> watchList = mapping.keySet();
    for(String param : watchList){
      if(m.checkAddrPattern(param)){
        float value = m.get(1).floatValue();
        Field f = parameterMap.get(mapping.get(param));
        if(f != null){
          try{
            f.setFloat(parent,value);
          }catch (Exception e){
            e.printStackTrace();
          }  
        }
      } 
    }
    
    
//      println(m.netAddress());
  }
  
  void dispose(){
    PApplet.println("cleanup");
  }
  
}
class RemoteSource{
//  
  NetAddress netAddress;
  ArrayList<String> parameters = new ArrayList<String>();
  
  RemoteSource(NetAddress netAddress){
    this.netAddress = netAddress;
  }
  
}
class GUIGroup{
  float x,y;
  
  ArrayList<GUIElement> elements = new ArrayList<GUIElement>();
  
  float pad = 5;
  
  void halign(){
    for (int i = 1; i < elements.size(); i++) {
      GUIElement c = elements.get(i);
      GUIElement p = elements.get(i-1);
      c.x = p.x + p.w + pad;
    }
  }
  void valign(){
    for (int i = 1; i < elements.size(); i++) {
      GUIElement c = elements.get(i);
      GUIElement p = elements.get(i-1);
      c.y = p.y + p.h + pad;
    }
  }
  void update(MouseEvent e){
    for(GUIElement g : elements) g.update(e);
  }
  void draw(){
    for(GUIElement g : elements) g.draw();
  }
  void add(GUIElement g){
    g.x = this.x;
    g.y = this.y;
    elements.add(g);
  }
  void remove(GUIElement g){
    if(elements.contains(g)) elements.add(g);
  }
  boolean contains(GUIElement g){
    return elements.contains(g);
  }
  GUIElement getElementByLabel(String label){
    GUIElement e = null;
    for(GUIElement g : elements)
      if (g.label.contains(label)) return g;
    return e;  
  }
}
interface GUIListener{
  void onGUIEvent(GUIElement e,int type);
}
class GUIElement{
  
  boolean enabled = true;
  
  float w,h,x,y;//width, height and position
  int bg = 0xFFC8C8C8;//background colour
  int fg = 0xFF000000;//foreground colour
  String label;
  
  PApplet parent;
  
  
  
//  final static int CLICK = 0;
//  final static int PRESS = 1;
//  final static int RELEASE = 2;
  
  GUIListener listener;
  
  GUIElement(PApplet parent,String label,float x,float y,float w,float h){
    this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.label = label;
      this.parent = parent;
  }
  void update(MouseEvent e){}
  void draw(){}
  void setListener(GUIListener l){
    listener = l;
  }
}
class Button extends GUIElement{
  boolean isOver,wasPressed;
  int pw = 10;
  
  Button(PApplet parent, String label, float x, float y, float w, float h) {
    super(parent, label, x, y, w, h);
  }
  void update(MouseEvent e){
    if(!enabled) return;
    isOver = ((parent.mouseX >= this.x && parent.mouseX <= (this.x+this.w))&&
          (parent.mouseY >= this.y && parent.mouseY <= (this.y+this.h)));
    switch(e.getAction()){
        case MouseEvent.CLICK:
          if(isOver && listener != null) listener.onGUIEvent(this, MouseEvent.CLICK);
      break;
        case MouseEvent.PRESS:
          if(isOver && listener != null) listener.onGUIEvent(this, MouseEvent.PRESS);
          break;
        case MouseEvent.RELEASE:
          if(isOver && listener != null) listener.onGUIEvent(this, MouseEvent.RELEASE);
          break;
        case MouseEvent.MOVE:
          break;
    }
  }
  void draw(){
    parent.pushStyle();
      parent.noStroke();
      parent.fill(isOver ? fg : bg);
      parent.rect(x,y,w,h);
      parent.fill(isOver ? bg : fg);
      parent.text(label,x+pw,y+h*.75f);
      parent.popStyle();
  }
}
class ToggleButton extends Button{
  boolean isOn = false;
  
  ToggleButton(PApplet parent, String label, float x, float y, float w,float h) {
    super(parent, label, x, y, w, h);
  }
  void update(MouseEvent e){
    super.update(e);
    if(e.getAction() == MouseEvent.CLICK && isOver) isOn = !isOn;
  }
  void draw(){
    parent.pushStyle();
      parent.noStroke();
      parent.fill(isOn ? fg : bg);
      parent.rect(x,y,w,h);
      parent.fill(isOn ? bg : fg);
      parent.text(label,x+pw,y+h*.75f);
      parent.popStyle();
  }
}
class TapButton extends ToggleButton{
  
  TapButton(PApplet parent, String label, float x, float y, float w, float h) {
    super(parent, label, x, y, 32, 32);
  }
  void draw(){
    parent.pushStyle();
    parent.noStroke();
      parent.fill(isOn ? fg : bg);
      parent.rect(x,y,w,h);
      parent.stroke(isOn ? bg : fg);
      parent.pushMatrix();
      parent.translate(x+w*.25f,y+h*.125f);
      parent.line(4,2,8,2);
      parent.line(8,2,8,7);
      parent.line(8,7,11,7);
      parent.line(11,7,11,10);
      parent.line(11,10,8,10);
      parent.line(8,10,8,17);
      parent.bezier(8,17,8,17,7,19,11,17);
      parent.line(11,17,12,21);
      parent.bezier(12,21,12,21,11,22,8,22);
      parent.bezier(8,22,5,22,4,20,4,19);
      parent.bezier(4,19,4,17,4,11,4,11);
      parent.line(4,11,2,11);
      parent.line(2,11,2,7);
      parent.line(2,7,4,7);
      parent.line(4,7,4,2);
      parent.popMatrix();
      parent.popStyle();
  }
}

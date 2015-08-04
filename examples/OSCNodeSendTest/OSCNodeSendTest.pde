OSCNode n;

public float x = 1.0;
public float y = 1.0;
public float velocity = 1.0;
public float amplitude = 1.0;

void setup(){
  size(400,400);
  
  n = new OSCNode(this,OSCNode.INPUT);
  n.prefix = "/input/tap";
}
void draw(){
  background(127);
  ellipse(x * width,y * width, amplitude * 100, amplitude * 100);
}
void mouseDragged(){
  x = (float)mouseX/width;
  y = (float)mouseY/height;
  velocity = random(1.0);
  amplitude = random(1.0);
  n.send(true);
}

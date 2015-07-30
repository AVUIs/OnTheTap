OSCNode n;

public float a = 1.0;
public float b = 1.0;
public float c = 1.0;
public float d = 1.0;

String out = "";

void setup(){
  size(400,400);
  
  n = new OSCNode(this,OSCNode.OUTPUT);
}
void draw(){
  background(127);
  float cx = width * .5;
  float cy = height * .5;
  float qw = cx * .5;
  float qh = cy * .5;
  quad(cx - (qw * a),cy - (qh * a),
       cx + (qw * b),cy - (qh * b),
       cx + (qw * c),cy + (qh * c),
       cx - (qw * d),cy + (qh * d));
  text(out,10,10);
}

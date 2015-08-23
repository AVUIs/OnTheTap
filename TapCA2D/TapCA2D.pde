/*
* An example of a generative audio visual system triggered by tapping
* The generative element in this case is a 2D Cellular Automata, but the same concept
* applies for other algorithms. 
* The systems works as follows:
* 1. A (mouse) tap/click is paired with the amplitude picked up from the mic at that time
* 2. The tap parameters (x,y, amplitude) are then mapped to a circle of live cells in the 2D CA (using x,y and amplitude for radius)
* 3. The CA's live cells' position and tap amplitude are mapped directly to string notes

* Something like this: tap -> CA2D -> sound (+implicit visuals)
*/
import ddf.minim.*;

Minim minim;
AudioInput in;
AudioOutput out;
//guitar pitches
int[] pitches = {262,277,294,311,330,349,370,392,415,440,466,494,523,554,587,622,659};
float amp,maxAmp;//mic amplitude used for tapping 

CA2D ca;//typical 2D Cellular Automata
int radius = 0;//radius of circle of alive cells triggered on tap
int pitchDiv;//how the pitches should be divided based on now many CA cells there are

PImage dot,cursor;//a radial gradient to render a cell/cursor (cell has an opaque black background, cursor is transparent)
int blend = ADD;//blend mode to be used -> changes on tap intensity

void setup(){
  //setup CA with cols/rows and cell size
  ca = new CA2D(8,8,208);
  //setup renderer
  size(ca.numX*ca.cellSize,ca.numY*ca.cellSize,P3D);
  background(0);
  noStroke();
  imageMode(CENTER);
  //setup images
  cursor = getRadialGradient(64,64,0,0,100); 
  dot = createImage(64,64,RGB);
  dot.loadPixels();
  dot.blend(cursor,0,0,64,64,0,0,64,64,ADD);
  //setup sound
  minim = new Minim(this);
  in    = minim.getLineIn();
  out   = minim.getLineOut();
  pitchDiv = ca.numX/8;
}

void draw(){
  //continuously update amplitude, but reset the counter every once in a while
  amp = in.mix.level();
  if(amp > maxAmp) maxAmp = amp;
  if(frameCount % 100 == 0) maxAmp = 0;
  //update CA
  ca.update();
  
  //get busy rendering
  background(amp * 32);
  blendMode(blend);
  int size = ca.cellSize*(radius+3);
  for(int c = 0 ; c < ca.numCells; c++){
    int i = ca.indices[c][0];
    int j = ca.indices[c][1];
    if(ca.currState[i][j]){
      tint(map(i,0,ca.numX,64,255),map(j,0,ca.numY,64,255),radius * 32);
      image(dot,i*ca.cellSize,j*ca.cellSize,size,size);
      //this where the current active cell is plugged to a sound
      //in this case the x/y position of the cell determines the pitch and the tap intensity the duration
      //feel free to experiment with other sounds, percusion might be fun
      new KSNote(pitches[i/pitchDiv+j/pitchDiv], 0.1).max_duration = map(radius,0,ca.maxRadius,1.618,0.1);
    }
  }
  cursor(dot);
}
void mouseReleased(){
  //compute CA circle cize based on amplitude
  radius = (int)map(amp,maxAmp * .25,maxAmp,0,8);
  radius = constrain(radius,0,8);
  //update blend mode based on tap amplitude
  blend = (radius > 4 ? LIGHTEST : ADD);
  //convert screen coordinates to ca coordinates and set a circle of live cells at mouse location
  int cx = mouseX/ca.cellSize;
  int cy = mouseY/ca.cellSize;
  ca.circle(cx,cy,radius);
}
void mouseDragged(){
  //improvise a wee bit by dragging the mouse vertically to affect the note duration
  radius = (int)map(constrain(mouseY,0,height),0,height,0,8);
  println(radius);
}
//presentation mode
boolean sketchFullScreen() {
  ((javax.swing.JFrame) frame).getContentPane().setBackground(java.awt.Color.BLACK);
  return true;
}
//draw a radial gradient using pixels
PImage getRadialGradient(int w,int h,int hue,int satMax,int brightness){
  pushStyle();//isolate drawing styles such as color Mode
    colorMode(HSB,360,100,100);
    PImage result = createImage(w,h,ARGB);//create an image with an alpha channel
    int np = w * h;//total number of pixels
    int cx = result.width/2;//center on x
    int cy = result.height/2;//center on y
    for(int i = 0 ; i < np; i++){//for each pixel
      int x = i%result.width;//compute x from pixel index
      int y = (int)(i/result.width);//compute y from pixel index
      float d = dist(x,y,cx,cy);//compute distance from centre to current pixel
      result.pixels[i] = color(hue,map(d,0,cx,satMax,0),brightness,map(d,0,cx,255,0));//map the saturation and transparency based on the distance to centre
    } 
    result.updatePixels();//finally update all the pixels
  popStyle();
  return result;
}

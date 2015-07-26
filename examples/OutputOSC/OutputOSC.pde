OSCOutput osc;

int mapX = 0;
int mapY = 0;
int prevX = 0;
int prevY = 0;
int mouseClickX = 0;
int mouseClickY = 0;
int mode = 0;
PImage img;


void setup(){
  size(400,400);  
  img = createImage(800,800,RGB);
  mode(mode);
  
  osc = new OSCOutput(this);
  osc.addListener("mode");
}
void mode(int mode){
  for(int i = 0 ; i < img.pixels.length;i++){
    int x = i%img.width;
    int y = (int)i/img.width;
    float ri = radians(i);
    float rx = radians(x);
    float ry = radians(y);
    
    if(mode  == 0) img.pixels[i] = color(x/800.0 * 255,0,y/800.0 * 255);
    
    if(mode  == 1) img.pixels[i] = color(x/800.0 * 255,sin(x)*255,y/800.0 * 255);// |
    if(mode  == 2) img.pixels[i] = color(x/800.0 * 255,sin(y)*255,y/800.0 * 255);// -
    if(mode  == 3) img.pixels[i] = color(x/800.0 * 255,sin(x+y)*255,y/800.0 * 255);// /
    if(mode  == 4) img.pixels[i] = color(x/800.0 * 255,sin(x-y)*255,y/800.0 * 255);// \
    
    if(mode  == 5) img.pixels[i] = color(x/800.0 * 255,sin(x*y)*255,y/800.0 * 255);// fractally
    if(mode  == 6) img.pixels[i] = color(x/800.0 * 255,sin(x*y*2)*255,y/800.0 * 255);// fractally
    if(mode  == 7) img.pixels[i] = color(x/800.0 * 255,sin(x*y*10)*255,y/800.0 * 255);// fractally
    if(mode  == 8) img.pixels[i] = color(x/800.0 * 255,sin(x*y*.61803398875)*255,y/800.0 * 255);// fractally
    if(mode  == 9) img.pixels[i] = color(x/800.0 * 255,sin(x*y*.1)*255,y/800.0 * 255);// fractally
    if(mode  == 10) img.pixels[i] = color(x/800.0 * 255,sin(x*y*.01)*255,y/800.0 * 255);// fractally
    if(mode  == 11) img.pixels[i] = color(x/800.0 * 255,sin(rx*ry)*255,y/800.0 * 255);// fractally
    if(mode  == 12) img.pixels[i] = color(x/800.0 * 255,sin(ri*ry)*255,y/800.0 * 255);// fractally
    if(mode  == 13) img.pixels[i] = color(x/800.0 * 255,sin(rx*ri*.1)*255,y/800.0 * 255);// fractally
    if(mode  == 14) img.pixels[i] = color(x/800.0 * 255,sin(ri*rx)*255,y/800.0 * 255);// fractally
    if(mode  == 15) img.pixels[i] = color(x/800.0 * 255,sin(ri*rx*10)*255,y/800.0 * 255);// fractally
    if(mode  == 16) img.pixels[i] = color(x/800.0 * 255,sin(ri*rx*100000)*255,y/800.0 * 255);// fractally
    if(mode  == 17) img.pixels[i] = color(x/800.0 * 255,sin(ri*ri)*255,y/800.0 * 255);// fractally
    if(mode  == 18) img.pixels[i] = color(x/800.0 * 255,sin(ri*ri*100)*255,y/800.0 * 255);// fractally
    if(mode == 19)img.pixels[i] = color(x/800.0 * 255,sin(ri*ri*100000)*255,y/800.0 * 255);// fractally
    
    if(mode == 20)img.pixels[i] = color(x/800.0 * 255,sin(x/((y+1)))*255,y/800.0 * 255);//forever rays
    if(mode == 21)img.pixels[i] = color(x/800.0 * 255,sin(x/((y+1)*.1))*255,y/800.0 * 255);//forever rays
    if(mode == 22)img.pixels[i] = color(x/800.0 * 255,sin(x*.1/((y+1)*.1))*255,y/800.0 * 255);//forever rays
    if(mode == 23)img.pixels[i] = color(0,sin(ri/((ry+1)))*255,0);//forever rays
    if(mode == 24)img.pixels[i] = color(0,sin(ri/((ry+1)*.1))*255,0);//forever rays
    
    if(mode == 25)img.pixels[i] = color(x/800.0 * 255,tan(ri)*sin(rx)*255,y/800.0 * 255);//vertical bars
    if(mode == 26)img.pixels[i] = color(x/800.0 * 255,tan(rx)*sin(x)*255,y/800.0 * 255);//vertical bars
    if(mode == 27)img.pixels[i] = color(x/800.0 * 255,tan(rx)*sin(i)*255,y/800.0 * 255);//vertical bars
    if(mode == 28)img.pixels[i] = color(x/800.0 * 255,tan(rx)*sin(ri)*255,y/800.0 * 255);//vertical bars
    if(mode == 29)img.pixels[i] = color(x/800.0 * 255,tan(rx)*sin(rx)*255,y/800.0 * 255);//vertical bars
    if(mode == 30)img.pixels[i] = color(x/800.0 * 255,tan(rx)*cos(rx)*255,y/800.0 * 255);//vertical bars
    if(mode == 31)img.pixels[i] = color(x/800.0 * 255,sin(rx)*cos(rx)*255,y/800.0 * 255);//vertical bars
    if(mode == 32)img.pixels[i] = color(x/800.0 * 255,sin(ry)*cos(ry)*255,y/800.0 * 255);//horizontal bars
    if(mode == 33)img.pixels[i] = color(x/800.0 * 255,sin(ry)*cos(rx)*255,y/800.0 * 255);//'plasma' blobs
    
    if(mode == 34)img.pixels[i] = color(x/800.0 * 255,(sin(ry)/cos(rx))*255,y/800.0 * 255);//bow ties
    if(mode == 35)img.pixels[i] = color(x/800.0 * 255,(sin(ry)-cos(rx))*255,y/800.0 * 255);//diamonds
    if(mode == 36)img.pixels[i] = color(x/800.0 * 255,(sin(ry)*cos(rx)/tan(rx))*255,y/800.0 * 255);//sliced
    if(mode == 37)img.pixels[i] = color(x/800.0 * 255,(sin(ry)*cos(rx)/tan(ri))*255,y/800.0 * 255);//
    if(mode == 38)img.pixels[i] = color(x/800.0 * 255,(sin(rx)*cos(ry)+tan(ry))*255,y/800.0 * 255);//bumps
    if(mode == 39)img.pixels[i] = color(x/800.0 * 255,((tan(ry)-sin(rx))*cos(i))*255,y/800.0 * 255);//bumps
    
    if(mode == 40)img.pixels[i] = color(x/800.0 * 255,((tan(rx)-sin(ry))*cos(ri))*255,y/800.0 * 255);//bumps
    if(mode == 41)img.pixels[i] = color(x/800.0 * 255,((sin(ry)-sin(rx))/sin(ri))*255,y/800.0 * 255);//bumps
    
    //pixely
    if(mode == 42)img.pixels[i] = color(x/800.0 * 255,sin(x)*cos(y)*255,y/800.0 * 255);//bumps
    if(mode == 43)img.pixels[i] = color(x/800.0 * 255,tan(x)*sin(i)*255,y/800.0 * 255);//bumps
    if(mode == 44)img.pixels[i] = color(x/800.0 * 255,((tan(y)-sin(x))*cos(i))*255,y/800.0 * 255);//bumps
    
  }
  img.updatePixels();
  img.filter(GRAY);
} 
void draw(){
  background(0);
  image(img,mapX,mapY);
}
void mousePressed() {
  prevX = mapX;
  prevY = mapY;
  mouseClickX = mouseX;
  mouseClickY = mouseY;
}
void keyPressed(){
  if(keyCode == LEFT && mode > 1) mode--;
  if(keyCode == RIGHT && mode < 44) mode++;
  println("mode: " + mode);
  mode(mode);
  if(key == 's') img.save("mode"+mode+"-"+day()+"-"+month()+"-"+year()+"_"+hour()+"_"+second()+"_"+millis()+".png");  
}
void mouseDragged() {
  mapX = prevX + mouseX - mouseClickX;
  mapY = prevY + mouseY - mouseClickY;  
  if(mapX < -img.width+width) mapX = -img.width+width;
  if(mapY < -img.height+width) mapY = -img.height+width;
  if(mapX > 0) mapX = 0;
  if(mapY > 0) mapY = 0;
}

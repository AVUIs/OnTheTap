/*
* mostly based on Alasdair Turner's 2D CA Glider Sketch
* http://www.openprocessing.org/sketch/7026
*/
class CA2D{
  
  int numX = 64;
  int numY = 64;
  int cellSize = 16;
  int numCells = numX*numY; 
  
  boolean[][] currState;
  boolean[][] nextState;
  
  
  int [][] indices;//x,y indices LUT
  int activeCells = 0;//live cell counter
  
  //pixel circles look up table
  int maxRadius = 64;
  PImage[] circleLUT = new PImage[maxRadius];
  
  CA2D(int nx,int ny,int cs){
    numX = nx;
    numY = ny;
    cellSize = cs;
    numCells = numX*numY;
    currState = new boolean[numX*cellSize][numY*cellSize];
    nextState = new boolean[numX*cellSize][numY*cellSize];
    indices = new int[numCells][2];
    //cache indices -> single loop instead of nested
    for(int i = 0 ; i < numCells; i++){
      indices[i][0] = i % numX;
      indices[i][1] = i / numX; 
    }
    for(int i = 0 ; i < maxRadius; i++) circleLUT[i] = createCircle(i+3); 
  }
  //draws a pixel circle
  PImage createCircle(int cSize){
    PGraphics circle = createGraphics(cSize,cSize);
    circle.beginDraw();
    circle.noSmooth();circle.noFill();circle.stroke(255);
    circle.ellipseMode(CORNER);
    circle.background(0);
    circle.ellipse(0,0,cSize-1,cSize-1);
    circle.endDraw();
    return circle;
  }
  void circle(int x,int y,int size){
    PImage c = circleLUT[size];
    int w = c.width;
    int h = c.height;
    int hw = w/2;
    int hh = h/2;
    for(int i = 0 ; i < numCells; i++){
        int px = indices[i][0];
        int py = indices[i][1];
        int dx = px+x;
        int dy = py+y;
        dx -= hw;
        dy -= hh;
        if(dx < 0) dx += w;
        if(dy < 0) dy += h;
        currState[dx][dy] = c.get(px,py) > 0xFF000000;
    }
  }
  
  void update(){
    activeCells = 0;
    for(int c = 0 ; c < numCells; c++){
        int i = indices[c][0];
        int j = indices[c][1];
        int counter = 0;
        if(currState[i][j]) activeCells++;
        for(int m=-1; m <= 1; ++m){
          for(int k=-1;k<=1; ++k){
            if(!(m == 0 && k == 0)){
              if(currState[(i+m+numX)%numX][(j+k+numY)%numY]){
                counter++;
              }
              if(counter < 2 || counter > 3){
                nextState[i][j] = false;
              }else if(counter == 3){
                nextState[i][j] = true;
              }else{
                nextState[i][j] = currState[i][j]; 
              }
            }
          }
        }
      
    }
    for(int c = 0 ; c < numCells; c++){
        int i = indices[c][0];
        int j = indices[c][1];
        currState[i][j] = nextState[i][j];
    }
  }
  
}

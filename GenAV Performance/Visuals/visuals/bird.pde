

class Bird { 
  float ypos, speed, offset;
  Bird (float y, float s, float o) {  

    ypos = y; 
    speed = s;
    offset = o;
  } 

  void display() {

    background(0);
    for (int i = 0; i < 100; i=i+50)
    {
      strokeWeight(1);
      stroke(255, one, two);
      float x1 = map(i, 0, 100, 100, width/2);
      float x2 = map(i+1, 0, 100, 100, width/2);

      int offNum = 100;

      noFill();


      theta += 0.02 * 100*onAmp ;

      posX = radiusX * cos( theta );
      posY = radiusY * sin( theta );
      pushMatrix();

      translate( width/2, height/2 );
      fill( 255, 100 ); 

      for (int dd = 0; dd < 5; dd++) {

        fill(100, 30*dd, 30*dd, 30*dd);


        line( 0, -200- 10*-dd, width/2-400-theX*width, -posY-100);
        line( 0, -200- 10*-dd, -width/2+400+theX*width, -posY-100);


        line( 0, 10*dd, width/2-400-theX*width, -posY);
        line( 0, 10*dd, -width/2+400+theX*width, -posY);


        line( 0, 200+ 10*dd, width/2-400-theX*width, -posY+100);
        line( 0, 200+ 10*dd, -width/2+400+theX*width, -posY+100);
      }
      popMatrix();
    }
  }
}


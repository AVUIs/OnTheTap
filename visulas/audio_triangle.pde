
class Interface { 
  float ypos, speed, offset;

  int historySize = 25;
  float[][] waveforms;

  Interface (float y, float s, float o) {  
    ypos = y; 
    speed = s;
    offset = o;
  } 

  void setupAudio() {
    waveforms = new float[historySize][in.bufferSize()];
    for (int i = 0; i  < historySize; i++) waveforms[i] = new float[in.bufferSize()];
  }



  void updateWaveforms(float[] current) {

    for (int i = historySize - 1; i > 0; i--) waveforms[i] = waveforms[i-1];

    waveforms[0] = current;
  }


  int now, delay = 30;
  void BgDisplay() { 

    if (millis() - now >= delay) {

      updateWaveforms(in.left.toArray()); 
      now = millis();
    }

    pushMatrix();
    translate(100, 0, -100);

    for (int i = 0; i < historySize; i++) {

      float yOffset = i * 10;
      float[] w = waveforms[i];

      strokeWeight(1 +onAmp*10);

      beginShape(LINES);
      for (int j = 0; j < w.length; j++) {
        stroke(2, three, 253);
        vertex(j, 00 + yOffset + w[j]*150);
      }

      for (int j = 0; j < w.length; j++) {
        stroke(four, 242, 0);
        vertex(j, 250 + yOffset + w[j]*150);
      }
      for (int j = 0; j < w.length; j++) {
        stroke(250, 20, two);
        vertex(j, 450 + yOffset + w[j]*150);
      }



      endShape();
    }
    popMatrix();
  }


  void display() { 

    fill(0);
    noStroke();
    triangle(0, 0, width/2+75, 0, 170, 740);
    triangle(width/2-75, 0, 1063, 739, width, 0);
  }
} 


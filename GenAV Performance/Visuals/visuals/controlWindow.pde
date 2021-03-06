
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}


// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;



  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);


    cp5.addSlider("1st Slider").plugTo(parent, "one").setRange(0, 255).setPosition(20, 30);
    cp5.addSlider("2nd Slider").plugTo(parent, "two").setRange(0, 255).setPosition(20, 60);
    cp5.addSlider("3nd Slider").plugTo(parent, "three").setRange(0, 255).setPosition(20, 90);
    cp5.addSlider("4nd Slider").plugTo(parent, "four").setRange(0, 255).setPosition(20, 120);




    cp5 = new ControlP5(this);
    r = cp5.addRadioButton("radioButton")
      .setPosition(20, 160)
        .setSize(40, 20)
          .setColorForeground(color(120))
            .setColorActive(color(255))
              .setColorLabel(color(255))
                .setItemsPerRow(5)
                  .setSpacingColumn(50)
                    .addItem("Triangle", 1)
                      .addItem("Lines", 2)
                        .addItem("Bird", 3)
                          .addItem("200", 4)
                            .addItem("250", 5)
                              ;

    for (Toggle t : r.getItems ()) {
      t.captionLabel().setColorBackground(color(255, 80));
      t.captionLabel().style().moveMargin(-7, 0, 0, -3);
      t.captionLabel().style().movePadding(7, 0, 0, 3);
      t.captionLabel().style().backgroundWidth = 45;
      t.captionLabel().style().backgroundHeight = 13;
    }
  }

  public void draw() {
    background(0);
  }

  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }


  ControlP5 cp5;

  Object parent;

  void keyPressed() {
    switch(key) {
      case('0'): 
      r.deactivateAll(); 
      break;
      case('1'): 
      r.activate(0); 
      break;
      case('2'): 
      r.activate(1); 
      break;
      case('3'): 
      r.activate(2); 
      break;
      case('4'): 
      r.activate(3); 
      break;
      case('5'): 
      r.activate(4); 
      break;
    }
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(r)) {
    }
  }

  void radioButton(int a) {
    println("a radio Button event: "+a);

    if ( a == 1) {
      // actvats the class H1 function 
      change = 1;

      // chnages the background color
      myColorBackground = color(0, 0, 0);
    }
    if ( a == 2) {
      change = 2;
      myColorBackground = color(255, 255, 0);
    }
    if ( a == 3) {
      change = 3;
      background(0);
    }
    if ( a == 4) {
      change = 4;
    
     
    }
    if ( a == 5) {
      change = 5;

    }
  }
}


class BlackHoleInfo implements Page {
  boolean running;
  long preClickTime_ms, maxTimeBetweenDblClick_ms;
  int justClickOnPage = -1, preClickOnPage = -1; 
  int nextPage = -1;
  boolean hoveringBackBtn = false;

  boolean entering = false;
  boolean leaving = false;
  float entryCameraScale = 0.5;
  float entryCameraScaleChangeEachFrame = 0.025;
  float leaveCameraScale = 1;
  float leaveCameraScaleChangeEachFrame = 0.025;

  PImage BgOfbh;
  PImage BlackHole;
  PFont font4;




  BlackHoleInfo() {
    running = false;
    preClickTime_ms = -1;
    maxTimeBetweenDblClick_ms = 400;

    BgOfbh = loadImage("blackHole/IBG.jpeg");
    BlackHole = loadImage("blackHole/BlackHole.jpeg");
    font4=loadFont("blackHole/Serif-48.vlw");
  }

  void draw() {
    background(0);

    if (entering) {
      if (entryCameraScale >= 1)
      {
        entering = false;
        entryCameraScale = 0.5;
      } else {
        camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) * entryCameraScale, width/2.0, height/2.0, 0, 0, 1, 0);
        entryCameraScale += entryCameraScaleChangeEachFrame;
      }
    }

    image(BgOfbh, 0, 0); 
    BgOfbh.resize(width, height);
    image(BlackHole, 0.65*width, 0.15*height);
    BlackHole.resize((int)(0.32*width), (int)(0.7*height));
    stroke(255);
    noFill();
    strokeJoin(ROUND);
    strokeWeight(5);
    rect(0.65*width, 0.15*height, (int)(0.32*width), (int)(0.7*height));
    rect(0.05*width, 0.15*height, (int)(0.55*width), (int)(0.7*height));
    textFont(font4, 32*height/900);
    text("Black Hole: ", 0.07*width, 0.21*height);
    textFont(font4, 25*height/900);
    textLeading(38*height/900);
    text(" A black hole is a region of spacetime exhibiting such strong\ngravitational effects that nothing—not even particles and \nlectromagnetic radiation such as light—can escape from inside it. \n The theory of general relativity predicts that a sufficiently compact\n mass can deform spacetime to form a black hole. Stellar black \n holes are made when the center of a very big star falls in upon itself, \n or collapses. When this happens, it causes a supernova which is an\nexploding star that blasts part of the star into space. It's now believed\nthat black holes are not only common throughout the Cosmos but \n they play a fundamental role in the formation and evolution of the\n Universe we inhabit today. \nIn fact, we would not be here without them.", 0.07*width, 0.26*height);

    buttonPatternOfNebula();
  }

  void buttonPatternOfNebula() {
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);

    //rect(0.05*width, 0.19*height+(int)(0.7*height), 0.13*width, 0.06*height);
    rect(0.05*width, 0.89*height, 0.13*width, 0.06*height);
    textFont(font4, 27*height/900);
    text("Back to Menu", 0.06*width, 0.23*height+(int)(0.7*height));
  }

  void hoveringBackBtn() {
    if (mouseX >= 0.05*width && mouseY >= 0.89*height
      && mouseX <= (0.13 + 0.05)*width && mouseY <= (0.89 + 0.06)*height)
      hoveringBackBtn = true;
    else
      hoveringBackBtn = false;
  }


  void setRunning(boolean running) {
    this.running = running;
  }
  void toggleRunning() {
    running = !running;
  }
  boolean isRunning() {
    return running;
  }


  void mouseWheel(MouseEvent event) {
  } 

  void mouseDragged() {
  }

  void mouseMoved() {
  }

  void mousePressed() {
  }

  void keyPressed() {
  }

  void mouseReleased() {
  }

  void mouseClicked() {
    //justClickOnPage, preClickOnPage:
    //0 for BlackHole, 2 for galaxyInfo, 3 for nebula, 4 for planetaryNebula, 5 for solar
    long clickTime_ms = System.currentTimeMillis();

    hoveringBackBtn();
    if (hoveringBackBtn)
      justClickOnPage = 1;
    else
      justClickOnPage = -1;

    
    //check if this is a double click on a page option
    if (justClickOnPage >= 0 && justClickOnPage == preClickOnPage
      && clickTime_ms - preClickTime_ms < maxTimeBetweenDblClick_ms) {
      nextPage = justClickOnPage;
      preClickOnPage = -1;


      leaving = false;
      leaveCameraScale = 1;
      running = false;
      pages[nextPage].enter();
      nextPage = -1;

      //switch the audio effect
      if (running==false)
      {               
        M2.pause( );
        M1.play( );
      }
    } else {
      preClickTime_ms = clickTime_ms;
      preClickOnPage = justClickOnPage;
    }
  }

  void enter() {
    entering = true;
    running = true;

    //switch the audio effect
    M1.pause( );
    M2.rewind( ); 
    M2.play( );
  }
}
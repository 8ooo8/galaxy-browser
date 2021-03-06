class GalaxyInfo implements Page {
  boolean running;
  long preClickTime_ms, maxTimeBetweenDblClick_ms = 400;
  int justClickOnPage = -1, preClickOnPage = -1; //0 for BlackHole, 2 for galaxyInfo, 3 for nebula, 4 for planetaryNebula, 5 for solar
  int nextPage = -1;
  boolean hoveringBackBtn = false;
  boolean entering = false;
  boolean leaving = false;
  float entryCameraScale = 0.5;
  float entryCameraScaleChangeEachFrame = 0.025;
  float leaveCameraScale = 1;
  float leaveCameraScaleChangeEachFrame = 0.025;


  PImage BgOfGalaxy;
  PImage Galaxy;
  PFont font5;

  GalaxyInfo() {
    running = false;
    BgOfGalaxy = loadImage("galaxyInfo/IBG.jpeg");
    Galaxy = loadImage("galaxyInfo/Galaxy.jpeg");
    font5=loadFont("galaxyInfo/Serif-48.vlw");
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
        //print("entryCameraScale: " + entryCameraScale);
      }
    }
   

    image(BgOfGalaxy, 0, 0); 
    BgOfGalaxy.resize(width, height);
    image(Galaxy, 0.65*width, 0.15*height);
    Galaxy.resize((int)(0.32*width), (int)(0.7*height));
    stroke(255);
    noFill();
    strokeJoin(ROUND);
    strokeWeight(5);
    rect(0.65*width, 0.15*height, (int)(0.32*width), (int)(0.7*height));
    rect(0.05*width, 0.15*height, (int)(0.55*width), (int)(0.7*height));
    textFont(font5, 32*height/900);
    text("Galaxy: ", 0.07*width, 0.21*height);
    textFont(font5, 25*height/900);
    textLeading(38*height/900);
    text("The Milky Way is the galaxy that contains our Solar System.\n The descriptive \"milky\" is derived from the appearance from Earth\n of the galaxy – a band of light seen in the night sky formed from\n stars that cannot be individually distinguished by the naked eye. \n From Earth, the Milky Way appears as a band because its disk-shaped \n structure is viewed from within. Galileo Galilei first resolved the band of \n light into individual stars with his telescope in 1610. Until the early \n 1920s, most astronomers thought that the Milky Way contained all \n the stars in the Universe. Following the 1920 Great Debate between\nthe astronomers Harlow Shapley and Heber Curtis, observations by \n Edwin Hubble showed that the Milky Way is just one of many galaxies.", 0.07*width, 0.26*height);

    buttonPatternOfGalaxy();
  }

  void buttonPatternOfGalaxy() {
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);

    //rect(0.05*width, 0.19*height+(int)(0.7*height), 0.13*width, 0.06*height);
    rect(0.05*width, 0.89*height, 0.13*width, (0.06)*height);
    textFont(font5, 27*height/900);
    text("Back to Menu", 0.06*width, 0.23*height+(int)(0.7*height));
  }

  void hoveringBackBtn() {
    if (mouseX >= 0.05*width && mouseY >= 0.89*height
      && mouseX <= (0.05 + 0.13)*width && mouseY <= (0.89 + 0.06)*height)
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
    
    //print(hoveringBackBtn + ", ");

    if (hoveringBackBtn)
      justClickOnPage = 1;
    else
      justClickOnPage = -1;

    
    //check if this is a double click on a page option
    if (justClickOnPage >= 0 && justClickOnPage == preClickOnPage
      && clickTime_ms - preClickTime_ms < maxTimeBetweenDblClick_ms) {
      nextPage = justClickOnPage;
      preClickOnPage = -1;

      //print("aaaaaaa");
      leaving = false;
      leaveCameraScale = 1;
      running = false;
      pages[nextPage].enter();
      nextPage = -1;
      
      //switch the audio effect
      
      if(running==false)
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
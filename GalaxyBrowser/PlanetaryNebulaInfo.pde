class PlanetaryNebulaInfo implements Page {
  boolean running;
  long preClickTime_ms, maxTimeBetweenDblClick_ms = 400;
  int justClickOnPage = -1, preClickOnPage = -1; 
  int nextPage = -1;
  boolean hoveringBackBtn = false;

  boolean entering = false;
  boolean leaving = false;
  float entryCameraScale = 0.5;
  float entryCameraScaleChangeEachFrame = 0.025;
  float leaveCameraScale = 1;
  float leaveCameraScaleChangeEachFrame = 0.025;


  PImage BgOfPlanetaryNebula;
  PImage PlanetaryNebula;
  PFont font3;

  PlanetaryNebulaInfo() {
    running = false;
    preClickTime_ms = -1;
    maxTimeBetweenDblClick_ms = 400;
    BgOfPlanetaryNebula = loadImage("planetaryNebulaInfo/IBG.jpeg");
    PlanetaryNebula = loadImage("planetaryNebulaInfo/planetarynebula.jpeg");
    font3=loadFont("planetaryNebulaInfo/Serif-48.vlw");
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

    image(BgOfPlanetaryNebula, 0, 0); 
    BgOfPlanetaryNebula.resize(width, height);
    image(PlanetaryNebula, 0.65*width, 0.15*height);
    PlanetaryNebula.resize((int)(0.32*width), (int)(0.7*height));
    stroke(255);
    noFill();
    strokeJoin(ROUND);
    strokeWeight(5);
    rect(0.65*width, 0.15*height, (int)(0.32*width), (int)(0.7*height));
    rect(0.05*width, 0.15*height, (int)(0.55*width), (int)(0.7*height));
    textFont(font3, 32*height/900);
    text("Planetary Nebula: ", 0.07*width, 0.21*height);
    textFont(font3, 25*height/900);
    textLeading(38*height/900);
    text(" A planetary nebula is a kind of emission nebula consisting of an \n expanding, glowing shell of ionized gas ejected from old red giant \n stars late in their lives. They are a relatively short-lived phenomenon,\nlasting a few tens of thousands of years, compared to a typical\nstellar lifetime of several billion years. A mechanism for formation\n of most planetary nebulae is thought to be the following: at the end\nof the star's life, during the red-giant phase, the outer layers of the\nstar are expelled by strong stellar winds. After most of the red giant's\natmosphere is dissipated, the ultraviolet radiation of the hot\nluminous core, called a planetary nebula nucleus (PNN), ionizes\nthe outer layers earlier ejected from the star.Absorbed ultraviolet\nlight energises the shell of nebulous gas around the central star, \n causing it to appear as a brightly coloured planetary nebula.", 0.07*width, 0.26*height);

    buttonPatternOfNebula();
  }

  void buttonPatternOfNebula() {
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);

    rect(0.05*width, 0.19*height+(int)(0.7*height), 0.13*width, 0.06*height);
    textFont(font3, 27*height/900);
    text("Back to Menu", 0.06*width, 0.23*height+(int)(0.7*height));
  }

  void hoveringBackBtn() {
    if (mouseX >= 0.05*width && mouseY >= 0.19*height+(int)(0.7*height)
      && mouseX <= (0.05 + 0.13)*width && mouseY <= 0.06*height + 0.19*height+(int)(0.7*height))
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
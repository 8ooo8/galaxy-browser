class NebulaInfo implements Page {
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



  PImage BgOfNebula;
  PImage Nebula;
  PFont font2;

  NebulaInfo() {
    running = false;
    preClickTime_ms = -1;
    maxTimeBetweenDblClick_ms = 400;

    BgOfNebula = loadImage("nebulaInfo/IBG.jpeg");
    Nebula = loadImage("nebulaInfo/nebula.jpeg");
    font2=loadFont("nebulaInfo/Serif-48.vlw");
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

    image(BgOfNebula, 0, 0); 
    BgOfNebula.resize(width, height);
    image(Nebula, 0.65*width, 0.15*height);
    Nebula.resize((int)(0.32*width), (int)(0.7*height));
    stroke(255);
    noFill();
    strokeJoin(ROUND);
    strokeWeight(5);
    rect(0.65*width, 0.15*height, (int)(0.32*width), (int)(0.7*height));
    rect(0.05*width, 0.15*height, (int)(0.55*width), (int)(0.7*height));
    textFont(font2, 32*height/900);
    text("Nebula: ", 0.07*width, 0.21*height);
    textFont(font2, 25*height/900);
    textLeading(38*height/900);
    text("A nebula is an interstellar cloud of dust, hydrogen, helium and other\nionized gases. Originally, nebula was a name for any diffuse astronomical\nobject,including galaxies beyond the Milky Way. Most nebulae are of vast\nsize,even millions of light years in diameter. Contrary to fictional\ndepictions where starships hide in nebulae as thick as cloud banks,\n in reality a nebula that is barely visible to the human eye from \n Earth would appear larger,but no brighter,from close by. Many nebulae\nare visible due to their fluorescence caused by the embedded hot stars,\nwhile others are so diffuse they can only be detected with long \nexposures and special filters.In these regions the formations of gas,\ndust,and other materials \"clump\" together to form denser regions,\nwhich attract further matter, and eventually will become dense enough\nto form stars.The remaining material is then believed to form planets\nand other planetary system objects. ", 0.07*width, 0.26*height);

    buttonPatternOfNebula();
  }


  void buttonPatternOfNebula() {
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);

    rect(0.05*width, 0.19*height+(int)(0.7*height), 0.13*width, 0.06*height);
    textFont(font2, 27*height/900);
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
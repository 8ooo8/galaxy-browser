class Galaxy implements Page {
  boolean running;
  long preClickTime_ms, maxTimeBetweenDblClick_ms;
  boolean hoveringSolar, hoveringNebula, hoveringBlackHole, hoveringPlanetaryNebula, hoveringGalaxyInfo;
  int justClickOnPage = -1, preClickOnPage = -1; //0 for BlackHole, 2 for galaxyInfo, 3 for nebula, 4 for planetaryNebula, 5 for solar
  int nextPage = -1;
 
  boolean entering = false;
  boolean leaving = false;
  float entryCameraScale = 0.5;
  float entryCameraScaleChangeEachFrame = 0.025;
  float leaveCameraScale = 1;
  float leaveCameraScaleChangeEachFrame = 0.2;


  PImage fist; // declare a variable of PImage data type
  PFont font;
  PFont font6;


  Button solar;
  Button nebula;
  Button blackhole;
  Button planetarynebula;

  Galaxy() {
    running = false;
    preClickTime_ms = -1;
    maxTimeBetweenDblClick_ms = 400;
    hoveringSolar = false;
    hoveringNebula = false;
    hoveringBlackHole = false;
    hoveringPlanetaryNebula = false;
    hoveringGalaxyInfo = false;


    font = loadFont("galaxy/AppleGothic-48.vlw");
    font6= loadFont("galaxy/Serif-48.vlw");
    
    fist = loadImage("galaxy/bk.jpeg"); // load the image file into computer memory
   

    solar = new Button(width*0.64533335, height*0.6128266, 28);
    nebula = new Button(0.23*width, 0.63*height, 28);
    blackhole = new Button(0.475*width, 0.485*height, 28);
    planetarynebula = new Button(0.485*width, 0.729*height, 28);
  }

  void enter(){
    entering = true;
    running = true;
  }
  void draw() {
    background(0);
    if (entering) {
      if (entryCameraScale >= 1)
      {
        entering = false;
        entryCameraScale = 0.5;
      }else{
        camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) * entryCameraScale, width/2.0, height/2.0, 0, 0, 1, 0);
        entryCameraScale += entryCameraScaleChangeEachFrame;
        //print("entryCameraScale: " + entryCameraScale);
      }
    }
    
    
    image(fist, 0, 0); // display the image at point (300, 300)
    fist.resize(width, height);


    nebula.rollOver();
    blackhole.rollOver();
    planetarynebula.rollOver();
    guide();
    ToSolar();
    GuideBlackHole();
    ToBlackHole();
    GuidePlanetaryNebula();
    ToPlanetaryNebula();
    GuideNebula();
    ToNebula();
    galaxyInfo();
  }

  void galaxyInfo() {
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);
    rect(0.06*width, 0.08*height, 0.16*width, 0.05*height);
    textFont(font6, 27*height/900);
    fill(255);
    text("More about Galaxy", 0.07*width, 0.118*height);
  }

  void hoverGalaxyInfo() {
    if (mouseX >= 0.06*width && mouseY >= 0.08*height && 
        mouseX <=  (0.06 + 0.16)*width && mouseY <= (0.08 + 0.05)*height)
    {
      hoveringGalaxyInfo = true;
    }else
      hoveringGalaxyInfo = false;
  }

  void guide() {
    stroke(255);
    strokeWeight(10);
    point(width*0.64533335, height*0.6128266);
    strokeWeight(2);
    line(width*0.64533335, height*0.6128266, 0.75*width, 0.70*height);
    line(0.75*width, 0.70*height, 0.80*width, 0.70*height);
    textFont(font, 30*height/900);
    fill(255);
    text("You are here !", 0.81*width, 0.71*height);
  }

  void ToBlackHole() {
    if (0.45*width<=mouseX&& mouseX<=0.50*width && 0.46*height<=mouseY && mouseY<=0.51*height)
    {
      hoveringBlackHole = true;
      fill(255, 233, 159, 200);
      ellipse(width*0.475, height*0.485, 28, 28);

      fill(255);
      stroke(255);
      line(width*0.475, height*0.485, 0.4*width, 0.3*height);
      line(0.4*width, 0.3*height, 0.36*width, 0.3*height);
      textFont(font, 27*height/900);
      fill(255);
      text("Black Hole", 0.27*width, 0.31*height);
    } else {
      hoveringBlackHole = false;
    }
  }

  void GuideBlackHole() {
    noStroke();
    fill(255, 50);
    // ellipse(0.475*width,0.485*height, 40,40);
    fill(0);
    for (int i=1; i<2; i++) {
      float r=random(5, 10);
      ellipse(0.475*width, 0.485*height, r, r);
    }
  }


  void GuideNebula() {
    noStroke();
    fill(255, 50);
    // ellipse(0.475*width,0.485*height, 40,40);
    fill(255, 244, 81);
    for (int i=1; i<2; i++) {
      float r=random(5, 10);
      ellipse(0.23*width, 0.63*height, r, r);
    }
  }


  void GuidePlanetaryNebula() {
    noStroke();
    fill(255, 50);
    // ellipse(0.475*width,0.485*height, 40,40);
    fill(255, 244, 81);
    for (int i=1; i<2; i++) {
      float r=random(5, 10);
      ellipse(0.485*width, 0.729*height, r, r);
    }
  }

  void ToPlanetaryNebula() {

    if (0.46*width<=mouseX&& mouseX<=0.51*width && 0.70*height<=mouseY && mouseY<=0.76*height)
    {
      hoveringPlanetaryNebula = true;
      fill(255, 233, 159, 200);
      stroke(255);
      ellipse(width*0.485, height*0.729, 28, 28);
      stroke(255);
      line(width*0.485, height*0.729, 0.544*width, 0.833*height);
      line(0.544*width, 0.833*height, 0.57*width, 0.833*height);
      textFont(font, 27*height/900);
      fill(255);
      text("Planetary Nebula", 0.58*width, 0.84*height);
    } else {
      hoveringPlanetaryNebula = false;
    }
  }

  void ToNebula() {

    if (0.20*width<=mouseX&& mouseX<=0.26*width && 0.60*height<=mouseY && mouseY<=0.66*height)
    {
      hoveringNebula = true;
      fill(255, 233, 159, 200);
      stroke(255);
      ellipse(width*0.23, height*0.63, 28, 28);
      stroke(255);
      line(width*0.23, height*0.63, 0.18*width, 0.39*height);
      line(0.18*width, 0.39*height, 0.15*width, 0.39*height);
      textFont(font, 27*height/900);
      fill(255);
      text("Nebula", 0.08*width, 0.40*height);
    } else {
      hoveringNebula = false;
    }
  }

  void ToSolar() {

    if (0.60*width<=mouseX&& mouseX<=0.68*width && 0.55*height<=mouseY && mouseY<=0.65*height)
    {
      hoveringSolar = true;
      fill(255, 233, 159, 200);
      ellipse(width*0.64533335, height*0.6128266, 28, 28);
    } else {
      hoveringSolar = false;
    }
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

    hoverGalaxyInfo();

    if (hoveringBlackHole)
      justClickOnPage = 0;
    else if (hoveringGalaxyInfo) //TO BE IMPLEMENTED. FOR GALAXY INFO. **********************************
      justClickOnPage = 2;
    else if (hoveringNebula)
      justClickOnPage = 3;
    else if (hoveringPlanetaryNebula)
      justClickOnPage = 4;
    else if (hoveringSolar)
      justClickOnPage = 5;
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
    } else {
      preClickTime_ms = clickTime_ms;
      preClickOnPage = justClickOnPage;
    }
  }
  
  class Button {
  float x, y;
  int r;
  Button( float tempX, float tempY, int tempR) {
    x=tempX;
    y=tempY;
    r=tempR;
  }

  boolean rollOver() {
    if (x-r<=mouseX&& mouseX<=x+r && y-r<=mouseY && mouseY<=y+r)
    {

      return true;
    }
    return false;
  }

  boolean ButtonPressed() {
    if (rollOver()&&mousePressed) {
      //what
      return true;
    }
    return false;
  }
}
}
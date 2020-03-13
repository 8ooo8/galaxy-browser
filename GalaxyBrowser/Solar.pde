import java.util.*;

class Solar implements Page {
  //int testCounter = 0; //for test purpose


  boolean running;
  boolean entering = false;
  boolean leaving = false;
  int justClickOnPage = -1, preClickOnPage = -1; //0 for BlackHole, 2 for galaxyInfo, 3 for nebula, 4 for planetaryNebula, 5 for solar
  boolean backBtnClickedWhenShowingDescription = false;
  int nextPage = -1;
  float entryCameraScale = 0.5;
  float entryCameraScaleChangeEachFrame = 0.025;
  float leaveCameraScale = 1;
  float leaveCameraScaleChangeEachFrame = 0.1;
  boolean hoveringBackBtn = false;

  int canvasWidth = 1000, canvasHeight = 700;
  float scale = 0.5;
  float canvasCenterX = canvasWidth / 2, canvasCenterY = canvasHeight / 2, spaceCenterZ = 0;
  float viewAngle_Y = 0, viewAngle_X = 0;
  int viewerDistFromCenter = 600;
  int numOfStarsInBG = 3000;
  float minSpaceBGRadius = 10000, maxSpaceBGRadius = minSpaceBGRadius * 2;
  String nameFontPath = "solar/pfonts/Apple-Chancery-48.vlw";
  String descriptionFontPath = "solar/pfonts/ComicSansMS-Italic-48.vlw";                     

  float fontSizeWithNoScaleChange = 45, leastFontSize = 35;
  int fontFillColorH = 0, fontFillColorS = 0, fontFillColorB = 99;             
  int fontStrokeColorH = 0, fontStrokeColorS = 0, fontStrokeColorB = 99;


  String planetSurfaceImgPath = "solar/surfaces/";
  String spaceSurfacePath = planetSurfaceImgPath + "space.jpg";
  String sunSurfacePath = planetSurfaceImgPath + "sun5.jpg";
  String mercurySurfacePath = planetSurfaceImgPath + "mercury.jpg";
  String venusSurfacePath = planetSurfaceImgPath + "venus.jpg"; 
  String earthSurfacePath = planetSurfaceImgPath + "earth.jpg";
  String marsSurfacePath = planetSurfaceImgPath + "mars.jpg";
  String jupiterSurfacePath = planetSurfaceImgPath + "jupiter.jpg";
  String saturnSurfacePath = planetSurfaceImgPath + "saturn.jpg";
  String uranusSurfacePath = planetSurfaceImgPath + "uranus.jpg";
  String neptuneSurfacePath = planetSurfaceImgPath + "neptune.jpg"; 
  String moonSurfacePath = planetSurfaceImgPath + "moon.jpg";

  Planet[] planets;
  StarInBG[] stars;
  int drag_preMouseX = -1, drag_preMouseY = -1;
  int move_preMouseY = -1, move_preMouseX = -1;
  boolean mouseJustPressed = false;
  boolean lockViewAngle = false;
  boolean lockViewTranslation = false;
  boolean lockRevolution = false; 
  int idxOfPlanetBeingSelected = -1, idxOfPlanetShowingDetails = -1;

  int idxOfPreClickedPlanet = -1;
  long preClickTime_ms = -1, maxTimeBetweenDblClick_ms = 400;

  boolean movingCloseToAPlanet = false;
  boolean showingPlanetDetails = false;
  boolean dragging = false;
  Planet planetSelected = null, planetBeingDrawn = null;
  float planetSelectedOriginalX = -1, planetSelectedOriginalY = -1;
  float targetRadiusOverCanvasSize = 0.3;
  long startToMoveTime_ms = -1, endMoveTime_ms = -1;
  float currFovScale = 1, targetFovScale = -1;
  float cameraX = -1, cameraY = -1, cameraZ = -1;
  boolean justStartToMove = false;
  long timeForMovingFocusToAPlanet_ms = 200;
  float originalRadius2d = -1, targetScale = -1, originalScale = -1;
  float scaleChangeEachFrame = 0.1;
  boolean displayDescription = false;




  PFont fontForNameOfHighlightedPlanet;
  PFont fontForDescription;
  PGraphics textDisplayBuffer;

  boolean test = false;
  float test_moveDist = 1;


  Solar() {
    running = false;


    canvasWidth = width;
    canvasHeight = height;
    canvasCenterX = canvasWidth / 2;
    canvasCenterY = canvasHeight / 2;
    spaceCenterZ = 0;

    cameraX = canvasWidth / 2;
    cameraY = canvasHeight / 2;

    fontForNameOfHighlightedPlanet = loadFont(nameFontPath);
    fontForDescription = loadFont(descriptionFontPath);

    textDisplayBuffer = createGraphics(canvasWidth, canvasHeight, P2D);

    stars = new StarInBG[numOfStarsInBG];
    for (int i = 0; i < numOfStarsInBG; i++) {
      stars[i] = new StarInBG(minSpaceBGRadius*scale, maxSpaceBGRadius*scale, canvasCenterX, canvasCenterY, spaceCenterZ);
    }

    planets = new Planet[10];
    //planets = new Planet[2];
    planets[0] = new Planet(this, "Sun", "Name: Sun \nCategory: Star \nMass: 1.9891×10^30 kg \nDensity: 1.41 g/cm³\nDiameter: 1.392×10⁶ km \nDistance from Earth:\n       1.496×10^8 km\nSurface Temperature:\n       5770 K", "    The Sun is the star at the center of the Solar\nSystem. Today it is roughly halfway through the\nmost stable part of its life. It has not changed\ndramatically for over four billion years, and will\n    remain stable for more than five billion more.\n          However, after hydrogen fusion in its core\n              has stopped, the Sun will undergo \n                 severe changes,both internally and\n                  externally.The core of the Sun \n                  will experience a marked increase\n                  in density and temperature while\n                 its outer layers expand to \n                eventually become a red giant.\n             At the end, the ejected half of the Sun's\n        mass becoming ionised into a planetary nebula\n  which will disperse in about 10,000 years, but\nthe white dwarf will survive for trillions of\n", 100, PI / 10, 0, new PVector(0, 1, 0), canvasCenterX, canvasCenterY, spaceCenterZ, loadImage(sunSurfacePath));
    planets[3] = new Planet(this, "Earth", "Name: Earth\nCategory: Terrestrial Planet \nMass: 5.965×10^24kg \nDensity: 5.508 g/cm³\nDiameter: 12756 km\nSurface Temperature: 288K", "    Earth is the third planet from the Sunand\nthe only object in the Universe known to harbor\nlife. According to radiometric datingand other\nsources of evidence, Earth formed over 4 billion\nyears ago. Earth's gravityinteracts with other\nobjects in space, especially the Sun and the\nMoon, Earth's only natural satellite. Within the\nfirst billion years of Earth's history, life appeared\nin the oceans and began to 0affect the Earth's\natmosphere and surface, leading to the\nproliferation of aerobic and anaerobic\norganisms. Some geological evidence indicates\nthat life may have arisen as much as 4.1 billion\nyears ago. Since then, the combination of\nEarth's distance from the Sun, physical \nproperties, and geological history have allowed\nlife to evolve and thrive.  Over 7.4 billion humans\nlive on Earth and depend on its biosphere\nand natural resources for their survival.", planets[0].getRadius() / 15, PI / 10, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius()*2, PI/40, 3.4, new PVector(1, 20, 0), loadImage(earthSurfacePath));
    planets[1] = new Planet(this, "Mercury", "Name: Mercury\nCategory: Terrestrial Planet \nMass: 3.3022×10^23kg \nDensity: 5.43 g/cm³\nDiameter: 4878 km\nSurface Temperature: -90~700 K", "    Mercury is the smallest and innermost planet\nin the Solar System. Its orbital period around the\nsun of 88 days is the shortest of all the planets in\nthe Solar System. It is named after the Roman\ndeity Mercury, the messenger to the gods.\n    Like Venus, Mercury orbits the Sun within\nEarth's orbit as an inferior planet, so it can only\nbe seen visually in the morning or the evening sky.\nAlthough Mercury can appear as a bright star-like\nobject when viewed from Earth, its proximity to\nthe Sun often makes it more difficult to see than\nVenus.The planet has no known natural\nsatellites.", planets[3].getRadius() / 2.6, PI / 30, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius()*1.3, PI/10, 2.4, new PVector(1, 20, 0), loadImage(mercurySurfacePath));
    planets[2] = new Planet(this, "Venus", "Name: Venus\nCategory: Terrestrial Planet \nMass: 4.869×10^24kg \nDensity: 5.24 g/cm³\nDiameter: 12103.6 km\nSurface Temperature: 738~758 K", "Venus is the second planet from the Sun\nwith the longest rotation period (243 days) of\nany planet in the Solar System and rotates in\nthe opposite direction to most other planets. It\nis the second-brightest natural object in the\nnight sky after the Moon – bright enough to cast\nshadows at night and, rarely, visible to the\nnaked eye in broad daylight.\n    Venus is a terrestrial planet and is\nsometimes called Earth's \"sister planet\" \nbecause of their similar size, mass, proximity\nto the Sun, and bulk composition. It is radically\ndifferent from Earth in other respects. It has a\nmuch denser atmosphere, much higher\natmospheric pressure compared to Earth. It\nis by far the hottest planet in the Solar System,\neven though Mercury is closer to the Sun. ", planets[3].getRadius() / 1.1, PI / 100, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 1.7, PI/30, 1.7, new PVector(-1, 10, 0), loadImage(venusSurfacePath));  
    planets[4] = new Planet(this, "Mars", "Name: Mars\nCategory: Terrestrial Planet \nMass: 6.4219×10^23kg \nDensity: 3.94 g/cm³\nDiameter: 6794 km\nSurface Temperature: 210K", "    Mars is the fourth planet from the Sun and\nthe second-smallest planet in the Solar System\nafter Mercury. In English, Mars carries a name of\nthe Roman god of war, and is often referred to as\nthe Red Planet because the reddish iron oxide\nprevalent on its surface gives it a reddish \nappearance that is distinctive among the \nastronomical bodies visible to the naked eye.\nMars is a terrestrial planet with a thin \natmosphere, having surface features\nreminiscent both of the impact craters of the\nMoon and the valleys, deserts, and polar ice \ncaps of Earth.\n    There are ongoing investigations assessing\nthe past habitability potential of Mars, as well as\nthe possibility of extant life. Future astrobiology\nmissions are planned, including the Mars 2020\nand ExoMars rovers.", planets[3].getRadius() / 1.8, PI / 10, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 2.6, PI/70, 2.0, new PVector(-1, 10, 0), loadImage(marsSurfacePath));  
    planets[5] = new Planet(this, "Jupiter", "Name: Jupiter\nCategory: Gas Giant\nMass: 1.90×10^27kg \nDensity: 1.326 g/cm³\nDiameter: 142987km\nSurface Temperature: 105K", "        Jupiter is the fifth planet from the Sun and\nthe largest in the Solar System. It is a giant\nplanet with a mass one-thousandth that of the\nSun, but two-and-a-half times that of all the\nother planets in the Solar System combined.\nThe Romans named it after their god Jupiter.\n    Like the other giant planets, Jupiter lacks a\n       well-defined solid surface. Because of its\n          rapid rotation, the planet's shape is that\n           of an oblate spheroid . The outer\n            atmosphere is visibly segregated into\n           several bands at different latitudes,\n        resulting in turbulence and storms along\n     their interacting boundaries. A prominent\n  result is the Great Red Spot,a giant storm\nthat is known to have existed since at least\nthe 17th century when it was first seen by \ntelescope. Jupiter has at least 69 moons,\nthe largest of which,has a diameter greater\nthan that of Mercury.", planets[3].getRadius() / 0.09, PI / 4, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 3.6, PI/200, 3.0, new PVector(-1, 10, 0), loadImage(jupiterSurfacePath));   
    planets[6] = new Planet(this, "Saturn", "Name: Saturn\nCategory: Gas Giant\nMass: 5.688×10^26kg \nDensity: 0,70 g/cm³\nDiameter: 120540km\nSurface Temperature: 82~163K", "    Saturn is the sixth planetfrom the Sun and the\nsecond-largest in the Solar System, after Jupiter. \nIt is a gas giant named after the Roman god of\nagriculture. It has only one-eighth the average \ndensity of Earth, but with its larger volume\nSaturn is over 95 times more massive.\n    The planet's most famous feature is its\nprominent ring system that is composed mostly\nof ice particles, with a smaller amount of rocky\ndebris and dust. At least 62 moons are known to\norbit Saturn, of which 53 are officially named.\nThis does not include the hundreds of moonlets\nin the rings. Titan, Saturn's largest moon, and\nthe second-largest in the Solar System, is larger\nthan the planet Mercury, although less massive,\nand is the only moon in the Solar System to have\na substantial atmosphere.", planets[3].getRadius() / 0.15, PI / 4.5, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 5, PI/300, 0.6, new PVector(-1, 10, 0), loadImage(saturnSurfacePath)); 
    planets[7] = new Planet(this, "Uranus", "Name: Uranus\nCategory: Ice Giant\nMass: 8.6810×10^25 kg\nDensity: 1.318 g/cm³\nDiameter: 51118km\nSurface Temperature: 93K", "    Uranus is the seventh planet from the Sun.\nIt has the third-largest planetary radius and \nfourth-largest planetary mass in the Solar\nSystem.Uranus is similar in composition to\nNeptune, and both have different bulk chemical\ncomposition from that of the larger gas giants\nJupiter and Saturn. Uranus's atmosphere is\nsimilar to Jupiter's and Saturn's in its primary\ncomposition of hydrogen and helium, but it\ncontains more ices. It is the coldest planetary\natmosphere in the Solar System and its\ninterior is mainly composed of ices and rock.\n    Like the other giant planets, Uranus has a\nring system, a magnetosphere, and numerous \nmoons. The Uranian system has a unique \nconfiguration among those of the planets\nbecause its axis of rotation is tilted sideways,\nnearly into the plane of its solar orbit. Its north\nand south poles, therefore, lie where most\nother planets have their equators.", planets[3].getRadius() / 0.25, PI / 6, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 6.5, PI/500, 1.3, new PVector(-1, 10, 0), loadImage(uranusSurfacePath));  
    planets[8] = new Planet(this, "Neptune", "Name: Neptune\nCategory: Ice Giant\nMass: 1.0247×10^26 kg\nDensity: 1.66 g/cm³\nDiameter: 49,532 km\nSurface Temperature: 59K", "    Neptune is the eighth and farthest known\nplanet from the Sun in the Solar System. In\nthe Solar System, it is the fourth-largest\nplanet by diameter, the third-most-massive\nplanet, and the densest giant planet.It is\nnamed after the Roman god of the sea.\n    Neptune is not visible to the unaided eye\nand is the only planet in the Solar System\nfound by mathematical prediction rather than\nby empirical observation.\n    In contrast to the featureless atmosphere of\nUranus, Neptune's atmosphere has active\nand visible weather patterns. For example, \nat the time of the Voyager 2 flyby in 1989,\nthe planet's southern hemisphere had a Great\nDark Spot comparable to the Great Red Spot\non Jupiter. These weather patterns are driven\nby the strongest sustained winds of any planet\nin the Solar System.", planets[3].getRadius() / 0.27, PI / 6, planets[0], new PVector(1, 10, 1), 0, planets[0].getRadius() * 7.5, PI/900, 0.8, new PVector(-1, 10, 0), loadImage(neptuneSurfacePath));  
    planets[9] = new Planet(this, "Moon", "Name: Moon\nCategory: Natural satellite\nMass: 7.349×10^22kg \nDiameter: 3476.28 km\nSurface Temperature: 93~433K", "    The Moon is an astronomical body that orbits\n planet Earth, being Earth's only permanent\nnatural satellite.The Moon is thought to have\nformed about 4.51 billion years ago, not long\nafter Earth. The most widely accepted \nexplanation is that the Moon formed from the\ndebris left over after a giant impact between\nEarth and a Mars-sized body called Theia.\n    The Moon is in synchronous rotation with\nEarth, always showing the same face to us. As\nseen from the Earth, it is the second-brightest\nregularly visible celestial object in Earth's sky,\nafter the Sun. Its surface is actually dark,\nalthough compared to the night sky it appears\nvery bright, with a reflectance just slightly\nhigher than that of worn asphalt. Its\ngravitational influence produces the ocean\ntides, body tides, and the slight lengthening\nof the day.", planets[3].getRadius() / 2.5, PI, planets[3], new PVector(1, 10, 1), 0, planets[1].getRadius()*8, PI/2, 0, new PVector(-1, 10, 0), loadImage(moonSurfacePath));  

    planetBeingDrawn = planets[0];
    /* notes for the parameters of the constructors of the class "Planet" */
    //constructor for the planet which does not orbiting
    //Planet(float radius, float spinSpeed_radianPerS, float initSpinRadian, PVector spinAxis, float x, float y, float z)

    //constructor for the planet which orbits around another one
    //Planet(String name, String description, float radius, float spinSpeed_radianPerS, Planet orbitCenter, PVector spinAxis, float initSpinRadian, 
    //  float orbitRadius, float orbitSpeed_radianPerS, float initOrbitRadian, PVector perpendicularToOrbit, PImage surface) {
  }

  void draw() {
    surface.setSize(canvasWidth, canvasHeight);

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

    //for the 3d section, i.e. the display of the space & planets
    hint(ENABLE_DEPTH_TEST);
    moveCloseToAPlanetIfNeeded();
    setView();
    drawBackground();
    planetBeingDrawn.drawItNSatellitesRecursively(scale, canvasWidth, canvasHeight, viewAngle_X, viewAngle_Y, canvasCenterX, canvasCenterY);
    showHighlight();

    if (test) {
      planets[0].test_printData();
    }



    //for the 2d section, i.e. the display of the name & the description of the planets
    hint(DISABLE_DEPTH_TEST);
    camera();
    noLights();
    showNameOfHighlightedPlanet();
    showDescriptionIfNeeded();
    drawBackBtn();
  }

  void setView()
  {
    //set the angle of the view
    translate(canvasCenterX, canvasCenterY);
    rotate(viewAngle_Y, 1, 0, 0);
    rotate(viewAngle_X, 0, 1, 0);
    translate(-canvasCenterX, -canvasCenterY);

    //set the part in the sketch to be viewed
    translate(canvasCenterX - canvasWidth / 2, canvasCenterY - canvasHeight / 2);
  }

  void reverseViewAngleTranslation() {
    translate(-(canvasCenterX - canvasWidth / 2), -(canvasCenterY - canvasHeight / 2));
    translate(canvasCenterX, canvasCenterY);
    rotate(-viewAngle_X, 0, 1, 0);
    rotate(-viewAngle_Y, 1, 0, 0);
    translate(-canvasCenterX, -canvasCenterY);
  }

  void mouseWheel(MouseEvent event) {
    float count = event.getCount();
    float newScale = scale - count * 0.0005;
    if (newScale > 0.1)
      scale = newScale;
    //may add an upper constraint for the scale
  }

  void mouseDragged() {
    if (mouseJustPressed) {
      drag_preMouseX = mouseX;
      drag_preMouseY = mouseY;
      mouseJustPressed = false;
    } else {
      if (!lockViewTranslation && !showingPlanetDetails && !displayDescription && !movingCloseToAPlanet) {
        canvasCenterX += mouseX - drag_preMouseX;
        canvasCenterY += mouseY - drag_preMouseY;
      }
    }

    if (mouseX != drag_preMouseX)
      drag_preMouseX = mouseX;
    if (mouseY != drag_preMouseY)
      drag_preMouseY = mouseY;


    move_preMouseY = mouseY;
    move_preMouseX = mouseX;
  }

  void mouseMoved() {
    if (move_preMouseY < 0) {
      move_preMouseY = mouseY;
      move_preMouseX = mouseX;
    }  

    if (!lockViewAngle && !showingPlanetDetails && !dragging) {
      viewAngle_Y -= ((float)mouseY - move_preMouseY)  / canvasHeight * PI * 1.5;
      viewAngle_X -= ((float)mouseX - move_preMouseX)  / canvasWidth * PI * 1.5;
    }

    move_preMouseY = mouseY;
    move_preMouseX = mouseX;
  }



  void mousePressed() {
    mouseJustPressed = true;
    dragging = true;
  }

  void mouseClicked() {
    long clickTime_ms = System.currentTimeMillis();
    int idxOfPlanetJustClicked = idxOfPlanetBeingSelected;

    hoveringBackBtn();

    if (!(movingCloseToAPlanet || justStartToMove || displayDescription)) {
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
    } else if (displayDescription) {
      if (backBtnClickedWhenShowingDescription && hoveringBackBtn &&
        clickTime_ms - preClickTime_ms < maxTimeBetweenDblClick_ms) {
        //back
        backBtnClickedWhenShowingDescription = false;
        displayDescription = false;
        reverseDataForZoomIn();
      } else {
        preClickTime_ms = clickTime_ms;
        if (hoveringBackBtn)
          backBtnClickedWhenShowingDescription = true;
        else
          backBtnClickedWhenShowingDescription = false;
      }
    }


    if (idxOfPlanetJustClicked < 0 || showingPlanetDetails)
      return;

    //check if this is a double click
    if (clickTime_ms - preClickTime_ms > maxTimeBetweenDblClick_ms) {
      idxOfPreClickedPlanet = -1;
    }
    preClickTime_ms = clickTime_ms;

    //if a double click on the same planet
    if (idxOfPlanetJustClicked == idxOfPreClickedPlanet) {

      justStartToMove = true;
      movingCloseToAPlanet = true;


      showingPlanetDetails = true;
      idxOfPlanetShowingDetails = idxOfPlanetBeingSelected;
      idxOfPlanetBeingSelected = -1;

      if (!lockRevolution) {
        //lockRevolution = true;
        planets[idxOfPlanetShowingDetails].toggleOrbitting();
      } else {
        for (int i = idxOfPlanetShowingDetails + 1; i < planets.length; i++)
          planets[i].toggleOrbitting();
      }

      planetSelected = planets[idxOfPlanetJustClicked];
      planetBeingDrawn = planetSelected;


      //switch the audio effect when approaching to planets
      M1.pause( );
      M2.rewind( ); 
      M2.play( );
    }

    idxOfPreClickedPlanet = idxOfPlanetJustClicked;
  }

  void mouseReleased() {
    move_preMouseY = mouseY;
    dragging = false;
    //print("mouseReleased, ");
  }

  void keyPressed() {
    switch(key) {
    case ' ':
      if (!movingCloseToAPlanet && !showingPlanetDetails && !displayDescription) {
        lockViewAngle = !lockViewAngle;
        lockRevolution = !lockRevolution;
        for (int i = 0; i < planets.length; i++)
          planets[i].toggleOrbitting();
      }
      break;
    //case 't': //test purpose
    //  test = !test;
    //  break;
    }
  }

  int idxOfPlanetBeingHovered() {
    idxOfPlanetBeingSelected = -1;
    for (int i = 0; i < planets.length; i++) {
      if (planets[i].beingHovered()) {
        if (idxOfPlanetBeingSelected < 0) {
          idxOfPlanetBeingSelected = i;
        }
        if (screenZ(planets[i].getX(), planets[i].getX(), planets[i].getZ()) < 
          screenZ(planets[idxOfPlanetBeingSelected].getX(), planets[idxOfPlanetBeingSelected].getX(), planets[idxOfPlanetBeingSelected].getZ()))
          idxOfPlanetBeingSelected = i;
      }
    }
    return idxOfPlanetBeingSelected;
  }

  void drawBackground() {
    background(0);
    for (int i = 0; i < numOfStarsInBG; i++) {
      stars[i].drawIt();
    }
  }


  void showHighlight() {
    if (showingPlanetDetails)
      return;
    idxOfPlanetBeingSelected = idxOfPlanetBeingHovered();
    if (idxOfPlanetBeingSelected < 0)
      return;

    planets[idxOfPlanetBeingSelected].selectionHighlight();
  }

  void showNameOfHighlightedPlanet() {
    if (idxOfPlanetBeingSelected < 0 || movingCloseToAPlanet || displayDescription || showingPlanetDetails)
      return;

    Planet highlightedPlanet = planets[idxOfPlanetBeingSelected]; 
    float x2d = highlightedPlanet.getX2d();
    float y2d = highlightedPlanet.getY2d() - highlightedPlanet.getRadius2d();
    float fontSize = fontSizeWithNoScaleChange * scale;
    if (fontSize < leastFontSize)
      fontSize = leastFontSize;

    textDisplayBuffer.beginDraw();
    textDisplayBuffer.clear();
    textDisplayBuffer.textFont(fontForNameOfHighlightedPlanet);
    textDisplayBuffer.textSize(fontSize);
    textDisplayBuffer.colorMode(HSB, 360, 100, 100);
    textDisplayBuffer.textAlign(CENTER, BOTTOM);
    textDisplayBuffer.translate(x2d, y2d);

    textDisplayBuffer.fill(fontStrokeColorH, fontStrokeColorS, fontStrokeColorB);
    for (int i = -2; i < 3; i++) {
      textDisplayBuffer.text(highlightedPlanet.getName(), i, 0);
    }
    //draw the text with its fill color
    textDisplayBuffer.fill(fontFillColorH, fontFillColorS, fontFillColorB);
    textDisplayBuffer.text(highlightedPlanet.getName(), 0, 0);

    textDisplayBuffer.endDraw();
    image(textDisplayBuffer, 0, 0);
  }


  void moveCloseToAPlanetIfNeeded() {
    if (!movingCloseToAPlanet && !displayDescription && !justStartToMove) {
      return;
    }


    if (justStartToMove) {
      startToMoveTime_ms = System.currentTimeMillis();
      endMoveTime_ms = startToMoveTime_ms + timeForMovingFocusToAPlanet_ms;
      justStartToMove = false;
      originalScale = scale;
      originalRadius2d = planetSelected.getRadius2d();
    }

    //zoom in
    changeDataForZoomIn();

    camera(width / 2, height / 2, cameraZ + (height/2.0) / tan(PI*30.0 / 180.0), cameraX, cameraY, cameraZ, 0, 1, 0);
    //approach with the use of perspective() is given up
    //perspective(fov*currFovScale, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);

    //when done
    if (endMoveTime_ms > 0 && System.currentTimeMillis() > endMoveTime_ms) { 
      movingCloseToAPlanet = false;

      startToMoveTime_ms = -1;
      endMoveTime_ms = -1;
      displayDescription = true;
      movingCloseToAPlanet = false;
    }
  }



  void changeDataForZoomIn() {
    long currTime_ms =  System.currentTimeMillis();
    long timeDiff_ms = 0;

    if (currTime_ms - startToMoveTime_ms > timeForMovingFocusToAPlanet_ms)
      timeDiff_ms = timeForMovingFocusToAPlanet_ms; 
    else
      timeDiff_ms = currTime_ms - startToMoveTime_ms;


    cameraX = canvasWidth / 2 + (planetSelected.getX2() - canvasWidth / 2) * (float) timeDiff_ms / timeForMovingFocusToAPlanet_ms;
    cameraY = canvasHeight / 2 + (planetSelected.getY2() - canvasHeight / 2) * (float) timeDiff_ms / timeForMovingFocusToAPlanet_ms;
    cameraZ = planetSelected.getZ2() * (float) timeDiff_ms / timeForMovingFocusToAPlanet_ms;

    float targetRadius2d = (width < height ? width : height) * targetRadiusOverCanvasSize;
    boolean beLarger = targetRadius2d > originalRadius2d;
    float currRadius2d = originalRadius2d / originalScale * scale;
    if ((targetRadius2d - currRadius2d) * (beLarger ? 1 : -1) > 0) {
      scale += scaleChangeEachFrame * (beLarger ? 1 : -1);
    }
  }

  void reverseDataForZoomIn() {
    planetBeingDrawn = planets[0];
    scale = originalScale;
    idxOfPreClickedPlanet = -1;
    planetSelected = null;
    showingPlanetDetails = false;
    if (!lockRevolution) {
      planets[idxOfPlanetShowingDetails].setOrbitting(true);
    } else {
      for (int i = idxOfPlanetShowingDetails + 1; i < planets.length; i++)
        planets[i].toggleOrbitting();
    }
    idxOfPlanetShowingDetails = -1;

     }

  void showDescriptionIfNeeded() {
    if (!displayDescription)
      return;
    String leftDescription = planetSelected.getDescription1();
    String rightDescription = planetSelected.getDescription2();

    showDescription(leftDescription, 0.10 * width, 0.25 *height);
    showDescription(rightDescription, 0.56 * width, 0.05 *height);         
  }

  void showDescription(String description, float x, float y) {
    float fontSize =  30 * height / 900;
    if (eightToFiveScreenRatio)
      fontSize = 27 * height / 900; 

    float textLeadingSize = 42 * height / 930;
    if (eightToFiveScreenRatio)
      textLeadingSize = 43.3 * height / 900;

    textDisplayBuffer.beginDraw();
    textDisplayBuffer.clear();
    textDisplayBuffer.textFont(fontForDescription);
    textDisplayBuffer.textSize(fontSize);
    textDisplayBuffer.colorMode(HSB, 360, 100, 100);
    textDisplayBuffer.textAlign(LEFT, TOP);
    textDisplayBuffer.textLeading(textLeadingSize);
    textDisplayBuffer.translate(x, y);

    textDisplayBuffer.fill(fontStrokeColorH, fontStrokeColorS, fontStrokeColorB);
    for (int i = -2; i < 2; i++) {
      textDisplayBuffer.text(description, i, 0);
    }
    //draw the text with its fill color
    textDisplayBuffer.fill(fontFillColorH, fontFillColorS, fontFillColorB);       
    textDisplayBuffer.text(description, 0, 0);

    textDisplayBuffer.endDraw();
    image(textDisplayBuffer, 0, 0);
  }













  //below test did figure out that the problem was not stemmed from actual xyz
  void test_printPlanetsData()
  {
    for (int i = 0; i < planets.length; i++) {
      print("i: " + i + ", ");
      planets[i].test_printData();
    }
  }
  void test_printMouseXY()
  {
    println("mouseX: " + mouseX + ", mouseY: " + mouseY);
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

  void enter() {
    entering = true;
    running = true;

    M1.pause( );
    M2.rewind( ); 
    M2.play( );
  }


  void drawBackBtn() {
    colorMode(RGB, 256, 256, 256);
    noFill();
    stroke(255);
    strokeWeight(5);
    strokeJoin(ROUND);

    rect(0.05*width, 0.89*height, 0.06*width, 0.06*height);
    fill(255);
    textFont(fontForDescription, 27*height/900);

    text("Back", 0.06*width, 0.23*height+(int)(0.7*height));
  }

  void hoveringBackBtn() {
    if (mouseX >= 0.05*width && mouseY >= 0.89*height
      && mouseX <= (0.06 + 0.05)*width && mouseY <= (0.89 + 0.06)*height)
      hoveringBackBtn = true;
    else
      hoveringBackBtn = false;
  }
}
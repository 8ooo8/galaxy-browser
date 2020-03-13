import java.util.*;  //<>//

class Planet {
  //variables for test purpose
  private boolean showSpinAxis = false;
  private int spinAxisHalfLength = 80;


  String name;
  String description1, description2;

  private float radius;
  private float scale;

  private PVector spinAxis;
  private float spinSpeed_radianPerS; //anti-clockwise
  private float initSpinRadian;
  private long initSpinTime_ms;

  Planet orbitCenter;
  private PVector perpendicularToOrbit;
  private float orbitRadius, orbitSpeed_radianPerS;
  private boolean orbitting = true, spinning = true;
  private float initOrbitRadian; //the orbit angle changes over time automatically
  private long accumulatedOrbitTime_ms, preOrbitTime_ms;

  private float x, y, z; //regardless of the view angle, etc
  private float x2, y2, z2; // not regardless of the view angle, etc
  private float x2d, y2d; //the x, y when it comes to be displayed on the 2d screen
  private float radius2d; //the radius when it comes to be displayed on the 2d screen

  private Vector<Planet> satellites;

  private PShape shape;
  private PImage surface;

  private Solar solar;

  //constructor for the planet which orbits around another one
  //for simplicity, in perpendicularToOrbit, z is assumed to be zero
  Planet(Solar solar, String name, String description1, String description2, float radius, float spinSpeed_radianPerS, Planet orbitCenter, PVector spinAxis, float initSpinRadian, 
    float orbitRadius, float orbitSpeed_radianPerS, float initOrbitRadian, PVector perpendicularToOrbit, PImage surface) {
    this.solar = solar;
    this.name = name;
    this.description1 = description1;
    this.description2 = description2;
    this.radius = radius;
    this.spinSpeed_radianPerS = spinSpeed_radianPerS;
    this.spinAxis = spinAxis;
    this.initSpinRadian = initSpinRadian;
    this.perpendicularToOrbit = perpendicularToOrbit;
    if (orbitCenter != null) {
      this.orbitCenter = orbitCenter;
      this.orbitRadius = orbitRadius;
      this.orbitSpeed_radianPerS = orbitSpeed_radianPerS; 
      this.initOrbitRadian = initOrbitRadian;

      orbitCenter.addSatellite(this);
    } else {
      this.orbitCenter = null;
      this.orbitRadius = -1;
      this.orbitSpeed_radianPerS = -1; 
      this.initOrbitRadian = -1;
    }

    initSpinTime_ms = System.currentTimeMillis();
    preOrbitTime_ms = System.currentTimeMillis();
    accumulatedOrbitTime_ms = 0;
    scale = 1;
    //orbitting = true;

    satellites = new Vector<Planet>();
    this.surface = surface;
    x = -1;
    y = -1;
    z = -1;
  }

  //constructor for the planet which does not orbiting
  Planet(Solar solar, String name, String description1, String description2, float radius, float spinSpeed_radianPerS, float initSpinRadian, PVector spinAxis, float x, float y, float z, PImage surface) {
    this.solar = solar;
    this.name = name;
    this.description1 = description1;
    this.description2 = description2;
    this.radius = radius;
    this.spinSpeed_radianPerS = spinSpeed_radianPerS;
    this.spinAxis = spinAxis;
    this.initSpinRadian = initSpinRadian;
    this.x = x;
    this.y = y;
    this.z = z;

    initSpinTime_ms = System.currentTimeMillis();
    preOrbitTime_ms = System.currentTimeMillis();
    accumulatedOrbitTime_ms = 0;
    scale = 1;
    //orbitting = true;

    satellites = new Vector<Planet>();
    this.surface = surface;
    orbitCenter = null;
    orbitRadius = -1;
    orbitSpeed_radianPerS = -1; 
    initOrbitRadian = -1;
    perpendicularToOrbit = null;
  }

  void addSatellite(Planet satellite) {
    if (!satellites.contains(satellite))
      satellites.add(satellite);
  }

  //no pushMatrix() / popMatrix() involved
  void translateToCurrPosition(float scale, int canvasWidth, int canvasHeight) {
    if (orbitCenter == null) {
      //this is to take care of the resizing
      translate((x - canvasWidth / 2) * scale + canvasWidth / 2, 
        (y - canvasHeight / 2) * scale + canvasHeight / 2, z * scale);
    } else {
      orbitCenter.translateToCurrPosition(scale, canvasWidth, canvasHeight);
      rotate(getCurrOrbitRadian(), perpendicularToOrbit.x, perpendicularToOrbit.y, perpendicularToOrbit.z);
      translate(0, 0, orbitRadius * scale);
    }
  }


  void toggleOrbitting() { 
    orbitting = !orbitting;
  }

  void setOrbitting(boolean orbitting) {
    this.orbitting = orbitting;
  }

  void toggleSpinning() {
    spinning = !spinning;
  }

  void setSpinning(boolean spinning) {
    this.spinning = spinning;
  }

  boolean isOrbitting() {
    return orbitting;
  }

  boolean isSpinning() {
    return spinning;
  }

  float getCurrOrbitRadian()
  {   
    if (orbitting) {
      accumulatedOrbitTime_ms += System.currentTimeMillis() - preOrbitTime_ms;
    }
    preOrbitTime_ms = System.currentTimeMillis();

    return initOrbitRadian + orbitSpeed_radianPerS * accumulatedOrbitTime_ms / 1000;
  }

  float getRadius() { 
    return radius;
  }
  float getspinSpeed_radianPerS() { 
    return spinSpeed_radianPerS;
  }
  float getOrbitRadius() { 
    return orbitRadius;
  }
  float getOrbitSpeed_radianPerS() { 
    return orbitSpeed_radianPerS;
  }

  //spinning not yet handled
  void drawItNSatellitesRecursively(float scale, int canvasWidth, int canvasHeight, float viewAngle_X, float viewAngle_Y, float canvasCenterX, float canvasCenterY) {
    this.scale = scale;

    pushMatrix();

    translateToCurrPosition(scale, canvasWidth, canvasHeight);
    //translate(x, y, z);

    //spin
    if (spinning) {
      float spinRadian = initSpinRadian + spinSpeed_radianPerS * (System.currentTimeMillis() - initSpinTime_ms) / 1000; 
      rotate(spinRadian, spinAxis.x, spinAxis.y, spinAxis.z);
      if (showSpinAxis) {
        line(spinAxis.x * -spinAxisHalfLength, spinAxis.y * -spinAxisHalfLength, spinAxis.z * -spinAxisHalfLength, 
          spinAxis.x * spinAxisHalfLength, spinAxis.y * spinAxisHalfLength, spinAxis.z * spinAxisHalfLength);
      }
    }

    //draw out its surface & shape
    colorMode(RGB, 256, 256, 256, 100);
    noFill();
    noStroke();
    //lights();
    shape = createShape(SPHERE, radius * scale); //ASSUMED to be with a shape of sphere
    shape.setTexture(surface);
    shape(shape);

    //update x2d, y2d, x2, y2, z2 here so that their values should be consistent with what is shown on the screen
    x2d = screenX(0, 0, 0);
    y2d = screenY(0, 0, 0);

    x2 = modelX(0, 0, 0);
    y2 = modelY(0, 0, 0);
    z2 = modelZ(0, 0, 0);

    popMatrix();

    //update x, y, z here so that their values should be consistent with what is shown on the screen
    if (orbitCenter != null) {
      pushMatrix();
      solar.reverseViewAngleTranslation();
      translateToCurrPosition(scale, canvasWidth, canvasHeight);
      x = modelX(0, 0, 0);
      y = modelY(0, 0, 0);
      z = modelZ(0, 0, 0);
      popMatrix();
    }

    //update radius2d here so that its value should be consistent with what is shown on the screen
    solar.reverseViewAngleTranslation();
    //as the angle of the view may change, simply writing either one of the below 3 lines of code won't work
    //in fact, below code does not return the actual value of the radius of the planet on the 2d screen
    //but it is just an approximation which would give out a value very close the actual one
    float a = abs(screenX(x + radius*scale, y, z) - screenX(x, y, z));
    float b = abs(screenX(x, y + radius*scale, z) - screenX(x, y, z));
    float c = abs(screenX(x, y, z + radius*scale) - screenX(x, y, z));
    radius2d = sqrt(sq(a) + sq(b) + sq(c)) * 1.2;
    solar.setView();

    Iterator<Planet> satellitesIterator = satellites.iterator();
    for (; satellitesIterator.hasNext(); ) {
      Planet satellite = satellitesIterator.next();
      satellite.drawItNSatellitesRecursively(scale, canvasWidth, canvasHeight, viewAngle_X, viewAngle_Y, canvasCenterX, canvasCenterY);
    }
  }

  boolean beingHovered() {
    float distBetweenMouseNCenter = sqrt(sq(mouseX - x2d) + sq(mouseY - y2d));
    return radius2d > distBetweenMouseNCenter;
  }

  void selectionHighlight()
  {
    colorMode(HSB, 360, 100, 100, 100);
    fill(43, 99, 99, 40);
    noStroke();
    translate(x, y, z);
    sphere(radius*scale*1.2);
    translate(-x, -y, -z);
  }

  float getX() { 
    return x;
  }
  float getY() { 
    return y;
  }
  float getZ() { 
    return z;
  }

  float getX2() { 
    return x2;
  }
  float getY2() { 
    return y2;
  }
  float getZ2() { 
    return z2;
  }

  float getX2d() { 
    return x2d;
  }
  float getY2d() { 
    return y2d;
  }

  float getRadius2d() {
    return radius2d;
  }

  void setScale(float scale) {
    this.scale = scale;
  }

  float updateNGetRadius2d() {
    solar.reverseViewAngleTranslation();
    //as the angle of the view may change, simply writing either one of the below 3 lines of code won't work
    //in fact, below code does not return the actual value of the radius of the planet on the 2d screen
    //but it is just an approximation which would give out a value very close the actual one
    float a = abs(screenX(x + radius*scale, y, z) - screenX(x, y, z));
    float b = abs(screenX(x, y + radius*scale, z) - screenX(x, y, z));
    float c = abs(screenX(x, y, z + radius*scale) - screenX(x, y, z));
    radius2d = sqrt((sq(a) + sq(b) + sq(c)) / 3) * 1.2;
    solar.setView();
    return radius2d;
  }

  String getName() {
    return name;
  }

  String getDescription1() {
    return description1;
  }

  String getDescription2() {
    return description2;
  }

  void test_printData() {
    println("; name: " + name + ", radius2d: " + radius2d);
  }
}
import ddf.minim.*;// audio effect

int numOfPages = 6;
Page[] pages;

float fov = PI/3.0;
float fovCameraZ = (height/2.0) / tan(fov/2.0);

PShader blur;
boolean isPlaying;
 
Minim Mnm; 
AudioPlayer M1; 
AudioPlayer M2;


boolean eightToFiveScreenRatio;


void setup(){
  pages = new Page[numOfPages];
  pages[0] = new BlackHoleInfo();
  pages[1] = new Galaxy();
  pages[2] = new GalaxyInfo();
  pages[3] = new NebulaInfo();
  pages[4] = new PlanetaryNebulaInfo();
  pages[5] = new Solar();
  pages[1].enter();

  
  fullScreen(P3D);
  if ((float)width/height == 1.6)
  {
    eightToFiveScreenRatio = true;
  }else{
    eightToFiveScreenRatio = false;
  }
  //size(800, 600, P3D); //test purpose
  surface.setResizable(true);
  
  
  Mnm = new Minim(this);
  M1= Mnm.loadFile("universe3.wav"); 
  M2= Mnm.loadFile("switch5.wav");
  
  M1.rewind( ); 
  M1.loop( ); 
}

void draw(){
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].draw();
    }
  }
  
  //set default audio effect
  //play the default audio when needed
  
  if(!M1.isPlaying() && !M2.isPlaying())
  {
    M1.rewind( ); 
    M1.loop( );
  }
}

void mouseWheel(MouseEvent event){
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mouseWheel(event);
    }
  }
} 

void mouseDragged() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mouseDragged();
    }
  }
}

void mouseMoved() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mouseMoved();
    }
  }
}

void mousePressed() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mousePressed();
    }
  }
}

void keyPressed() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].keyPressed();
    }
  }
}

void mouseReleased() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mouseReleased();
    }
  }
}

void mouseClicked() {
  for (int i = 0; i < numOfPages; i++){
    if (pages[i].isRunning()){
      pages[i].mouseClicked();
    }
  }
}

void stop( ) {

  M1.close( );
  Mnm.stop( ); 
  super.stop( ); 
  
}

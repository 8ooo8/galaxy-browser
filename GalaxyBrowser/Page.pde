interface Page{
  void draw();
  void setRunning(boolean running);
  void toggleRunning();
  boolean isRunning();
  void enter();
  
  void mouseWheel(MouseEvent event);
  void mouseDragged();
  void mouseMoved();
  void mousePressed();
  void keyPressed();
  void mouseReleased();
  void mouseClicked();
}
import java.util.Random;

class StarInBG{
  private float x, y, z;
  private float radius;
  
  StarInBG(float minDistFromCenter, float maxDistFromCenter, float spaceCenterX, float spaceCenterY, float spaceCenterZ){
    Random random = new Random();
    float ttlDist;
    do{
      x = random.nextFloat() * minDistFromCenter * (random.nextFloat() > 0.5 ? -1 : 1) + spaceCenterX;
      y = random.nextFloat() * minDistFromCenter * (random.nextFloat() > 0.5 ? -1 : 1) + spaceCenterY;
      z = random.nextFloat() * minDistFromCenter * (random.nextFloat() > 0.5 ? -1 : 1) + spaceCenterZ;
      ttlDist = pow(pow(x - spaceCenterX, 2) + pow(y - spaceCenterY, 2) + pow(z - spaceCenterZ, 2), 0.5);
    }while (ttlDist < minDistFromCenter || ttlDist > maxDistFromCenter);
    
    radius = ttlDist * random.nextFloat() * 0.01;
  }
  
  void drawIt(){
    colorMode(RGB, 256, 256, 256, 100);
    noStroke();
    fill(255);
    pushMatrix();
    translate(x, y, z);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
}
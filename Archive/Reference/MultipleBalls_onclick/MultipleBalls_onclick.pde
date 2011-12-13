int countBall=1;
ArrayList balls;
 
 
void setup() {
  size(640, 480);
  smooth();
  noStroke();
  frameRate(10);
  balls = new ArrayList();
  balls.add(new Ball(width/2, height/2, int(random(20,100)), int(random(20,100)), color(255, 255, 255, 1), int(random(10,50))));
}
 
// nice copy from examples, not that sure about arraylists yet (comments are original) - http://processing.org/learning/topics/arraylistclass.html
void draw() {
  background(128);
  // With an array, we say balls.length, with an ArrayList, we say balls.size()
  // The length of an ArrayList is dynamic
  // Notice how we are looping through the ArrayList backwards
  // This is because we are deleting elements from the list 
  for (int i = balls.size()-1; i >= 0; i--) {
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Ball ball = (Ball) balls.get(i);
    ball.moveBall();
  } 
   
}
 
void mousePressed() {
  balls.add(new Ball(mouseX, mouseY, int(random(20,100)), int(random(20,100)), color(255,255,255,1), int(random(10,50))));
}


 

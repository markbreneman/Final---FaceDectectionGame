// BALL PIT
// Assignment 3 Program 1 KIB205 Laura Packer n6874606

// Inspired by Learning Processing Exercise 8-5
// http://www.learningprocessing.com/exercises/chapter-8/exercise-8-5/

// Ball Class
class Ball {
  // X Position
  float xPos;
  // Y Position
  float yPos;
  // Speed of Ball
  float speed;
  // Diametre of Ball
  int d;
  // Color & Alpha of Ball
  color randCol;

  // Ball Constuctor
  // Set Temp Variables
  Ball(float tempX, float tempY, int tempD, color tempC) {
    // Temporary X Position
    xPos = tempX;
    // Temporary Y Position
    yPos = tempY;
    // Temporary Ball Diametre
    d = tempD;
    // Temporary Ball Colour
    randCol = tempC;
    // Temporary Speed
    speed = 0;
  }
  
  // Display Method
  void display() {
    // Fill ball with random colour
    fill(color(randCol));
    // No Stroke
    noStroke(); 
    // Draw ellipse at xPos, yPos with d as diametre
    ellipse(xPos,yPos,d,d); 
  }
  
  // Update Method - Gravity calculations with help from
  // Learning Processing Exercise 8-5
  void update() {
    // Add speed to Y position
    yPos += speed; 
    // Add gravity to speed
    speed += gravity; 
    // Reverse speed when ball reaches bottom of screen
    // Point is found by taking window height
    // minus diametre of circle divided by 2
    if (yPos >= wHeight-d/2) {
      speed = speed * -0.95;  
    } 
  }
}


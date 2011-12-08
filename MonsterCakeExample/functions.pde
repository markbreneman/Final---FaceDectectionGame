// CAKE MONSTER
// Assignment 3 Program 2 KIB205 Laura Packer n6874606

class Cake {
  // X Position
  float xPos;
  // Y Position
  float yPos;
  // Speed of Cake
  float speed;
  // General size of Cake
  float r;
  
  // Cake Constructor
  Cake() {
    // General size of Cake
    r = 8;
    // Start at random X Position within window width
    xPos = random(wSize);
    // Start at random Y Position a bit above 0
    yPos = random(0-r*3,0-r*4);
    // Random speed between 3 and 6
    speed = random(3,6);
  }

  // Move method
  void move() {
    // Add speed to Y Position
    yPos += speed; 
  }

  // Method to check if cake has reached bottom of screen
  boolean reachedBottom() {
    // Once cake passes beyond the screen...
    if (yPos > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display Method
  void display() {
    // No Stroke
    noStroke();
    // Draw Cake
    // Base of Cake
    // Fill with yellow
    fill(249,233,122);
    // Draw ellipse & rectangle
    ellipse(xPos,yPos,45,20);
    rectMode(CENTER);
    rect(xPos,yPos-10,45,20);
    // Icing
    // Change fill to pink
    fill(248,195,218);
    // Draw ellipse
    ellipse(xPos,yPos-20,45,20);
    // Draw candles
    // change fill to orange
    fill(246,140,31);
    // Draw sticks
    rect(xPos,yPos-30,2,18);
    rect(xPos-8,yPos-27,2,18);
    rect(xPos+8,yPos-27,2,18);
    // Draw flames
    // Change fill to yellow
    fill(249,233,122);
    ellipse(xPos,yPos-44,3,6);
    ellipse(xPos-8,yPos-41,3,6);
    ellipse(xPos+8,yPos-41,3,6);
  }

  // Ate Function
  // When cake is eaten
  void ate() {
    // Move cake offscreen
    xPos = - 200;
  }
}

// CAKE MONSTER
// Assignment 3 Program 2 KIB205 Laura Packer n6874606

// Monster Class
class Monster {
  // Monster Diametre
  float diam;
  // Eye Colour
  color eCol;
  // X Position
  float xPos;
  // Y Position
  float yPos;
  
  // Monster Constructor
  // Set temp variables for radius and eye colour
  Monster(float tempDiam, color tempECol) {
    // Temp Radius
    diam = tempDiam;
    // Temp Eye Colour
    eCol = tempECol;
  }
  
  // Set location of Monster
  void setLocation(float tempX, float tempY) {
    // Temp X Position
    xPos = tempX;
    // Temp Y Position
    yPos = tempY;
  }
  
  // Display Method
  void display() {
    // GREEN MONSTER
    noStroke();
    // Body
    // Set fill to green
    fill(106,189,69);
    // Draw ellipse
    ellipse(xPos,yPos,diam,diam);
    // Large circles for eyes
    // Set fill to white
    fill(255);
    // Draw ellipses
    ellipse(xPos-40,yPos+10,65,65);
    ellipse(xPos+40,yPos+10,65,65);
    // Small circles for eyes
    // Set fill to eCol variable
    fill(eCol);
    // Draw ellipses
    ellipse(xPos-33,yPos-8,15,15);
    ellipse(xPos+33,yPos-8,15,15);
    // Ellipse for mouth
    // Set fill to pink
    fill(239,89,87);
    // Draw ellipse
    ellipse(xPos,yPos-64,80,30);
    // Nose
    // Set fill to darker green
    fill(82,153,67);
    // Draw triangle
    beginShape();
    vertex(xPos,yPos-30);
    vertex(xPos+6,yPos-20);
    vertex(xPos-6,yPos-20);
    endShape();
  }
  
  // Boolean Intersect Function
  // With help from Example 10-3: Bouncing Ball with Intersection
  // http://www.learningprocessing.com/examples/chapter-10/example-10-3/
  // Returns true if monster intersects a cake
  boolean intersect(Cake d) {
    // Calculate distance between current X,Y and d X,Y
    float distance = dist(xPos,yPos,d.xPos,d.yPos);
    // Check distance and return true or false
    if (distance < diam/2 + d.r) {
      return true;
    } else {
      return false;
    }
  }
}

// CAKE MONSTER
// Assignment 3 Program 2 KIB205 Laura Packer n6874606

// With help from Example 10-5: Object-oriented timer
// http://www.learningprocessing.com/examples/chapter-10/example-10-5/

// Timer Class
class Timer {
  // When Timer began
  int savedTime;
  // Amount of time
  int totalTime;
  
  // Timer Constructor
  // Set Temp Variable
  Timer(int tempTotalTime) {
    // Temporary amount of time
    totalTime = tempTotalTime;
  }
  
  // Start Method to start Timer
  void start() {
    // Store time in milliseconds
    savedTime = millis(); 
  }
  
  // When 5000 milliseconds have passed, isFinished() returns TRUE
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    }
    else {
      return false;
    }
  }
}

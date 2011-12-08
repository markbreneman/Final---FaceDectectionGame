// BALL PIT
// Assignment 3 Program 1 KIB205 Laura Packer n6874606

// Inspired by Learning Processing Exercise 8-5
// http://www.learningprocessing.com/exercises/chapter-8/exercise-8-5/

// Ball Object
Ball newBall;

// Variables
// Gravity
float gravity = 0.1;
// Window Size
int wWidth = 500;
int wHeight = 600;

// Create Balls Array of Ball Class
Ball[] Balls = new Ball[0];

void setup() {
  // General Setup
  // Window Size
  size(wWidth,wHeight);
  // Smooth Edges
  smooth();
}

// When the mouse is pressed
void mousePressed() {
  // Create newBall object of Ball class
  // At current mouse coordinates
  // With random colour and alpha within boundaries specified
  newBall = new Ball(mouseX, mouseY, int(random(20, 100)), color(int(random(220)),
  int(random(220)), int(random(30)), int(random(100,200))));
  // Use append() function to add new element to end of array - researched in text book
  Balls = (Ball[]) append(Balls, newBall);
}

void draw () {
  // Redraw background each frame
  background(0);
  // Update and display balls
  for(int i = 0; i < Balls.length; i++) {
    Balls[i].update();
    Balls[i].display();
  }
}

void keyPressed() {
  // When s or S is pressed, save frame
  if (key=='s' || key=='S') {
  saveFrame("As3_1-####.tif");
 }
}

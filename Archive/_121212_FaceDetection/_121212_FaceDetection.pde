import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import hypermedia.video.*;
import java.awt.Rectangle;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Ball> balls;

//// The Spring that will attach to the paddle
Spring spring1;


//PADDLE VARAIABLES 
Paddle paddle1;


int paddle1var=10;
int paddle1x=paddle1var;
int paddle1y=paddle1var;
int paddle1width=paddle1var;
int paddle1height=paddle1var;



//OPEN CV VARIABLES 
OpenCV opencv;
int contrast_value    = 0;
int brightness_value  = 0;

//TIMER VARIABLES
Timer timer;


void setup() {
  size(320, 240);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -20);

  // Create ArrayLists	
  balls = new ArrayList<Ball>();
  boundaries = new ArrayList<Boundary>();

  // Set Boundaries of the Wall
  //  boundaries.add(new Boundary(width/4, height-5, width/2-50, 10));
  //  boundaries.add(new Boundary(3*width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(width/2, height-5, width, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));

  // Add 3 Paddles for three players
  paddle1=new Paddle(width/2, height/2);

  // Make springs- They will only actually be made when faces are detected
  spring1 = new Spring();


  //OPENCVSETUP
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // START VIDEO
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"


  //TIMER
  timer=new Timer(50);
  timer.start();
}

//void mouseReleased() {
//  spring1.destroy();
//}


void draw() {
  background(255);
  opencv.read();//GRAB A NEW FRAME
  opencv.flip( OpenCV.FLIP_HORIZONTAL ); // FLIP IMAGE HORIZONTALLY
  //  opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  // display the image
  image( opencv.image(), 0, 0 );

  // We must always step through time!
  box2d.step();
  ////FACE DETECTION PADDLE MOVEMENT
  for ( int i=0; i<constrain(faces.length,0,3); i++ ) {
    spring1.update(faces[i].x, faces[i].y);
    for ( int j=0; j<constrain(faces.length,0,3); j++ ) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(2);
      rectMode(CORNER);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height );
      spring1.bind(faces[0].x+faces[0].width/2, faces[0].y+faces[0].height, paddle1);
    }
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }

  // Display all the boxes
  for (Ball b: balls) {
    b.display();
  }

  // Display Paddle
  paddle1.display();
  spring1.display();

  // Ball that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = balls.size()-1; i >= 0; i--) {
    Ball b = balls.get(i);
    if (b.done()) {
      balls.remove(i);
    }
  }
  if (timer.isFinished()) {
    // Add a new ball
    Ball p = new Ball(width/2, 0, random(5, 10));
    balls.add(p); 
    // Start timer again
    timer.start();
  }
}


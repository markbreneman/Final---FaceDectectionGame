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
ArrayList<Box> boxes;

//// The Spring that will attach to the paddle
Spring spring1;
Spring spring2;
Spring spring3;

//PADDLE VARAIABLES 
Paddle paddle1;
Paddle paddle2;
Paddle paddle3;

int paddle1var=10;
int paddle2var=50;
int paddle3var=100;

int paddle1x=paddle1var;
int paddle2x=paddle2var;
int paddle3x=paddle3var;
int paddle1y=paddle1var;
int paddle2y=paddle2var;
int paddle3y=paddle3var;

int paddle1width=paddle1var;
int paddle1height=paddle1var;
int paddle2width=paddle2var;
int paddle2height=paddle2var;
int paddle3width=paddle3var;
int paddle3height=paddle3var;


//OPEN CV VARIABLES 
OpenCV opencv;
int contrast_value    = 0;
int brightness_value  = 0;


void setup() {
  size(320, 240);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -20);

  // Create ArrayLists	
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();
  
  // Set Boundaries of the Wall
  boundaries.add(new Boundary(width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(3*width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));
  
  // Add 3 Paddles for three players
  paddle1=new Paddle(paddle1x,paddle1y,paddle1width,paddle1height);
  paddle2=new Paddle(paddle2x,paddle2y,paddle2width,paddle2height);
  paddle3=new Paddle(paddle3x,paddle3y,paddle3width,paddle3height);
  
  //OPENCVSETUP
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // START VIDEO
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
}

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


  ////FACE DETECTION PADDLE DRAWING
  for ( int i=0; i<constrain(faces.length,0,3); i++ ) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    
  }
  //     // Make the spring (it doesn't really get initialized until the mouse is clicked)
  //    spring = new Spring();
  //    spring.bind(width/2, height/2, p:paddle);
  //  }

  // When the mouse is clicked, add a new Box object
  if (mousePressed) {
    Box p = new Box(mouseX, mouseY);
    boxes.add(p);
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }

  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }
  // Display Paddle


  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  //  spring.display();
}


//LIBRARY CALLS
import hypermedia.video.*;
import java.awt.Rectangle;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

//OPEN CV VARIABLES 
OpenCV opencv;
int contrast_value    = 0;
int brightness_value  = 0;


// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;

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

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(3*width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));

  //OPENCVSETUP
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // START VIDEO
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  //  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  //  opencv.threshold(20);
}

void draw() {
  background(255);
  opencv.read();//GRAB A NEW FRAME
  opencv.flip( OpenCV.FLIP_HORIZONTAL ); // FLIP IMAGE HORIZONTALLY
  //  opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );
    // display the image
  image( opencv.image(), 0, 0 );

  // We must always step through time!
  box2d.step();


  //     Box p = new Box(height/2,width/2);
  //     boxes.add(p);

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

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
    // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  ////FACE DETECTION RECTANGLE DRAWING

  for ( int j=0; j<faces.length; j++ ) {
    rectMode(CORNER);
    noFill();
    rect( faces[j].x, faces[j].y, faces[j].width, faces[j].height );
    ///CREATING THE TOP SURFACE 
    int faceLeft=faces[j].x;
    int faceRight=faces[j].x+faces[j].width;
    int faceBottom=faces[j].y+faces[j].height;
    int faceTop=faces[j].y;
    int faceCenterX=faces[j].x+faces[j].width/2;
    int faceCenterY=faces[j].y+faces[j].height/2;
  }
}



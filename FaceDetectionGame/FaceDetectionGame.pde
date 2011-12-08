import hypermedia.video.*;
import java.awt.Rectangle;

OpenCV opencv;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
ball fallingBall; // variable for the falling ball
int droppingBallY;
int speed=10;


void setup() {

  size( 320, 240 );
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // open video stream
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"


  // print usage
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  fallingBall = new ball();
}


//public void stop() {
//    opencv.stop();
//    super.stop();
//}



void draw() {

  // grab a new frame
  // and convert to gray
  opencv.read();
  opencv.flip( OpenCV.FLIP_HORIZONTAL ); // flip vertically and horizontally
  //opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  // display the image
  image( opencv.image(), 0, 0 );

  // draw face area(s)
  noFill();
  stroke(255, 0, 0);
  ellipse(width/2, droppingBallY, 10, 10);
  
  
  droppingBallY=droppingBallY+speed;

  if ((droppingBallY > height) || (droppingBallY < 0)) {
    // If the object reaches either edge, multiply speed by -1 to turn it around.
    speed = speed * -1;
  }

  ////FACE DETECTION RECTANGLE DRAWING
  
  
  
  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
  }

  //    fallingBall.move();

}



/**
 * Changes contrast/brigthness values
 */
void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}


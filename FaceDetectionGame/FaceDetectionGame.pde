import hypermedia.video.*;
import java.awt.Rectangle;

OpenCV opencv;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
ball fallingBall; // variable for the falling ball
int ballXPos;
int ballYPos;
int ballheight=10;
int ballwidth=10;
int Xspeed=4;
int Yspeed=4;
float dy;


void setup() {

  size( 320, 240 );
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // open video stream
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  ballXPos=width/2;
  ballYPos=ballheight+1;
  
}

void draw() {

  // grab a new frame
  // and convert to gray
  opencv.read();
  opencv.flip( OpenCV.FLIP_HORIZONTAL ); // flip vertically and horizontally
  opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  // display the image
  image( opencv.image(), 0, 0 );

  // draw face area(s)
  noFill();
  stroke(255, 0, 0);
  println(ballYPos);
  ellipse(ballXPos, ballYPos, ballwidth, ballheight);//Drawing the ball

  ballXPos+=Xspeed;
  ballYPos+=Yspeed;
  //KEEPING THE BALL IN BOUNDS OF THE SCREEN
  
  if (ballYPos>height) {
    ballYPos=height;
    Yspeed=0;
    Xspeed=0;
  }
  if ( ballYPos < ballheight) {
    Yspeed*=-1;
  } 
  if ( ballXPos < ballwidth || ballXPos >width-ballwidth ) {
    Xspeed*=-1;
  } 
  
  ////FACE DETECTION RECTANGLE DRAWING

  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
     ///CREATING THE TOP SURFACE 
    if (ballYPos >= faces[i].y-ballheight && ballXPos>faces[i].x && ballXPos<faces[i].x+faces[i].width) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Yspeed *= -1;
    }
    //SIDE RECTANGLE EFFECT
    if (ballYPos > faces[i].y && ballXPos<faces[i].x) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Xspeed *= -1;
    }
  
    if (ballYPos > faces[i].y && ballXPos>faces[i].x+faces[i].width) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Xspeed *= -1;
    }
    

    if (faces[i].y != faces[i].y) {
      dy = (faces[i].y-faces[i+1].y)/2.0;
      if (dy >  5) { 
        dy =  5;
      }
      if (dy < -5) { 
        dy = -5;
      }
    }
  }
}

/**
 * Changes contrast/brigthness values
 */
void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}


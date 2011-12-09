import hypermedia.video.*;
import java.awt.Rectangle;

OpenCV opencv;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
ball fallingBall; // variable for the falling ball
int droppingBallX=width/2;
int droppingBallY;
int ballheight=10;
int ballwidth=10;
int Xspeed=10;
int Yspeed=10;


void setup() {

  size( 320, 240 );
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // open video stream
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  // print usage
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
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
  ellipse(width/2, droppingBallY, ballwidth, ballheight);//Drawing the ball

  //  droppingBallX+=Xspeed;
  droppingBallY+=Yspeed;
 if (droppingBallY==height){droppingBallY=height;Yspeed=0;
    }
 if( droppingBallY < 0){Yspeed*=-1;} 

  ////FACE DETECTION RECTANGLE DRAWING

  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
    if (droppingBallY > faces[i].y-ballheight) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Yspeed *= -1;
    }
    if ((droppingBallX > width) || (droppingBallX < 0)) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Xspeed = Xspeed * -1;
    }
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


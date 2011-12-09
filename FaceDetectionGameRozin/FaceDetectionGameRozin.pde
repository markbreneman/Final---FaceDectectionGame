import hypermedia.video.*;
import java.awt.Rectangle;

OpenCV opencv;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;
ball fallingBall; // variable for the falling ball
int ballXPos;
int ballYPos;
int ballheight=5;
int ballwidth=5;
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
  //  noFill();
  fill(255, 0, 0);
  stroke(255, 0, 0);
//  println(ballYPos);
  ellipseMode(CENTER);
  ellipse(ballXPos, ballYPos, ballwidth, ballheight);//Drawing the ball
  if (faces.length > 0) {
    ballXPos+=Xspeed;
    ballYPos+=Yspeed;
    //KEEPING THE BALL IN BOUNDS OF THE SCREEN

    if (ballYPos>height) {
      ballYPos=height;
      Yspeed=0;
      Xspeed=0;
    }
    if ( ballYPos < -ballheight) {
      Yspeed*=-1;
    } 
    if ( ballXPos < ballwidth || ballXPos >width-ballwidth ) {
      Xspeed*=-1;
    }
  }
  ////FACE DETECTION RECTANGLE DRAWING

  for ( int i=0; i<faces.length; i++ ) {
    println(faces[i].centroid);
    noFill();
   // rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
    ///CREATING THE TOP SURFACE 
//    int faceLeft=faces[i].x;
//    int faceRight=faces[i].x+faces[i].width;
//    int faceBottom=faces[i].y+faces[i].height;
//    int faceTop=faces[i].y;
//    int faceCenterX=faces[i].x+faces[i].width/2;
//    int faceCenterY=faces[i].y+faces[i].height/2;
    int faceLeft=mouseX;
    int faceRight=mouseX+100;
    int faceBottom=mouseY+100;
    int faceTop=mouseY;
    int faceCenterX=mouseX+50;
    int faceCenterY=mouseY+10;
    
    rect(mouseX,mouseY,100,100);   
    
    if (ballYPos > faceTop-ballheight&& ballYPos<faceCenterY && ballXPos>faceLeft+ballwidth && ballXPos<faceRight+ballwidth) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Yspeed = -abs(Yspeed);
      //      ballYPos = faceTop+Yspeed;
      println("collideTop");
    }
    //    //SIDE RECTANGLE EFFECT
    if (ballYPos > faceTop && ballYPos < faceBottom && ballXPos > faceLeft && ballXPos<faceCenterX) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Xspeed = -abs(Xspeed);
      //      ballXPos = faceLeft+Xspeed;
      println("collideLeftSide");
    }

    if (ballYPos > faceTop && ballYPos < faceBottom  && ballXPos<faceRight && ballXPos>faceCenterX) {
      // If the object reaches either edge, multiply speed by -1 to turn it around.
      Xspeed = abs(Xspeed);
      //      ballXPos = faceRight+Xspeed;
      println("collideRigtSide");
    }
    //    

//    if (faces[i].y != faces[i].y) {
//      dy = (faces[i].y-faces[i+1].y)/2.0;
//      if (dy >  5) { 
//        dy =  5;
//      }
//      if (dy < -5) { 
//        dy = -5;
//      }
//    }
  }
}

/**
 * Changes contrast/brigthness values
 */
void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}


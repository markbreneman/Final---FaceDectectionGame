//LIBRARY CALLS
import hypermedia.video.*;
import java.awt.Rectangle;

//OPEN CV VARIABLES 
OpenCV opencv;
int contrast_value    = 0;
int brightness_value  = 0;

///BALL VARIABLES

int ballXPos;
int ballYPos;
int ballheight=10;
int ballwidth=10;
int Xspeed=10;
int Yspeed=10;
float dy;
ArrayList balls; 

///TIMER 
Timer timer;

void setup() {

  size( 320, 240 );
  //OPENCVSETUP
  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // START VIDEO
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  //  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  //  opencv.threshold(20);       
  //BALLSETUP
  ballXPos=width/2;
  ballYPos=ballheight+1;
  balls= new ArrayList();
  balls.add(new Ball(width/2, height/2, 10));

  //TIMER
  timer=new Timer(2000);
  timer.start();
}

void draw() {
  opencv.read();//GRAB A NEW FRAME
  opencv.flip( OpenCV.FLIP_HORIZONTAL ); // FLIP IMAGE HORIZONTALLY
  //  opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  // display the image
  image( opencv.image(), 0, 0 );
  fill(255, 0, 0);
  stroke(255, 0, 0);
  //  ellipseMode(CENTER);
  //  ellipse(ballXPos, ballYPos, ballwidth, ballheight);//DRAWING THE BALL    
  //  if (faces.length > 0) {
  //  ballXPos+=Xspeed;
  //  ballYPos+=Yspeed;
  //
  //    //KEEPING THE BALL IN BOUNDS OF THE SCREEN
  //
  //    if (ballYPos>height) {
  //      ballYPos=height;
  //      Yspeed=0;
  //      Xspeed=0;
  //    }
  //    if ( ballYPos < ballheight) {
  //      Yspeed*=-1;
  //    } 
  //    if ( ballXPos < ballwidth || ballXPos >width-ballwidth ) {
  //      Xspeed*=-1;
  //    } 
  for (int i = balls.size()-1; i >= 0; i--) {
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Ball ball = (Ball) balls.get(i);
    ball.moveBall();
  }

  ////FACE DETECTION RECTANGLE DRAWING

  for ( int i=0; i<faces.length; i++ ) {
    noFill();
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
    ///CREATING THE TOP SURFACE 
    int faceLeft=faces[i].x;
    int faceRight=faces[i].x+faces[i].width;
    int faceBottom=faces[i].y+faces[i].height;
    int faceTop=faces[i].y;
    int faceCenterX=faces[i].x+faces[i].width/2;
    int faceCenterY=faces[i].y+faces[i].height/2;


    if (ballYPos > faceTop-ballheight&& ballYPos<faceCenterY && ballXPos>faceLeft+ballwidth && ballXPos<faceRight+ballwidth) {
      Yspeed = -abs(Yspeed);
      //      ballYPos = faceTop+Yspeed;
      println("collideTop");
    }
    //    //SIDE RECTANGLE EFFECT
    if (ballYPos > faceTop && ballYPos < faceBottom && ballXPos > faceLeft && ballXPos<faceCenterX) {
      Xspeed = -abs(Xspeed);
      //      ballXPos = faceLeft+Xspeed;
      println("collideLeftSide");
    }

    if (ballYPos > faceTop && ballYPos < faceBottom  && ballXPos<faceRight && ballXPos>faceCenterX) {
      Xspeed = abs(Xspeed);
      //      ballXPos = faceRight+Xspeed;
      println("collideRightSide");
    }
  }
  if (timer.isFinished()) {
    // Add a new ball
    balls.add(new Ball(int(random(0, width)), int(random(0, height/4)), 10)); 
    // Start timer again
    timer.start();
  }
}


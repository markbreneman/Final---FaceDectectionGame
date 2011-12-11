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

///BALL VARIABLES

int ballXPos;
int ballYPos;
int ballheight=10;
int ballwidth=10;
int Xspeed=10;
int Yspeed=10;
float dy;
ArrayList Balls; 



//TIMER VARIABLES 
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
  Balls= new ArrayList();
  for (int i = 0; i < Balls.size();i++) {            // using the .size() to get the number of items in the array list 
//    ((ball)Balls.get(i)).drawBall();                  // this is a bit unpleasant... we need to cast waht we get out of
//     ((ball)Balls.get(i)).randomizePosition();        // the array list as a Ball , otherwise it wont know it is an object
  }                                                    // so by putting (Ball) before it we are forcing it to think of it 
                             
  
  
  //TIMER
  timer=new Timer(5000);
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
  new ball(ballXPos,ballYPos); 
  
  if (timer.isFinished()){new ball(int(random(0, width)),int(random(0,height)));}
    

  if (faces.length > 0) {
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
        println("collideRightSide");
      }
    }
  }
}

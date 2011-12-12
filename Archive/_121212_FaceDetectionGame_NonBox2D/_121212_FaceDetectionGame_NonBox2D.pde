//LIBRARY CALLS
import hypermedia.video.*;
import java.awt.Rectangle;

//OPEN CV VARIABLES 
OpenCV opencv;
int contrast_value    = 0;
int brightness_value  = 0;

///BALL VARIABLES

int ballxPos;
int ballyPos;
int ballheight=10;
int ballwidth=10;
int xAccel=20;
int yAccel=20;
float dy;
ArrayList balls; 

int zoom=3;

PFont font;                         //  Creates a new font object
int countTopCollisions;

///TIMER 
Timer timer;

void setup() {

  size( 640, 480 );
  font = loadFont("Tungsten-Medium-20.vlw");        //  Load the font file into memory
  textFont(font, 20);   
  //OPENCVSETUP
  opencv = new OpenCV( this );
  opencv.capture( width/zoom, height/zoom);                   // START VIDEO
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );
  //  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  //  opencv.threshold(20);       

  //BALLSETUP
  balls= new ArrayList();
  balls.add(new Ball(width/2, 0, 15));

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
  image( opencv.image(), 0, 0, width,height );
  fill(255, 0, 0);
  stroke(0, 0, 0);
  text("Headers = " + countTopCollisions, width/2, height);  
  ////FACE DETECTION RECTANGLE DRAWING

  for ( int i=0; i<faces.length; i++ ) {
    //SCALE THE SIZE BACK UP
    faces[i].x*=zoom;
    faces[i].y*=zoom;
    faces[i].width*=zoom;
    faces[i].height*=zoom;
    noFill();
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
    ///CREATING THE TOP SURFACE 
    int faceLeft=faces[i].x;
    int faceRight=faces[i].x+faces[i].width;
    int faceBottom=faces[i].y+faces[i].height;
    int faceTop=faces[i].y;
    int faceCenterX=faces[i].x+faces[i].width/20;
    int faceCenterY=faces[i].y+faces[i].height/20;
    for (int j=0; j<balls.size(); j++) {
      Ball ball = (Ball) balls.get(j);
      ball.moveBall();
      // // TOP SURFACE INTERACTION
      if (ball.yPos > faceTop-ballheight&& ball.yPos<faceCenterY && ball.xPos>faceLeft+ballwidth && ball.xPos<faceRight+ballwidth) {
        ball.yAccel = -abs(ball.yAccel);
        //      ballyPos = faceTop+yAccel;
        println("collideTop");
        
       if(ball.colliding==false){
        ball.colliding=true;
        countTopCollisions++;}

      
    }
    else{
   if(ball.colliding==true){
        ball.colliding=false;}
      
    }
      //    //LEFT SIDE RECTANGLE EFFECT
      if (ball.yPos > faceTop && ball.yPos < faceBottom && ball.xPos > faceLeft && ball.xPos<faceCenterX) {
        ball.xAccel = -abs(ball.xAccel);
        //      ballxPos = faceLeft+xAccel;
        println("collideLeftSide");
      }
      //    //RIGHT SIDE RECTANGLE EFFECT
      if (ball.yPos > faceTop && ball.yPos < faceBottom  && ball.xPos<faceRight && ball.xPos>faceCenterX) {
        ball.xAccel = abs(ball.xAccel);
        //      ballxPos = faceRight+xAccel;
        println("collideRightSide");
      }
      //    //BOTTOM SIDE RECTANGLE EFFECT
      if (ball.yPos < faceBottom+ballheight && ball.yPos>faceCenterY && ball.xPos>faceLeft+ballwidth && ball.xPos<faceRight+ballwidth) {
        ball.yAccel = abs(ball.yAccel);
        //      ballyPos = faceTop+yAccel;
        println("collideBottom");
      }
    }
    if (timer.isFinished()) {
      // Add a new ball
      balls.add(new Ball(int(random(0, width)), 0, 15)); 
      // Start timer again
      timer.start();
    }
  }
}


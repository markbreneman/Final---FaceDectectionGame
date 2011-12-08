// Written by Parag K. Mital
// 16 Feb 2009
// Document created as part of tutorial workshop in Processing.org for 
// the Digital Media Studio Project 2009, University of Edinburgh

import java.awt.*;			// java awt library
//import processing.core.*;	// all processing functionality

import hypermedia.video.*;
/* OpenCV: http://ubaa.net/shared/processing/opencv
 * javadocs: http://ubaa.net/shared/processing/opencv/javadoc/
 * add the .jnlib file to your /Library/Java/Extensions/ folder
 */

//public class tutorial1 extends PApplet {
// the opencv object that contains all the functionality for 
// camera/movie/image i/o, and computer vision routines
OpenCV cv = null;

// camera width/height
int capture_width = 320;
int capture_height = 240;

// threshold for background subtraction
int threshold = 125;

// some variables to control the contrast/brightness of the camera image
int contrast = 0, brightness = 0;

// for drawing text
PFont font;

// these boolean values will be used to trigger parts of the code - we
// can use the keyPressed method to set these boolean values with the keyboard
boolean draw_blobs=true, draw_centroid=true, show_difference=true;

// we are going to track the centroid of all blobs and keep the previous
// and current estimate
int previous_centroid_x = capture_width / 2;
int previous_centroid_y = capture_height / 2;
int current_centroid_x = capture_width / 2;
int current_centroid_y = capture_height / 2;

// this function is called once, so we use it to initialize all of our variables, etc... 
void setup() {
  // Size of the window
  size(capture_width*4, capture_height+20);

  // Instantiate opencv with an instance of our applet
  cv = new OpenCV(this);

  // Setup our capture device using opencv
  cv.capture(capture_width, capture_height, 0);

  // Setup our face detection (take a look at the other CASCADE's such as
  // FULLBODY, UPPERBODY, FRONTALFACE_ALT...
  cv.cascade(OpenCV.CASCADE_FRONTALFACE_DEFAULT);

  // Setup font to use the Andale Mono type font (this file is in the data folder)
  font = loadFont("SansSerif-10.vlw");
  textFont(font);
}

// after setup() has run, draw() will run in an infinite loop, also checking any events from
// i/o such as the mouse and keyboard callbacks (e.g. mousePressed, keyPressed)
void draw() {
  // set the background color to black
  background(0);

  // display the frame per second of our program. if this gets too low,
  // our program will appear less interactive as the latency will be higher
  text("fps: " + frameRate, 10, capture_height+10);

  // Read the current frame from our camera device
  cv.read();
  //cv.flip(cv.FLIP_HORIZONTAL);	

  // adjust the Contrast/Brightness (stored in OpenCV.BUFFER)
  cv.contrast(contrast);
  cv.brightness(brightness);

  // call the method for background subtraction
  doBackgroundSubtraction();

  // and blob detection
  doBlobDetection();

  // now face detection
  doFaceDetection();
}

void doBackgroundSubtraction() {

  // OpenCV has 3 images you can access, 
  // the SOURCE (original image from camera or movie)
  // the BUFFER (image after any operations like convert, brightness, threshold, etc...)
  // the MEMORY (the image stored when OpenCV.remember(..) is called)
  image( cv.image(OpenCV.SOURCE), 0, 0 );
  text( "original source image", 10, 10 );

  // use the OpenCV function convert to convert 
  // the source image to grayscale and store in the
  // OpenCV.BUFFER
  cv.convert(OpenCV.GRAY);

  image( cv.image(OpenCV.BUFFER), capture_width, 0 );
  text( "grayscale buffer image", capture_width+10, 10);

  // Calculate the absolute difference between the 
  // image in the OpenCV Memory and the current image
  cv.absDiff();
  // Create a binary matrix in the OpenCV.BUFFER that 
  // has values >= threshold set to 1, 
  // and values < threshold set to 0
  cv.threshold(threshold);
  text( "threshold: " + threshold, capture_width*2+10, capture_height+10 );

  // Blur the image in the OpenCV.BUFFER
  cv.blur(OpenCV.GAUSSIAN, 11);

  if (show_difference)
  {
    image( cv.image(OpenCV.BUFFER), capture_width*2, 0 );
    text( "absoulte-difference blurred image", capture_width*2+10, 10 );
  }

  image( cv.image(OpenCV.MEMORY), capture_width*3, 0 );
  text( "memory image", capture_width*3+10, 10 );
}

void doBlobDetection() {

  // Do the blob detection
  Blob[] blobs = cv.blobs(100, capture_width*capture_height/3, 1, false);
  /* public Blob[] blobs(int minArea,
   int maxArea,
   int maxBlobs,
   boolean findHoles) */

  // Pushing a matrix allows any transformations such as rotate, translate, or scale,
  // to stay within the same matrix.  once we "popMatrix()", then all the commands for that matrix
  // are gone for any subsequent drawing.
  pushMatrix();
  // since we translate after we pushed a matrix, every drawing command afterwards will be affected
  // up until we popMatrix().  then this translate will have no effect on drawing commands after
  // the popMatrix().
  translate(capture_width*2, 0);

  // We are going to keep track of the total x,y centroid locations to find
  // an average centroid location of all blobs
  int total_x = 0;
  int total_y = 0;		

  // we loop through all of the blobs found by cv.blobs(..)
  for ( int blob_num = 0; blob_num < blobs.length; blob_num++ ) {

    if (draw_blobs)
    {
      // get the bounding box from the blob detection and draw it
      Rectangle bounding_box = blobs[blob_num].rectangle;
      noFill();
      stroke(128);
      this.rect( bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height );
    }

    // accumulate the centroids
    Point centroid = blobs[blob_num].centroid;
    total_x += centroid.x;
    total_y += centroid.y;
    println("Center x" + total_x);
  }

  if (blobs.length > 0)
  {
    // by keeping the previous centroid, we can do an interpolation between
    // the current centroid and the previous one.  this will make any tracking results
    // seem smoother.  a better way would be to use a low pass filter over a vector
    // of centroid locations.  i.e. keep more than just 1 previous location and 
    // find a better way of interpolating the current centroid from them.
    previous_centroid_x = current_centroid_x;
    previous_centroid_y = current_centroid_y;

    current_centroid_x = (total_x/blobs.length + previous_centroid_x) / 2;
    current_centroid_y = (total_y/blobs.length + previous_centroid_x) / 2;
  }

  if (draw_centroid)
  {
    // draw a crosshair at the centroid location
    this.ellipse(current_centroid_x, current_centroid_y, 5, 5);
    this.line( current_centroid_x-5, current_centroid_y, current_centroid_x+5, current_centroid_y );
    this.line( current_centroid_x, current_centroid_y-5, current_centroid_x, current_centroid_y+5 );
  }
  popMatrix();
}

void doFaceDetection() {
  cv.restore();
  Rectangle[] faces = cv.detect(1.2f, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 20, 20);
  // draw face area(s)
  text("faces: " + faces.length, capture_width + 10, capture_height + 10);
  translate(capture_width, 0);
  noFill();
  stroke(255, 0, 0);
  println(faces.length);
  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
  }
}

// keyPressed is a processing function that lets us know when a user
// has pressed a key.  the variable, key, will be set to a character of the keyboard.
void keyPressed() {
  if ( key == ' ' ) {
    //cv.flip(cv.FLIP_HORIZONTAL);	
    cv.remember(OpenCV.SOURCE);
  }
  if ( key == '+') {
    if (threshold >= 255) threshold = 255;
    else threshold++;
  }
  if ( key == '-' ) {
    if (threshold <= 0) threshold = 0;
    else threshold--;
  }
  if (key == 'b' ) {
    draw_blobs = !draw_blobs;
  }
  if (key == 'c' ) {
    draw_centroid = !draw_centroid;
  }
  if (key == 'd') {
    show_difference = !show_difference;
  }
}

void mouseDragged() {
  contrast = (int) map( mouseX, 0, width, -90, 90 );
  brightness = (int) map( mouseY, 0, width, -90, 90 );
} 


//}

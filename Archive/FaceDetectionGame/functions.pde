class ball {                                      
  float locX, locY, dirX, dirY, cx, cy;                                   // instance variables
  float ballSpeed=0;
  //  float gravity=0.1; // Define the Gravitational Constant
  //  float dampening=-.75; // Defining the dampening effect

  ball(int tempX, int tempY) {      // constructor to create the ball template
    locX = tempX; // Xpostion of the ball
    locY = tempY; // Yposition of the ball
    //    dirX= 5; // X Movement magnitude
    //    dirY=5; // Y Movement magnitude
    ellipseMode(CENTER);
    ellipse(locX, locY, 10, 10);//create the ball
  }
}

//  void move() {                                    // function to move the ball
//    locX+= dirX; // changing the X location and starting to move
//    locY+= dirY; // changing the y location and starting to move
//    locY=locY+ballSpeed;
//    if (locX <0 || locX > width)dirX*=-1; //Keep ball in the screen width wise
//    if (locY <0 || locY > height)dirY*=-1;//Keep ball in the screen heigh wise
//    ballSpeed=ballSpeed+gravity; // This sets the velocity of ball
//    if (locY>height) {
//      ballSpeed=ballSpeed*dampening;//dampening effect of the motion
//    }
//// Add speed to location.
//  locY = locY + ballSpeed;
//  
//  // Add gravity to speed.
//  ballSpeed = ballSpeed + gravity;
//  
//  // If square reaches the bottom
//  // Reverse speed
//  if (locY > height) {
//    // Multiplying by -0.95 instead of -1 slows the square down each time it bounces (by decreasing speed).  
//    // This is known as a "dampening" effect and is a more realistic simulation of the real world (without it, a ball would bounce forever).
//    ballSpeed = ballSpeed*dampening;  
//  }
//}


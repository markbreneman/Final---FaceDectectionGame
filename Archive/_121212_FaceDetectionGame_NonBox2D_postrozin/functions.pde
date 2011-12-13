class Ball {                                      
  float xPos, yPos, dia, xAccel, yAccel;
  boolean colliding=false;
  //  float gravity=0.1; // Define the Gravitational Constant
  //  float dampening=-.75; // Defining the dampening effect

  Ball (int x, int y, int d) {
    xPos = x;
    yPos = y;
    xAccel = 5;
    yAccel = 5;
    dia = d;
  }
  void moveBall() {

    //horizontal bounce
    if (xPos<=0+dia/2)
    {
      xAccel=-xAccel;
      xPos=dia/2+1;
    }
    else if (xPos>=width-dia/2)
    {
      xAccel=-xAccel;
      xPos=width-dia/2-1;
    }
    else //increment xPos
    {
      xPos=xPos+xAccel;
    }

    //vertical bounce
    if (yPos<=0+dia/2)
    {
      yAccel=-yAccel;
      yPos=dia/2+1;
    }
    else if (yPos>=height-dia/2)
    {
//      yAccel=-yAccel;
      yAccel=0;
      xAccel=0;
      yPos=height-dia/2-1;
    }
    else //increment yPos
    {
      yPos=yPos+yAccel;
    }
    //draw new position
    smooth();
    fill(230, 230, 230);
    stroke(0);
    strokeWeight(2);
    ellipse(xPos, yPos, dia, dia);
  }
}

class Timer {

  int savedTime; // Started Timer
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } 
    else {
      return false;
    }
  }
}


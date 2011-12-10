class Ball {
  int xPos, yPos, xAccel, yAccel, dia;
  color cirCol;
  Ball (int x, int y, int a, int b, color c, int d) {
    xPos = x;
    yPos = y;
    xAccel = a;
    yAccel = b;
    cirCol = c;
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
      yAccel=-yAccel;
      yPos=height-dia/2-1;
    }
    else //increment yPos
    {
      yPos=yPos+yAccel;
    }
    //draw new position
    colorMode(RGB, width-dia, 255, width-dia, 2);
    cirCol = color(width-(xPos+dia/2), 0, xPos+dia/2, 1);
    fill(cirCol);
    ellipse(xPos, yPos, dia, dia);
  }
}

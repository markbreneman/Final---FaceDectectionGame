// The Face as a Paddle
class Paddle {

  // the paddle is a rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;

  //making it a body for box2D
  Body p;

  Paddle(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    Vec2 center = new Vec2(x, y);
    ellipse(x, y, 10, 10);

    // Creating the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(center));
    p = box2d.createBody(bd);

    // Define the polygon
    PolygonDef sd = new PolygonDef();
    sd.setAsBox(box2dW, box2dH);
    sd.density = .3;    // No density means it won't move!
    sd.friction = 0.3f;
    sd.restitution = 2.0;
    p.createShape(sd);
//    p.setMassFromShapes();
        noFill();
        stroke(0);
        rectMode(CORNER);
        rect(x, y, w, h);
  }
}

//  // Draw the paddle
//  void display() {
//    noFill();
//    stroke(0);
//    rectMode(CORNER);
//    rect(x, y, w, h);
//  }
//}


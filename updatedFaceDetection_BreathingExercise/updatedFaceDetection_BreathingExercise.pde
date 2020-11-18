import processing.video.Capture;
import gab.opencv.OpenCV;
import java.awt.Rectangle;

Capture cam;
OpenCV opencv;

// input resolution
int w = 320, h = 240;

// output zoom
int zoom = 3;


int numSides = 9;
int numLayers = 10;
PVector[][] pts;
float breathe = .5;


void setup() {
  //size(600, 600);
    size(960, 720);
    //size(640, 480);
  background(0);
  
  
    cam = new Capture(this, w, h);
  cam.start();

  // init OpenCV with input resolution
  opencv = new OpenCV(this, w, h);

  // setup for facial recognition
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
  translate(width/2, height/2);
  fill(100);
  smooth();

  stroke(255);

  strokeWeight(2);
  strokeJoin(ROUND);

  computePts(numSides, numLayers);
}

void draw() {
  background(#ffffff);
  
  
  
    // get the camera image
  opencv.loadImage(cam);

  // detect faces
  Rectangle[] faces = opencv.detect();

  // zoom to input resolution
  scale(zoom);

  // draw input image
  image(opencv.getInput(), 0, 0);

  // draw rectangles around detected faces
  fill(255, 64);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }

  // show performance and number of detected faces on the console
  if (frameCount % 50 == 0) {
    println("Frame rate:", round(frameRate), "fps");
    println("Number of faces:", faces.length);
  }
  
  
  
  
  
  translate(width/6, height/6); 
  rotate(-TWO_PI/numSides * .25);

  //breathe = map(sin(float(frameCount)/40*TWO_PI/10), -1, 1, .28, 1.2); //adjust speed here
    breathe = map(sin(float(frameCount)/15*TWO_PI/10), -1, 1, .28, 1.2); //adjust speed here
  
  if (key == 'b') {
  computePts(numSides, numLayers);

  for (int i=1; i<numLayers; i++) {
    fill(#99e7ff, map(i, 1, numLayers, 255, 100));
    stroke(#ffffff);
    beginShape(QUAD_STRIP);
    for (int j=1; j<numSides+1; j++) {
      PVector p1 = pts[i-1][j%numSides];
      PVector p2 = pts[i][abs((j-i%2)%numSides)];
      PVector p3 = pts[i][(j+1-i%2)%numSides];
      PVector p4 = pts[(i+1)][j%numSides];
     
      vertex(p1.x, p1.y);
      vertex(p2.x, p2.y);
      vertex(p3.x, p3.y);
      vertex(p4.x, p4.y);
    }
    endShape();
  }
  }
}

void computePts(int _numSides, int _numLayers) {
  pts = new PVector[_numLayers+1][_numSides];

  for (int i=0; i<_numLayers+1; i++) {
    for (int j=0; j<_numSides; j++) {
      float x, y, r, ang;
      r = pow(float(i)/(_numLayers+1), breathe) * width/2;
      ang = TWO_PI / _numSides * (j + 0.5*(i%2)); //alternate rotation b/w layers
      x = r * cos(ang);
      y = r * sin(ang);
      pts[i][j] = new PVector(x, y);
    }
  }
}


void captureEvent(Capture c) {
  c.read();
}


void keyPressed() {
  if (key=='s' && numSides<18) numSides++;  
  if (key=='a' && numSides > 3) numSides--;
  
  if(key=='x' && numLayers < 25) numLayers++ ;
  if(key=='z' && numLayers > 2) numLayers--;
  
  computePts(numSides, numLayers);
}

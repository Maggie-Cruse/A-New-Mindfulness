//Cassidy Carson
//Maggie Cruse
//Quincy Lin
/*First run the SuperCollider patch (titled "A New Mindfulness"). 
Then run this  sketch and hear the sound produced via facial recognition data. 
To enter meditation mode, click on the blue icon in the upper lefthand side of the sketch. 
In sync with the movement of shapes, inhale and exhale while hearing the healing frequencies now being produced. 
To exit meditation mode, press '1' on your keyboard. 
Press '2' on your keyboard to once again enter meditiation mode when desired.
*/

import processing.video.Capture;
import gab.opencv.OpenCV;
import java.awt.Rectangle;

import netP5.*;
import oscP5.*;

//Use webacm
Capture cam;
OpenCV opencv;


//Osc
OscP5 osc;
NetAddress supercollider;


// input resolution
int w = 320, h = 240;

// output zoom
int zoom = 3;

//meditation mode (many 'techno' faces)
int numSides = 9;
int numLayers = 10;
PVector[][] pts;
float breathe = .5;

//meditation mode button (fewer 'techno' faces)
int numSides2 = 9;
int numLayers2 = 3;
PVector[][] pts2;
float breathe2 = .5;

//class button - meditation mode
Button b1; 

// 2 integrated screen 'places'
int currentScreen;
int screen1;
int screen2;

boolean IsClicked = false;

void setup() {
  size(960, 720);
  background(0);


  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);


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

  //meditation mode
  computePts(numSides, numLayers);
  //mediation mode button
  computePts2(numSides2, numLayers2);


  //meditation button
  b1 = new Button(color (#355C7D), (width/2 + 380), (30), (50), (50), (width/2+380), (width/2+430), (30), (80));

  screen1 = 1;
  screen2 = 2;
  currentScreen = screen1;
}



void draw() {
  background(#ffffff);
  //tint(0, 153, 204);  // Tint blue

  if (currentScreen == screen1) {
    screen1();
  } else if (currentScreen == screen2) {
  screen2();
  }
  
  //meditation mode button
  translate(width/3 - 30, height/20 -10); 
  rotate(-TWO_PI/numSides2 * .25);

  computePts2(numSides2, numLayers2);

  for (int i=1; i<numLayers2; i++) {
    fill(#99e7ff, map(i, 1, numLayers2, 255, 100));
    strokeWeight(0.5);
    stroke(#ffffff);
    beginShape(QUAD_STRIP);
    for (int j=1; j<numSides2+1; j++) {
      PVector p1 = pts2[i-1][j%numSides2];
      PVector p2 = pts2[i][abs((j-i%2)%numSides2)];
      PVector p3 = pts2[i][(j+1-i%2)%numSides2];
      PVector p4 = pts2[(i+1)][j%numSides2];

      vertex(p1.x, p1.y);
      vertex(p2.x, p2.y);
      vertex(p3.x, p3.y);
      vertex(p4.x, p4.y);
    }
    endShape();
  }
    
    if (b1.IsClicked()==true) {
      currentScreen = screen2;
    }
  
  keyPressed();
}



void screen1() {
  b1.display();
  
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
    
    //sending values to supercollider for screen 1
    OscMessage myOsc = new OscMessage("/mindfulness");
    myOsc.add(faces[i].x); //send x value
    myOsc.add(faces[i].y); //send y value
    myOsc.add(.05); //send amplitude to turn on synth 1
    myOsc.add(0); //zeroes to silence screen 2 synth
    myOsc.add(0);
    osc.send(myOsc, supercollider);
  }

  // show performance and number of detected faces on the console
  if (frameCount % 50 == 0) {
    println("Frame rate:", round(frameRate), "fps");
    println("Number of faces:", faces.length);
  }
  b1.click = false;
}


void screen2() {
    b1.click = false;
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
    
    //send values to supercollider for screen 2
    OscMessage myOsc = new OscMessage("/mindfulness"); 
    myOsc.add(0); //zeroes to silence screen 1 synth
    myOsc.add(0);
    myOsc.add(0);
    myOsc.add(faces[i].x); //send x value
    myOsc.add(0.08); //send amplitude to turn on synth 2
    osc.send(myOsc, supercollider);
  }

  // show performance and number of detected faces on the console
  if (frameCount % 50 == 0) {
    println("Frame rate:", round(frameRate), "fps");
    println("Number of faces:", faces.length);
  }
  //meditation mode
    translate(width/6, height/6);
    rotate(-TWO_PI/numSides * .25);
    breathe = map(sin(float(frameCount)/15*TWO_PI/10), -1, 1, .28, 1.2); //adjust speed here
    computePts(numSides, numLayers);

    for (int i=1; i<numLayers; i++) {
      fill(#99e7ff, map(i, 1, numLayers, 255, 100), 255, 120);
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


void keyPressed() {
  if (key == '1') {
    currentScreen = screen1;
  } else if (key == '2') {
    currentScreen = screen2;
  }
}

// meditation mode
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

// meditation mode button
void computePts2(int _numSides, int _numLayers) {
  pts2 = new PVector[_numLayers+1][_numSides];

  for (int i=0; i<_numLayers+1; i++) {
    for (int j=0; j<_numSides; j++) {
      float x, y, r, ang;
      r = pow(float(i)/(_numLayers+1), breathe2) * width/50;
      ang = TWO_PI / _numSides * (j + 0.5*(i%2)); //alternate rotation b/w layers
      x = r * cos(ang);
      y = r * sin(ang);
      pts2[i][j] = new PVector(x, y);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

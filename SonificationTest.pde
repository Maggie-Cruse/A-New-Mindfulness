import netP5.*;
import oscP5.*;


float x;
float y;
float l;
float w;

OscP5 osc;
NetAddress supercollider;


void setup(){
  size(500,500);
  background(0);
  stroke(255);
  rectMode(CENTER);

  
  osc = new OscP5(this,12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  
  
  
  x= random(width);
  y =random(height);
  l = 100;
  w = 100;
  
  
  
}


void draw(){
    drawRect();
    OscMessage myOsc = new OscMessage("/move");
    myOsc.add(x);
    myOsc.add(y);
    osc.send(myOsc,supercollider);
  
}

void drawRect(){
  
  
  rectMode(CENTER);
  rect(x,y,w,l);
}


     
     

 

class Button {
  color buttonC;
  float buttonX1;
  float buttonY1;
  float buttonW1;
  float buttonH1;
  float xBound1;
  float xBound2;
  float yBound1;
  float yBound2;
  boolean click;
  
    Button(color bC, float xPosit, float yPosit, float wid, float he, float xB1, float xB2, float yB1, float yB2) {
    this.buttonC=bC;
    this.buttonX1=xPosit;
    this.buttonY1=yPosit;
    this.buttonW1=wid;
    this.buttonH1=he;
    this.xBound1=xB1;
    this.xBound2=xB2;
    this.yBound1=yB1;
    this.yBound2=yB2;
    this.click = false;
  }
  
   void display() {
    strokeWeight(5);
    stroke(255);
    fill(this.buttonC);
    rect(this.buttonX1, this.buttonY1, this.buttonW1, this.buttonH1);
    noStroke();
  }

  boolean IsClicked() {
    if (mousePressed == true && mouseX>this.xBound1 && mouseY>this.yBound1 && mouseY<this.yBound2 && mouseX<this.xBound2) {
      click=true;
    }
    return click;
  }
}

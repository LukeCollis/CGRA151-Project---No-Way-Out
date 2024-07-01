class Button{
  float w;
  float h;
  float x;
  float y;
  PImage img;
  
  
  public Button(float w, float h, float x, float y, PImage img){
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.img = img;
  
  }
  
  boolean isClicked(){
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  
  }

  void draw(){
  image(img, x, y, w, h);
  }
 
}

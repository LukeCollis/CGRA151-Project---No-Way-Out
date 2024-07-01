enum animState{
  Idle, Run, Crouch_Walk, Crouch_Idle, Jump, Land, Walk
}

class Player {
  float w;
  float h;
  PVector pos; // stores x, y position of player.
  PVector vel; // stores x-velocity and y-velocity of player.
  float jSpeed;
  float speed;
  int sNum;
  boolean isMoving;
  boolean movingLeft;
  boolean movingRight;
  private PImage[] sprites; //stores the sprites
  private int currentFrame; //current frame of animation
  private int spriteWidth; //width of sprite
  private int spriteHeight; //height of sprite
  private animState state; //current state of the player
  

  public Player(PImage sheet, int sNum) {
    this.sprites = new PImage[sNum];
    this.spriteWidth = sheet.width / sNum;
    this.spriteHeight = sheet.height;
    this.currentFrame = 0;
    this.state = animState.Idle;
    this.sNum = sNum;
    for (int i = 0; i < sNum; i++) { //Gets the first sprite from the sheet.
      int startX = i * spriteWidth;
      sprites[i] = sheet.get(startX, 0, spriteWidth, spriteHeight);
    }
  }
  
  public void setState(animState newState){
    if(state != newState){
      state = newState;
      loadSpritesForState();
      currentFrame = 0;
    }
  }
  
  private void loadSpritesForState() { //loads a new sprite when the state is changed.
    String name = state.toString();
    sprites = new PImage[sNum];
    PImage sheet = loadImage(name + ".png");
    for (int i = 0; i < sNum; i++) {
        int startX = i * spriteWidth;
        sprites[i] = sheet.get(startX, 0, spriteWidth, spriteHeight);
    }
    spriteWidth = sprites[0].width;
    spriteHeight = sprites[0].height;
    this.w = spriteWidth;
    this.h = spriteHeight;
  }
  
  public PImage[] getSprites() { //returns sprites.
    return sprites;
  }
  
  public void updateAnimation() { //updates the animation and moves it to the next frame
      currentFrame++;
      if (currentFrame >= sprites.length - 2) {
        currentFrame = 0;
      }
  }
  
  public void draw() { //draws the sprite.
    pushMatrix();
    translate(pos.x, pos.y);
    scale(2.5);
    if (movingLeft) {
      scale(-1, 1); 
      translate(-spriteWidth, 0);
    }
    image(sprites[currentFrame], 0, 0);
    popMatrix();
  }
  
  public boolean isMoving(){
    return isMoving;
  }
  
  public void setMovingLeft(boolean l){
    movingLeft = l;
  }
  
  public void setMovingRight(boolean r){
    movingRight = r;
  }
  
  public void setMoving(boolean m){
    isMoving = m;
  }
  
  public boolean getMoving(){
    return isMoving;
  }
  
  public int getWidth(){
    return spriteWidth;
  }
  
  public int getHeight(){
    return spriteHeight;
  }
  
  public void setX(float x){
    pos.x = x;
  }
  
  public void setY(float y){
    pos.y = y;
  }
  
  
  
} 

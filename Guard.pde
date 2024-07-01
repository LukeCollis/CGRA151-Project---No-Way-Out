enum enemyState{
 IdleG, WalkG
}

class Guard {
  float w;
  float h;
  PVector pos; // stores x, y position of guard.
  PVector vel; // stores x-velocity and y-velocity of Guard
  float speed;
  int sNum;
  private PImage[] sprites; //stores the sprites
  private int currentFrame; //current frame of animation
  private int enemyWidth; //width of sprite
  private int enemyHeight; //height of sprite
  private enemyState state; //current state of the player
  private PVector initialEnemyPos;
  private PVector initialEnemyOffset;
  boolean isFacingRight;

  public Guard(PImage sheet, int sNum, int x, int y) {
    this.sprites = new PImage[sNum];
    this.enemyWidth = sheet.width / sNum;
    this.enemyHeight = sheet.height;
    this.currentFrame = 0;
    this.state = enemyState.IdleG;
    this.sNum = sNum;
    this.pos = new PVector(x,y);
    this.initialEnemyPos = new PVector(x,y);
    this.initialEnemyOffset = new PVector(0,0);
    
    isFacingRight = true;
    
    for (int i = 0; i < sNum; i++) { //Gets the first sprite from the sheet.
      int startX = i * enemyWidth;
      sprites[i] = sheet.get(startX, 0, enemyWidth, enemyHeight);
    }
  }
 
  public void setState(enemyState newState){
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
        int startX = i * enemyWidth;
        sprites[i] = sheet.get(startX, 0, enemyWidth, enemyHeight);
    }
    enemyWidth = sprites[0].width;
    enemyHeight = sprites[0].height;
    this.w = enemyWidth;
    this.h = enemyHeight;
  }
  
  public PImage[] getSprites() { //returns sprites.
    return sprites;
  }
  
  public void updateAnimation() { //updates the animation and moves it to the next frame
      currentFrame++;
      if (currentFrame >= sprites.length) {
        currentFrame = 0;
      }
  }
  
  public void draw() { //draws the sprite.
    pushMatrix();
    translate(pos.x, pos.y);
    scale(2.5);
    if(!isFacingRight){
      scale(-1, 1); 
      translate(-spriteWidth, 0);
    }
    image(sprites[currentFrame], 0, 0);
    popMatrix();
  }

} 

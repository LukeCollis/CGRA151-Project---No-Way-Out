enum State{
  MENU,
  LEVEL1,
  LEVEL2,
  LEVEL1WIN,
  LEVEL1LOSE,
  LEVELSELECT,
  LEVEL2WIN,
  LEVEL2LOSE,
  CREDITS,
  PAUSE
}

import processing.sound.*;

//variables
SoundFile walk;
SoundFile jumpsound;
SoundFile intro;
Player p;
ArrayList<Guard> guardsl1 = new ArrayList<Guard>();
ArrayList<Guard> guardsl2 = new ArrayList<Guard>();
ArrayList<Integer> guardsL1X = new ArrayList<>();
ArrayList<Integer> guardsL2X = new ArrayList<>();
PImage playimg, level1, level2, menu, credits, creditbutton, retry, back, pause, win, gameover, menubutton;
Button play, l1, l2, menub, creditsb, retryb, backb;
State gameState = State.MENU;
State prevState;
PImage background;
boolean lineCollision;
float left;
float right;
float up;
float grav = .3;
float ground = 670;
PImage platl1, mid;
PImage platl2;
PVector platf, midf;
boolean collidingLeft;
boolean collidingRight;
boolean collidingBelow;
boolean collidingAbove;
boolean touchingLOS;
boolean isCrouching;
int direction = 1;
float leftLimit; //limit for movement for enemy.
float rightLimit; 
int spriteWidth;
int spriteHeight;
int enemyWidth;
int enemyHeight;
float x;
float backgroundScrollX = 0;
PVector initialEnemyPos;
PVector initialEnemyOffset;
float initialEnemyX;
int lastChangeTime = 0;
float totalDistanceTraveled;
int lastWalkSoundTime = 0;


void setup(){
  size(1600, 900);
  frameRate(30);
  guardsL1X.add(1400);
  guardsL1X.add(3200);
  guardsL1X.add(4000);
  guardsL1X.add(4800);
  guardsL1X.add(7200);
  guardsL2X.add(1900);
  guardsL2X.add(3700);
  guardsL2X.add(6300);
  guardsL2X.add(6900);
  guardsL2X.add(7200);
  guardsL2X.add(7900);
  guardsL2X.add(8200);
  guardsL2X.add(11000);
  PImage spriteSheet = loadImage("Idle.png");
  walk = new SoundFile(this, "walk.wav");
  jumpsound = new SoundFile(this, "jump.wav");
  intro = new SoundFile(this, "intro.wav");
  
  intro.play();
  

  
  if (spriteSheet != null) {
    int numSprites = 10;
    spriteWidth = spriteSheet.width / numSprites;
    spriteHeight = spriteSheet.height;
    
    if (spriteWidth != 0 && spriteHeight != 0) {
      p = new Player(spriteSheet, numSprites);
      p.setState(animState.Idle);  
    }
  }
 
 
  
  
  
  platl1 = loadImage("level1final.png");
  platl2 = loadImage("level2.png");
  mid = loadImage("middle.png");
  menu = loadImage("menu.png");
  menubutton = loadImage("menubutton.png");
  playimg = loadImage("play.png");
  level1 = loadImage("Level1button.png");
  level2 = loadImage("Level2button.png");
  credits = loadImage("credits.png");
  background = loadImage("background.png");
  creditbutton = loadImage("Credit.png");
  retry = loadImage("retry.png");
  back = loadImage("back.png");
  pause = loadImage("pause.png");
  win = loadImage("win.png");
  gameover = loadImage("gameover.png");
  
  
  PImage enemySheet = loadImage("IdleG.png");
  if(enemySheet != null){
    int numSprites = 10;
    enemyWidth = enemySheet.width / numSprites;
    enemyHeight = enemySheet.height;
    
    if(enemyWidth != 0 && enemyHeight != 0){
      for(int x: guardsL1X){
        guardsl1.add(new Guard(enemySheet, numSprites, x, int(ground+10)));
      }
      for(int x: guardsL2X){
        guardsl2.add(new Guard(enemySheet, numSprites, x, int(ground-20)));
      }
    }
  } 
  
 
  play = new Button(200, 100, width/2-150, height/2, playimg);
  l1 = new Button(200, 100, width/2-150, height/2+100, level1);
  l2 = new Button(200, 100, width/2-150, height/2+225, level2);
  menub = new Button(200, 100, width/3, height/2, menubutton);
  creditsb = new Button(200, 100, width/2-150, height/2+200, creditbutton);
  retryb = new Button(200, 100, width/2, height/2, retry);
  backb = new Button(200, 100, width - (width-150), height/2, back);
  p.jSpeed = 10;
  p.speed = 4;
  p.vel = new PVector(0,0);
  p.pos = new PVector(0, ground);
}

void draw(){
  stroke(0);
  background(0);
 
  if(gameState == State.LEVEL1){
    drawLevelOne();
  }
  else if(gameState == State.MENU){
    drawMenu();
  }
  else if(gameState == State.LEVELSELECT){
    drawLevelSelect();
  }
  else if(gameState == State.LEVEL2){
    drawLevelTwo();
  }
  else if(gameState == State.LEVEL1WIN){
    drawLevelOneWin();
  }
  else if(gameState == State.LEVEL1LOSE){
    drawLevelOneLose();
  }
  else if(gameState == State.CREDITS){
    drawCredits();
  }
  else if(gameState == State.LEVEL2LOSE){
    drawLevelTwoLose();
  }
  else if(gameState == State.LEVEL2WIN){
    drawLevelTwoWin();
  }
  else if(gameState == State.PAUSE){
    drawPause();
  }
}

 

void drawLevelOne(){
  clear();
  background(background);
  midf = new PVector(0,0);
  platf = new PVector(0,0);
  
  float backgroundX = -backgroundScrollX;
  image(mid, midf.x + backgroundX, midf.y);
  image(platl1, platf.x + backgroundX, platf.y);
 
  updateP();
  for(Guard g: guardsl1){
    updateG(g);
  }
  
  collidingLeft = isCollidingLeft(platl1);
  collidingRight = isCollidingRight(platl1);
  collidingBelow = isCollidingBelow(platl1);
  collidingAbove = isCollidingAbove(platl1);

  
  handleCollision(platl1);
  backgroundScrollX += p.vel.x;
  for(Guard g: guardsl1){
    g.initialEnemyOffset.x += p.vel.x;
  }
  textSize(10);
  if (collidingLeft || collidingRight) {
    fill(255, 0, 0); // Red color
    text("Collision Detected", 20, 20); 
  } else {
    fill(0, 255, 0); // Green color
    text("No Collision Detected", 20, 20); //For debugging, will remove.
  }
  if(collidingBelow){
    fill(255,0,0);
    text("Collision below detected", 80, 20);
  } else{
    fill(0,255,0);
    text("No collision below detected", 80, 20);
  }
  
    
  if(right == 1){
    totalDistanceTraveled += 4;
  }
  else if(left == -1){
    totalDistanceTraveled -= 4;
  }
  
  
  if(right == 0 && left == 0){
    if(!isCrouching){
      p.setState(animState.Idle);
    }
    else if (isCrouching){
      p.setState(animState.Crouch_Idle);
    }
  }
 
  if(lineCollision){
    gameState = State.LEVEL1LOSE;
  }
  if(totalDistanceTraveled >= 6500){
    gameState = State.LEVEL1WIN;
  }
}

void drawLevelTwo(){
  background(background);
  midf = new PVector(0,0);
  platf = new PVector(0,0);
  
  float backgroundX = -backgroundScrollX;
  image(platl2, platf.x + backgroundX, platf.y);
 
  updateP();
  for(Guard g: guardsl2){
    updateG(g);
  }
  
  collidingLeft = isCollidingLeft(platl2);
  collidingRight = isCollidingRight(platl2);
  collidingBelow = isCollidingBelow(platl2);
  collidingAbove = isCollidingAbove(platl2);

  
  handleCollision(platl2);
  backgroundScrollX += p.vel.x;
  for(Guard g: guardsl2){
    g.initialEnemyOffset.x += p.vel.x;
  }
  textSize(10);
  if(right == 0 && left == 0){
    if(!isCrouching){
      p.setState(animState.Idle);
    }
    else if (isCrouching){
      p.setState(animState.Crouch_Idle);
    }
  }
  if(lineCollision){
    gameState = State.LEVEL2LOSE;
  }
  if(totalDistanceTraveled >= 11000){
    gameState = State.LEVEL2WIN;
  }
  
  
}

void drawLevelOneWin(){
  background(win);
  menub.draw();
  if(mousePressed && menub.isClicked()){
    gameState = State.MENU;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  retryb.draw();
  if(mousePressed && retryb.isClicked()){
    gameState = State.LEVEL1;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  l2.draw();
  if(mousePressed && l2.isClicked()){
    gameState = State.LEVEL2;
    p.pos = new PVector(0, ground-20);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  
}

void drawLevelOneLose(){
  background(gameover);
  menub.draw();
  if(mousePressed && menub.isClicked()){
    gameState = State.MENU;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
    lineCollision = false;
  }
  retryb.draw();
  if(mousePressed && retryb.isClicked()){
    gameState = State.LEVEL1;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
    lineCollision = false;
  }
}

void drawLevelTwoWin(){
  background(win);
  menub.draw();
  if(mousePressed && menub.isClicked()){
    gameState = State.MENU;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  retryb.draw();
  if(mousePressed && retryb.isClicked()){
    gameState = State.LEVEL2;
    p.pos = new PVector(0, ground-20);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  l1.draw();
  if(mousePressed && l1.isClicked()){
    gameState = State.LEVEL1;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
  
}

void drawLevelTwoLose(){
  background(gameover);
  menub.draw();
  if(mousePressed && menub.isClicked()){
    gameState = State.MENU;
    p.pos = new PVector(0, ground-10);
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
    lineCollision = false;
  }
  retryb.draw();
  if(mousePressed && retryb.isClicked()){
    gameState = State.LEVEL2;
    p.pos = new PVector(0, ground-20);
    lineCollision = false;
    backgroundScrollX = 0;
    totalDistanceTraveled = 0;
  }
}

void drawMenu(){
  background(menu);
  play.draw();
  if(mousePressed && play.isClicked()){
    gameState = State.LEVELSELECT;
  }
  creditsb.draw();
  if(mousePressed && creditsb.isClicked()){
    gameState = State.CREDITS;
  }
}

void drawLevelSelect(){
  background(menu);
  l1.draw();
  if(mousePressed && l1.isClicked()){
    gameState = State.LEVEL1;
  }
  l2.draw();
  if(mousePressed && l2.isClicked()){
    gameState = State.LEVEL2;
  }

}

void drawCredits(){
  background(credits);
  backb.draw();
  if(mousePressed && backb.isClicked()){
    gameState = State.MENU;
  }
}

void drawPause(){
  background(pause);
  menub.draw();
  if(mousePressed && menub.isClicked()){
    gameState = State.MENU;
  }
}

//methods that handle the player and guards


void updateP(){
  if(p.pos.y < ground){
    p.vel.y += grav;
  } else { 
    p.vel.y = 0;
  }
  
  if( up != 0 && p.pos.y >= ground && !collidingAbove){
    p.vel.y = -p.jSpeed;
  }
  
  p.vel.x = p.speed * (left + right);
  
  
  float boundary = width * 0.2;
  float rightEdge = width - (width * 0.4);
  
  
  
  PVector newPos = new PVector(p.pos.x, p.pos.y);
  newPos.add(p.vel);
  
  if(newPos.x < boundary){
    newPos.x = boundary;
  }
  else if(newPos.x > rightEdge){
    newPos.x = rightEdge;
  }
  
  p.setX(newPos.x);
  
  float offset = 0;
   if (!collidingLeft && p.vel.x < 0) {
    if (newPos.x > offset) {
      p.pos.x = newPos.x;
    }
  }

  if (!collidingRight && p.vel.x > 0) {
    if (newPos.x < (width - offset)) {
      p.pos.x = newPos.x;
    }
  }

  if (!collidingAbove) {
    if (newPos.y > offset && newPos.y < (height - offset)) {
      p.pos.y = newPos.y;
    }
  }
  
  if (p.pos.x < (width * 0.1) && backgroundScrollX < 0) {
    backgroundScrollX -= p.vel.x*2;
  }
  
  fill(123);
  p.updateAnimation();
  p.draw();
  
}

void updateG(Guard g) {
  leftLimit = g.initialEnemyPos.x - 100;
  rightLimit = g.initialEnemyPos.x + 100;
  
  
  float enemyX = g.initialEnemyPos.x - g.initialEnemyOffset.x;
  enemyX = g.initialEnemyPos.x - backgroundScrollX;
  g.pos.x = enemyX;
  g.initialEnemyOffset.x = g.initialEnemyPos.x - enemyX;
  
  float losX = g.pos.x + 60;
  float losY = g.pos.y + 40;
  drawLineOfSight(losX, losY, radians(20), platl1, g);
  
  
  if (millis() - lastChangeTime >= 5000) {
    lastChangeTime = millis();
    if (direction == 1) {
      direction = -1;
      g.isFacingRight = false;
    } else if (direction == -1) {
      direction = 1;
      g.isFacingRight = true;
    }
  }
  
  

  
  
  
  
  g.updateAnimation();
  g.draw();
}


//methods that handle movement


void keyPressed(){
    if (key == 'd' || key == 'D') {
      if(!collidingRight){
        right = 1;
      }
      else if(collidingRight){
        right = 0;
      }
      if(!isCrouching){
        p.setState(animState.Walk);
      }
      else if(isCrouching){
        p.setState(animState.Crouch_Walk);
      }
      p.setMoving(true);
      p.setMovingRight(true);
      p.setMovingLeft(false);
      if (millis() - lastWalkSoundTime > 500 && gameState == State.LEVEL1 || gameState == State.LEVEL2) {
        walk.play();
        lastWalkSoundTime = millis();
      }
    }
    if (key == 'a' || key == 'A'){
      if(!collidingLeft){
        left = -1;
        totalDistanceTraveled -= abs(p.vel.x);
      }
      else if(collidingLeft){
        left = 0;
      }
      if(!isCrouching){
        p.setState(animState.Walk);
      }
      else if(isCrouching){
        p.setState(animState.Crouch_Walk);
      }
      p.setMoving(true);
      p.setMovingLeft(true);
      p.setMovingRight(false);
      if (millis() - lastWalkSoundTime > 200 && gameState == State.LEVEL1 || gameState == State.LEVEL2) {
        walk.play();
        lastWalkSoundTime = millis();
      }
      
    }
    if(key == ' ' && !collidingAbove){
      if(!collidingAbove){
        if(!isCrouching){
          up = -1;
          p.setState(animState.Jump);
          jumpsound.play();
        }
      }
    }
    if(key == 'c' || key == 'C'){
      if(isCrouching == false){
        isCrouching = true;
      }
      else if(isCrouching == true){
        isCrouching = false;
      }
    }
    if(key == 'p' || key == 'P'){
      if(gameState == State.LEVEL1 || gameState == State.LEVEL2){
        prevState = gameState;
        gameState = State.PAUSE;
      }
      else if(gameState == State.PAUSE){
        if(prevState == State.LEVEL1){
          gameState = State.LEVEL1;
        }
        else if(prevState == State.LEVEL2){
          gameState = State.LEVEL2;
        }
      }
    }
}

void keyReleased(){
  if (key == 'd' || key == 'D') {
    right = 0;
    p.setMoving(false);
  }
  if (key == 'a' || key == 'A'){
    left = 0;
    p.setMoving(false);
  }
  if(key == ' '){
    up = 0;
  }
 
}

//methods that handle collisions

boolean isCollidingLeft(PImage plat) {
  for (int j = 0; j < p.h; j++) {
    for (int i = 0; i < p.w / 1.5; i++) { 
      int x = int(p.pos.x + i + backgroundScrollX + 40);
      int y = int(p.pos.y + j + 40);
      int pixel = plat.get(x, y);
      if (alpha(pixel) > 0) {
        return true;
      }
    }
  }
  return false;
}

boolean isCollidingRight(PImage plat) {
  for (int j = 0; j < p.h; j++) {
    for (int i = 0; i < p.w / 1.2; i++) { 
      int x = int(p.pos.x + p.w + i + backgroundScrollX);
      int y = int(p.pos.y + j + 40);
      int pixel = plat.get(x, y);
      if (alpha(pixel) > 0) {
        return true;
      }
    }
  }
  return false;
}


boolean isCollidingBelow(PImage plat) {
  for (int i = 0; i < p.w; i++) {
    int pixel = plat.get(int(p.pos.x + i + backgroundScrollX + 30), int(p.pos.y + p.h + 55));
    if (alpha(pixel) > 0) {
      return true;
    }
  }
  return false;
}



boolean isCollidingAbove(PImage plat){
  for(int i = 0; i < p.w; i++){
    int pixel = plat.get(int(p.pos.x + i), int(p.pos.y - 1));
    if(alpha(pixel) > 0){
      return true;
    }
  }
  return false;
}

float findNearestGround(PImage plat) {
  int spriteX = int(p.pos.x - platf.x);
  int spriteY = int(p.pos.y + p.h);
  for (int i = spriteY; i < height; i++) { 
    if (i < 0) continue; 
    int pixel = plat.get(spriteX, i);
    if (alpha(pixel) == 0) {
      println("spriteX: " + spriteX);
      println("spriteY: " + spriteY);
      return i;
      
    }
  }
  return -1; // No nearest ground found
}



void handleCollision(PImage platform){
  if(isCollidingLeft(platform)){
    left = 0;
  }
  if(isCollidingRight(platform)){
    right = 0;
  }
  if(isCollidingBelow(platform)){
    ground = p.pos.y;
  } else{
    float ng = findNearestGround(platform);
      if(ng != -1){
        ground = ng;
      }
    }
}

//methods that handle the line of sight system

void drawLineOfSight(float startX, float startY, float cAngle, PImage plat, Guard g){
  int numRays = 100;
  
  beginShape();
  noFill();
  stroke(255, 255, 0, 128);
  
  if (!g.isFacingRight) {
    startX = g.pos.x + 45; 
  }
  
  for(int i = 0; i < numRays; i++){
    float angle = map(i,0, numRays -1, -cAngle / 2, cAngle / 2);
    float directionAngle = g.isFacingRight ? angle : PI - angle; 
    PVector collisionPoint = findCollisionPoint(startX, startY, directionAngle, plat);
    line(startX, startY, collisionPoint.x, collisionPoint.y);
    vertex(collisionPoint.x, collisionPoint.y);
    
    // Check for collision with the player
    if (isCollidingWithPlayer(startX, startY, collisionPoint.x, collisionPoint.y, p)) {
      lineCollision = true;
      break; 
    }
  }
  
  endShape(CLOSE);
}




PVector findCollisionPoint(float x1, float y1, float angle, PImage plat){
  float stepSize = 1.0;
  PVector currentPoint = new PVector(x1, y1);
  float maxLength = 300;
  while(!on(currentPoint.x + backgroundScrollX, currentPoint.y, plat) && dist(x1, y1, currentPoint.x, currentPoint.y) < maxLength){
    currentPoint.x += cos(angle) * stepSize;
    currentPoint.y += sin(angle) * stepSize;
  }
  return currentPoint;
}

boolean on(float x, float y, PImage plat){
   if (x >= 0 && x < plat.width && y >= 0 && y < plat.height) {
     int pixel = plat.get(int(x), int(y));
     if(alpha(pixel) > 0){
       return true;
     }
   }
   return false;
}

boolean isCollidingWithPlayer(float x1, float y1, float x2, float y2, Player p) {
  float minX = min(x1 - backgroundScrollX, x2 - backgroundScrollX);
  float maxX = max(x1 - backgroundScrollX, x2 - backgroundScrollX);
  float minY = min(y1, y2);
  float maxY = max(y1, y2);

  float playerLeft = p.pos.x - p.w / 2 - backgroundScrollX;
  float playerRight = p.pos.x + p.w / 2 - backgroundScrollX;
  float playerTop = p.pos.y - p.h / 2;
  float playerBottom = p.pos.y + p.h / 2;

  if (playerRight >= minX && playerLeft <= maxX &&
      playerBottom >= minY && playerTop <= maxY) {   
    return true;
  }
  return false;
}

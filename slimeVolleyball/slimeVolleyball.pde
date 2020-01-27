import fisica.*;

PFont font;
PImage bground, introbground, endbground, kirby, kirby2, vball, beach;

color brown = #D1A443;
color purple = #C683E8;
color pink = #F5B9EF;
color green = #8FE38E;
color lblue = #C8D2F5;

FBox lwall, rwall, lfloor, rfloor, ceiling, net;
FCircle lplayer, rplayer, ball;
FWorld world;

int lpoints = 0, rpoints = 0, mode = 0;
final int INTRO = 0, GAME = 1, END = 2;
boolean akey, wkey, skey, dkey, leftkey, upkey, downkey, rightkey, leftCanJump, rightCanJump;

void setup() {
  textAlign(CENTER, CENTER);
  font = createFont("ARCADECLASSIC.TTF", 10);
  bground = loadImage("background.png");
  bground.resize(displayWidth, displayHeight);
  introbground = loadImage("introScreen.jpg");
  introbground.resize(displayWidth, displayHeight);
  endbground = loadImage("endScreen.png");
  endbground.resize(displayWidth, displayHeight);
  beach = loadImage("sand.jpg");
  beach.resize(displayWidth/2, 100);
  kirby = loadImage("kirby.png");
  kirby.resize(100, 100);
  kirby2 = loadImage("rkirby.png");
  kirby2.resize(100, 100);
  vball = loadImage("ball.png");
  vball.resize(50, 50);
  textFont(font);
  textAlign(CENTER, CENTER);
  fullScreen(FX2D);
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 980);
  makeball();
  makeleftwall();
  makerightwall();
  makeceiling();
  makenet();
  makeleftfloor();
  makerightfloor();
  makeleftplayer();
  makerightplayer();
}

void draw() {
  background(bground);
  //(0);
  //bground(0, 0);
  if (mode == INTRO) {
    intro();
  } else if (mode == GAME) {
    play();
  } else if (mode == END) {
    gameover();
  }


  println(rpoints);
  handleKeyboard();
  world.step();
  world.draw();
}

void intro () {
  background(introbground);
  textSize(100);
  fill(255);
  text("CLICK TO PRESS START", width/2, height/2);
  rpoints = 0;
  lpoints = 0;
}

void play() {
  makepoints();
  leftCanJump = false;
  ArrayList<FContact> lcontacts = lplayer.getContacts();
  int i = 0;
  while (i < lcontacts.size()) {
    FContact c = lcontacts.get(i);
    if (c.contains(lfloor)) leftCanJump = true; 
    i++;
  }
  println(leftCanJump);

  //for each loop part of AP
  //can't add or remove from list though
  rightCanJump = false;
  ArrayList<FContact> rcontacts = rplayer.getContacts();
  for (FContact c : rcontacts) {
    if (c.contains(rfloor)) rightCanJump = true;
  }

  ArrayList<FContact> bcontacts = ball.getContacts();
  for (FContact c : bcontacts) {
    if (c.contains(rfloor)) {
      lpoints++;
      setup();
      ball.setPosition(width/6, 100);
    }
    if (c.contains(lfloor)) { 
      rpoints++;
      setup();
      ball.setPosition(width-width/6, 100);
    }
  }

  if (rplayer.getX() <= width/2 + 50) {
    //rplayer.setPosition(width/2 + 50, rplayer.getY());
    rplayer.setVelocity(-rplayer.getVelocityX(), rplayer.getVelocityY());
  }
  if (lplayer.getX() >= width/2 - 50) {
    //lplayer.setPosition(width/2 - 50, lplayer.getY());
    lplayer.setVelocity(-lplayer.getVelocityX(), lplayer.getVelocityY());
  }

  if (lpoints == 3 || rpoints == 3) {
    mode = END;
  }
}

void gameover() {
  background(endbground);
  textSize(100);

  if (lpoints == 3) {
    fill(pink);
    text("LEFT PLAYER WINS", width/2, height/2);
  } else {
    fill(green);
    text("RIGHT PLAYER WINS", width/2, height/2);
  }
  noStroke();
  fill(255);
}

void makepoints() {
  textSize(70);
  fill(0);
  text("" +lpoints, 150, 50);
  text("" +rpoints, width-150, 50);
}

void makeball() {
  ball = new FCircle(50);
  ball.attachImage(vball);
  ball.setPosition(width/6, 100);
  ball.setGrabbable(false);
  ball.setNoStroke();
  ball.setFill(255);
  ball.setDensity(0.1);
  ball.setFriction(0.5);
  ball.setRestitution(0.7);
  world.add(ball);
}

void makeleftwall() {
  lwall = new FBox(20, height*2);
  lwall.setPosition(-10, height/2);
  lwall.setStatic(true);
  lwall.setGrabbable(false);
  lwall.setFill(0);
  world.add(lwall);
}

void makerightwall() {
  rwall = new FBox(20, height*2);
  rwall.setPosition(width+10, height/2);
  rwall.setStatic(true);
  rwall.setGrabbable(false);
  rwall.setFill(0);
  world.add(rwall);
}

void makeceiling() {
  ceiling = new FBox(width*4, 20);
  ceiling.setPosition(-width/2, -20);
  ceiling.setStatic(true);
  ceiling.setGrabbable(false);
  ceiling.setFill(0);
  world.add(ceiling);
}

void makenet() {
  net = new FBox(15, 150);
  net.setPosition(width/2, height-175);
  net.setNoStroke();
  net.setStatic(true);
  net.setGrabbable(false);
  net.setFill(255);
  world.add(net);
}

void makeleftfloor() {
  lfloor = new FBox(width/2, 100);
  lfloor.attachImage(beach);
  lfloor.setPosition(width/4, height-50);
  lfloor.setNoStroke();
  lfloor.setStatic(true);
  lfloor.setGrabbable(false);
  lfloor.setFillColor(brown);
  world.add(lfloor);
}
void makerightfloor() {
  rfloor = new FBox(width/2, 100);
  rfloor.attachImage(beach);
  rfloor.setPosition(width- width/4, height-50);
  rfloor.setNoStroke();
  rfloor.setStatic(true);
  rfloor.setGrabbable(false);
  rfloor.setFillColor(brown);
  world.add(rfloor);
}

void makeleftplayer() {  
  lplayer = new FCircle(100);
  lplayer.attachImage(kirby);
  lplayer.setPosition(width/6, height-200);
  lplayer.setNoStroke();
  lplayer.setStatic(false);
  lplayer.setGrabbable(false);
  lplayer.setFillColor(purple);
  lplayer.setDensity(0.5);
  lplayer.setFriction(1);
  lplayer.setRestitution(0.1);
  world.add(lplayer);
}

void makerightplayer() {
  rplayer = new FCircle(100);
  rplayer.attachImage(kirby2);
  rplayer.setPosition(width-width/6, height-200);
  rplayer.setNoStroke();
  rplayer.setStatic(false);
  rplayer.setGrabbable(false);
  rplayer.setFillColor(pink);
  rplayer.setDensity(0.5);
  rplayer.setFriction(1);
  rplayer.setRestitution(0.1);
  world.add(rplayer);
}

void handleKeyboard() {
  if (wkey && leftCanJump) lplayer.addImpulse(0, -4000);
  if (akey) lplayer.addImpulse(-150, 0);
  if (dkey) lplayer.addImpulse(150, 0);
  if (skey && leftCanJump==false) lplayer.addImpulse(0, 4000);

  if (upkey && rightCanJump) rplayer.addImpulse(0, -4000);
  if (leftkey) rplayer.addImpulse(-150, 0);
  if (rightkey) rplayer.addImpulse(150, 0);
  if (downkey && rightCanJump==false) rplayer.addImpulse(0, 4000);
}

void keyPressed() {
  if (key == 'a' || key == 'A') akey = true;
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == UP) upkey = true;
  if (keyCode == DOWN) downkey = true;
  if (keyCode == RIGHT) rightkey = true;
}

void keyReleased() {
  if (key == 'a' || key == 'A') akey = false;
  if (key == 'w' || key == 'W') wkey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'd' || key == 'D') dkey = false;
  if (keyCode == LEFT) leftkey = false;
  if (keyCode == UP) upkey = false;
  if (keyCode == DOWN) downkey = false;
  if (keyCode == RIGHT) rightkey = false;
}

void mouseReleased() {
  if (mode == INTRO) {
    mode = GAME;
    setup();
  } else if (mode == END) {
    mode = INTRO;
  }
}

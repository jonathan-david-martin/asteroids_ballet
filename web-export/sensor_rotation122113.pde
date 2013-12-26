
import io.thp.psmove.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
int savedTime ;

int totalTime = 500;

int passedTime;

int countdownTime;
  //player = minim.loadFile("pop.wav", 2048);
 
int score = 0;
PSMove [] moves;

Ball ball1;
Ball ball2;
Ball ball3;
Ball ball4;
Ball ball5;
float tri_tipx;
float tri_tipy;

  float [] ax = {0.f}, ay = {0.f}, az = {0.f};
  float [] gx = {0.f}, gy = {0.f}, gz = {0.f};
  float [] mx = {0.f}, my = {0.f}, mz = {0.f};
float place_holder = 0;

class Ball {

  float r;   // radius
  float x,y; // location
  float xspeed,yspeed; // speed
  
  // Constructor
  Ball(float tempR) {
    r = tempR;
    x = random(-width/2,width/2);
    y = random(-height/2,height/2);
    xspeed = random( - 5,5);
    yspeed = random( - 5,5);
  }
  
  void move() {
    x += xspeed*4; // Increment x
    y += yspeed*4; // Increment y
    
    // Check horizontal edges
    //if (x > width || x < 0) {
     if (abs(x) > width/2) {
     
      xspeed *= - 1;
    }
    //Check vertical edges
    //if (y > height || y < 0) {
    if (abs(y) > width/2) {  
      yspeed *= - 1;
    }
  }
  
  // Draw the ball
  void display() {
    stroke(0);
    fill(random(255),random(255),random(255));
    ellipse(x,y,r*2,r*2);
  }
}


void setup() {
  size(1080,700);
  
  
  
  
  
  //minim = new Minim(this);
  //player = minim.loadFile("pop1.mp3", 2048);
  moves = new PSMove[psmoveapi.count_connected()];
  for (int i=0; i<moves.length; i++) {
    moves[i] = new PSMove(i);
  }
  
  ball1 = new Ball(64);
  ball2 = new Ball(32);
  
    ball3 = new Ball(40);
  ball4 = new Ball(100);
    ball5 = new Ball(18);
  
}


void handle(int i, PSMove move)
{


  while (move.poll() != 0) {}
   
  move.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
  move.get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
  move.get_magnetometer_vector(mx, my, mz);
  
 
}

void draw() {
  countdownTime = (20000 - millis())/1000;
  
  if (countdownTime < 0)
  {
   textSize(height/12);
    textAlign(CENTER);
    fill(0);
    if (score > 19 ){
    text("YOU WIN",width/2,height/2);
    }
    else
    {
    text("GAME OVER. TRY AGAIN?",width/2,height/2);
    //game over
    }
  }
  
  else {
  background(255);
  stroke(0);
  
  
  
  //fill(175);
  handle(0, moves[0]);
  // Translate origin to center
  translate(width/2,height/2);
  

  moves[0].get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
  moves[0].get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
  moves[0].get_magnetometer_vector(mx, my, mz);
  
    
    float theta = PI*gx[0]*10 / width;
    place_holder = place_holder + theta;
    //float theta = PI*mouseX/ width;
    
    
  
  
  textSize(40);
  text("Time Left:",-470,-250);   
  text(countdownTime,-250,-250);
     textSize(40);
  text("Score:",-470,-300);   
  text(score,-350,-300);
  
  
   //text(gx[0],100,0);
    //rotate(gx[0]*500);
  ball1.move();
  ball2.move();
  ball1.display();
  ball2.display();
  
  
   ball3.move();
  ball3.display();
   ball4.move();
  ball4.display();
   ball5.move();
  ball5.display();
  
  //moves[0].set_rumble(200);
  //moves[0].update_leds();
  //moves[0].set_rumble(0);
  //moves[0].update_leds();
  //savedTime = millis();
  
  
  
    //textSize(20);
  //text(ball1.x, 0,0);
  
  
  if (abs(ball1.x - tri_tipx) < 50 & abs(ball1.y - tri_tipy) < 50) {
  //textSize(50);
  //text("collision detected", 0,0);

  //player.play();
  
  ball1.r = 0;
  ball1 = new Ball(64);
  score=score+1;
  moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
  moves[0].set_rumble(100);
  moves[0].update_leds();
  savedTime = millis();
  int passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    moves[0].set_rumble(0);
    println( " 5 seconds have passed! " );
    background(random(255)); // Color a new background
    savedTime = millis(); // Save the current time to restart the timer!
    moves[0].update_leds();
  }
  
  
  }
  
  
  if (abs(ball2.x - tri_tipx) < 50 & abs(ball2.y - tri_tipy) < 50) {
  

  //player.play();
  
  ball2.r = 0;
  ball2 = new Ball(70);
  score=score+1;
 moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
  moves[0].set_rumble(100);
  moves[0].update_leds();
  savedTime = millis();
  int passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    moves[0].set_rumble(0);
    println( " 5 seconds have passed! " );
    background(random(255)); // Color a new background
    savedTime = millis(); // Save the current time to restart the timer!
    moves[0].update_leds();
  }
  }
  
  if (abs(ball3.x - tri_tipx) < 50 & abs(ball3.y - tri_tipy) < 50) {


  //player.play();
  
  ball3.r = 0;
  ball3 = new Ball(100);
  score=score+1;
    moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
  moves[0].set_rumble(100);
  moves[0].update_leds();
  savedTime = millis();
  int passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    moves[0].set_rumble(0);
    println( " 5 seconds have passed! " );
    background(random(255)); // Color a new background
    savedTime = millis(); // Save the current time to restart the timer!
    moves[0].update_leds();
  }
  }
  
  
  if (abs(ball4.x - tri_tipx) < 50 & abs(ball4.y - tri_tipy) < 50) {
  

  //player.play();
  
  ball4.r = 0;
  ball4 = new Ball(18);
  score=score+1;
    moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
  moves[0].set_rumble(100);
  moves[0].update_leds();
  savedTime = millis();
  int passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    moves[0].set_rumble(0);
    println( " 5 seconds have passed! " );
    background(random(255)); // Color a new background
    savedTime = millis(); // Save the current time to restart the timer!
    moves[0].update_leds();
  }
  }
  
  
  if (abs(ball5.x - tri_tipx) < 50 & abs(ball5.y - tri_tipy) < 50) {
  

  //player.play();
  
  ball5.r = 0;
  ball5 = new Ball(40);
  score=score+1;
    moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
  moves[0].set_rumble(100);
  moves[0].update_leds();
  savedTime = millis();
  int passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    moves[0].set_rumble(0);
    println( " 5 seconds have passed! " );
    background(random(255)); // Color a new background
    savedTime = millis(); // Save the current time to restart the timer!
    moves[0].update_leds();
  }
  }
  
  
  
    
     tri_tipx = 150*cos(place_holder+3.1415/2);
  
  tri_tipy = 150*sin(place_holder+3.1415/2);
  //rectMode(CENTER);
  //rect(tri_tipx,tri_tipy,30,30);
    
    
    
    rotate(place_holder);
  
  
  
  //rotate(theta);
  
 
  //rect(0,0,10,100);
  fill(0);
  triangle(-10,0,0,150,10,0);
  
  }
   
};


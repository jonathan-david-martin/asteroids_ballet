//Asteroids Ballet v1.0
//by Jon Martin
//12-26-13
//This is my first project using the psmove.api and Processing
//Using the motion controller to move the ship takes a little getting used to but is workable
//flick the controller up to move up, down = down, right = right, left = left
//twist the controller to rotate the ship
//it helps flick the controller, keep it pointed in the direction you want to go, and twist to point in the correct direction 
//all in the same motion
//
//Trigger fires a shot
//
//In this version you can destroy an asteroid by touching it with the tip of your ship
//The tolerance for destroying an asteroid with the tip of the ship, or by shooting is +/- 50 to the center of the asteroid
//In next version, this will work when contacting the perimeter instead of the center
//
//link to the psmove api created by Thomas Perl -- thank you!
//http://thp.io/2010/psmove/
//https://github.com/thp/psmoveapi

import io.thp.psmove.*;
import ddf.minim.*;
float theta;
float thrust_x = 0;
float thrust_y = 0;
int tri_height = 40;
AudioPlayer player;
AudioPlayer soundtrPlayer;
Minim minim;//audio context
Minim soundtrMinim;
int savedTime;
int trigger = 0;
int elapsedTime;
int totalTime = 500;
int passedTime;
int playTime = 90000;
boolean ball6created = false;
int countdownTime;
int score = 0;
PSMove [] moves;

Ball ball1;
Ball ball2;
Ball ball3;
Ball ball4;
Ball ball5;
Ball ball6;
//Spaceship spaceship1;  next version will use an object instead of a triangle for the spaceship

boolean shipDestroyed = false;

float thrust;
float tri_tipx;
float tri_tipy;
float [] ax = {0.f}, ay = {0.f}, az = {0.f};
float [] gx = {0.f}, gy = {0.f}, gz = {0.f};
float [] mx = {0.f}, my = {0.f}, mz = {0.f};
float place_holder = 0;

//gx - x axis is forward or towards you
//gz - z axis is swinging your arm left to right
//gy - y axis seems to respond to twisting the controler

boolean sketchFullScreen() {
 return true;
}

void keyPressed() {
  //some bugs that need to be worked out: after restarting a few times, the controller loses its connection
  //also the text is reset further left
  shipDestroyed = false;
  playTime = elapsedTime + 90000;
  score = 0;
  theta = 0;
  countdownTime = (playTime - elapsedTime)/1000;
  thrust_x = 0;
  thrust_y = 0;
  tri_tipx = 0;
  tri_tipy = 0;
  place_holder = 0;
  moves = null;
  ball1 = null;
  ball2 = null;
  ball3 = null;
  ball4 = null;
  ball5 = null;
  ball6 = null;
  setup();
}

class Spaceship {
  
float x,y; // location
float xspeed,yspeed; // speed

Spaceship() {   
    x = 0;
    y = 0;
    xspeed = .2;
    yspeed = .2;
}

void move() {
    x += xspeed; // Increment x
    y += yspeed; // Increment y
    
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
  
  void display() {
    stroke(0);   
    fill(255,random(100,255),random(100,255));
    triangle(x-10,y,x,y+40,x+10,y);   
  }
}


class Ball {
//the code for the ball came from learningprocessing.com I think
  float r;   // radius
  float x,y; // location
  float xspeed,yspeed; // speed 
  // Constructor
  Ball(float tempR) {
    r = tempR;
    x = random(-width/2,width/2);
    y = random(-height/2,height/2);
    xspeed = random( - 4,4);
    yspeed = random( - 4,4);
  }
  
  void move() {
    x += xspeed; // Increment x
    y += yspeed; // Increment y
    
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

void playloop() {
  
  while (shipDestroyed == false){
    
    if  (  (millis()) % 2000 == 0) {
    soundtrMinim = new Minim(this);
    soundtrPlayer = soundtrMinim.loadFile("asteroids_tonelo.wav", 1042);
    soundtrPlayer.play(); 
    }
    
  }
}


void setup() {
  size(1280,800);
  PFont visitorFont;
  visitorFont = loadFont("VisitorTT1BRK-48.vlw");
  textFont(visitorFont);
  minim = new Minim(this);
  player = minim.loadFile("Blast.mp3", 2048);
  soundtrMinim = new Minim(this);
  soundtrPlayer = soundtrMinim.loadFile("asteroids_tonelo.wav", 1042);
  
  moves = new PSMove[psmoveapi.count_connected()];
    for (int i=0; i<moves.length; i++) {
      moves[i] = new PSMove(i);
    }
  
  ball1 = new Ball(64);
  ball2 = new Ball(32);
  ball3 = new Ball(40);
  ball4 = new Ball(100);
  ball5 = new Ball(18);
  //spaceship1 = new Spaceship();
  
}


void handle(int i, PSMove move)
{
  while (move.poll() != 0) {}
   
  move.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
  move.get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
  move.get_magnetometer_vector(mx, my, mz);
  
  trigger = move.get_trigger();
  
  if (trigger == 255){
    
    player = minim.loadFile("LASER.mp3", 2048);
    player.play();
    ball6created = true;
    ball6 = new Ball(5);
    ball6.x = thrust_x+tri_height*cos(place_holder+3.1415/2);
    ball6.y = thrust_y+tri_height*sin(place_holder+3.1415/2);
    ball6.xspeed = tri_tipx/15;
    ball6.yspeed = tri_tipy/15;
    
  }
}

void draw() {
  elapsedTime = millis();
  countdownTime = (playTime - elapsedTime)/1000;
 
  if (shipDestroyed == false){  
      
      if (countdownTime < 0)
      {
        
       textSize(height/12);
        textAlign(CENTER);
        fill(random(255),random(255),random(255));
        if (score > 29 ){
        text("YOU WIN",width/2,height/2);
        
        }
        else
        {
          
        text("GAME OVER. PRESS ANY KEY TO TRY AGAIN.",width/2,height/2);

        }         
      }
      
      else {
        
        background(0);
        stroke(0);
        // Translate origin to center
        translate(width/2,height/2);
        handle(0, moves[0]);
        theta = gy[0]*.05;
        thrust = ay[0]*.01;
        thrust_y = thrust_y + -ay[0]*0.9;
        thrust_x = thrust_x + -ax[0]*0.9;
        place_holder = place_holder + theta;

        textSize(40);
        text("Time Left:",-570,-250);   
        text(countdownTime,-350,-250);
        
        if  (  elapsedTime % 2000 < 20) {
          soundtrMinim = new Minim(this);
          soundtrPlayer = soundtrMinim.loadFile("asteroids_tonelo.wav", 1042);
          soundtrPlayer.play(); 
        }
        
        textSize(40);
        text("Score:",-570,-300);   
        text(score,-410,-300);
        
        textSize(20);
        text("Get 30 points to win",-570,-350); 
        
        //Text to monitor sensors
        //textSize(40);
        //text("gy[0]:",-470,-200);   
        //text(gy[0],-350,-200);
       
        //text("placeholder:",-470,-100);   
        //text(place_holder,-220,-100);
        
        //text("ax[0]:",-470,0);   
        //text(ax[0],-220,0);
        
        //text("thrust_x:",-470,100);   
        //text(thrust_x,-220,100);
        
        //text("az[0]:",-470,200);   
        //text(az[0],-220,200);
              
        //text("thrust_y:",-470,300);   
        //text(thrust_y,-220,300);
                 
        if (ball6 != null){
          ball6.display();
          ball6.move();
        }
        
        ball1.move();
        ball1.display();
        ball2.move();
        ball2.display();
        ball3.move();
        ball3.display();
        ball4.move();
        ball4.display();
        ball5.move();
        ball5.display();
        
        if (abs(ball1.x - thrust_x) < 50 & abs(ball1.y - thrust_y) < 50 ) {
          shipDestroyed = true;
        }
        if (abs(ball2.x - thrust_x) < 50 & abs(ball2.y - thrust_y) < 50 ) {
          shipDestroyed = true;
        }
        if (abs(ball3.x - thrust_x) < 50 & abs(ball3.y - thrust_y) < 50 ) {
          shipDestroyed = true;
        }
        if (abs(ball4.x - thrust_x) < 50 & abs(ball4.y - thrust_y) < 50 ) {
          shipDestroyed = true;
        }
        if (abs(ball5.x - thrust_x) < 50 & abs(ball5.y - thrust_y) < 50 ) {
          shipDestroyed = true;
        }
        
        //in next version, these will be done with a function passing a ball object
        if ( ball6 != null){
          if( abs(ball1.x - ball6.x) < 50 & abs(ball1.y - ball6.y) < 50 ) {
            player = minim.loadFile("Blast.mp3", 2048);
            player.play();
            ball1.r = 0;
            ball1 = new Ball(64);
            score=score+1;
          }
        }
        
       if ( ball6 != null){
          if( abs(ball2.x - ball6.x) < 50 & abs(ball2.y - ball6.y) < 50 ) {
            player = minim.loadFile("Blast.mp3", 2048);
            player.play();
            ball2.r = 0;
            ball2 = new Ball(70);
            score=score+1;
          }
        }
        
        if ( ball6 != null){
          if( abs(ball3.x - ball6.x) < 50 & abs(ball3.y - ball6.y) < 50 ) {
            player = minim.loadFile("Blast.mp3", 2048);
            player.play();
            ball3.r = 0;
            ball3 = new Ball(100);
            score=score+1;
          }
        }
        
        if ( ball6 != null){
          if( abs(ball6.x - ball4.x) < 50 & abs(ball6.y - ball4.y) < 50 ) {
            player = minim.loadFile("Blast.mp3", 2048);
            player.play();
            ball4.r = 0;
            ball4 = new Ball(18);
            score=score+1;
          }
        }
        
        if ( ball6 != null){
          if( abs(ball5.x - ball6.x) < 50 & abs(ball5.y - ball6.y) < 50 ) {
          player = minim.loadFile("Blast.mp3", 2048);
          player.play();
          ball5.r = 0;
          ball5 = new Ball(40);
          score=score+1;
          }
        }
       
        //in next version these will be function calls 
        //turns on rumble when asteroid hits tip of spaceship.  the first version of this game was just popping balloons with a triangle.
        //next version will only activate rumble when asteroid is shot      
        if (abs(ball1.x - tri_tipx) < 50 & abs(ball1.y - tri_tipy) < 50) {
  
            player = minim.loadFile("Blast.mp3", 2048);
            player.play(2000); 
            ball1.r = 0;
            ball1 = new Ball(64);
            score=score+1;
            moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
            moves[0].set_rumble(100);
            moves[0].update_leds();
            savedTime = millis();
            int passedTime = millis() - savedTime;
            // this is trying to limit the rumble time to a half second--needs to be reworked
              if (passedTime > totalTime) {
                moves[0].set_rumble(0);
                background(random(255)); // Color a new background
                savedTime = millis(); // Save the current time to restart the timer!
                moves[0].update_leds();
              }
        }
        
        
        if (abs(ball2.x - tri_tipx) < 50 & abs(ball2.y - tri_tipy) < 50) {
        
            player = minim.loadFile("Blast.mp3", 2048);
            player.play(2000);       
            ball2.r = 0;
            ball2 = new Ball(70);
            score=score+1;
            moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
            moves[0].set_rumble(100);
            moves[0].update_leds();
            savedTime = millis();
            int passedTime = millis() - savedTime;
            
              if (passedTime > totalTime) {
                moves[0].set_rumble(0);
                println( " 5 seconds have passed! " );
                background(random(255)); // Color a new background
                savedTime = millis(); // Save the current time to restart the timer!
                moves[0].update_leds();
              }
        }
        
        if (abs(ball3.x - tri_tipx) < 50 & abs(ball3.y - tri_tipy) < 50) {
      
            player = minim.loadFile("Blast.mp3", 2048);
            player.play(2000);
            ball3.r = 0;
            ball3 = new Ball(100);
            score=score+1;
            moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
            moves[0].set_rumble(100);
            moves[0].update_leds();
            savedTime = millis();
            int passedTime = millis() - savedTime;

              if (passedTime > totalTime) {
                moves[0].set_rumble(0);
                background(random(255)); // Color a new background
                savedTime = millis(); // Save the current time to restart the timer!
                moves[0].update_leds();
              }
        }
        
        
        if (abs(ball4.x - tri_tipx) < 50 & abs(ball4.y - tri_tipy) < 50) {
            
            player = minim.loadFile("Blast.mp3", 2048);
            player.play(2000);  
            ball4.r = 0;
            ball4 = new Ball(18);
            score=score+1;
            moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
            moves[0].set_rumble(100);
            moves[0].update_leds();
            savedTime = millis();
            int passedTime = millis() - savedTime;

              if (passedTime > totalTime) {
                moves[0].set_rumble(0);
                background(random(255)); // Color a new background
                savedTime = millis(); // Save the current time to restart the timer!
                moves[0].update_leds();
              }
        }
        
        
        if (abs(ball5.x - tri_tipx) < 50 & abs(ball5.y - tri_tipy) < 50) {
            
            player = minim.loadFile("Blast.mp3", 2048);     
            player.play(2000);      
            ball5.r = 0;
            ball5 = new Ball(40);
            score=score+1;
            moves[0].set_leds(int(random(255)),int(random(255)),int(random(255)));
            moves[0].set_rumble(100);
            moves[0].update_leds();
            savedTime = millis();
            int passedTime = millis() - savedTime;
            
              if (passedTime > totalTime) {
                moves[0].set_rumble(0);
                background(random(255)); // Color a new background
                savedTime = millis(); // Save the current time to restart the timer!
                moves[0].update_leds();
              }
        }
        
      //the coordinates of the tip of the triangle
      tri_tipx = tri_height*cos(place_holder+3.1415/2);
      tri_tipy = tri_height*sin(place_holder+3.1415/2);
      
      //sets the origin to the center of the ship
      translate(thrust_x,thrust_y);
      rotate(place_holder);
        
      fill(255,random(100,255),random(100,255));
      triangle(-10,0,0,tri_height,10,0);
        
      //spaceship1.display();
      //spaceship1.move();
      //spaceship1.xspeed = thrust_x;
      //spaceship1.xspeed = thrust_y;
        
      }
  }
  else //if ship is destroyed
  {
      textSize(height/12);
      textAlign(CENTER);
      fill(random(255),random(255),random(255));
      text("GAME OVER. PRESS ANY KEY TO TRY AGAIN.",width/2,height/2);
  }
    
};

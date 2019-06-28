class bigBall{
  PVector Position;
  PVector Velocity;
  float Radius;
  color colour;
  PVector DeltaTarget;
  PVector Target;

/**
 * the constructor for the bigball class, basically it just initializes everything 
 * 
 * @param float radius - the radius of the ball
 * @param color col - the color of the ball
 * @param int i - determince the location of the ball
 * @return 
 */
  bigBall(float radius, color col, int i){
    Position = new PVector(width/7*(1+i), -5000);
    Velocity = new PVector(0,1);
    Radius = radius;
    Target = new PVector(width/7*(1+i), height/2);
    colour = col;   
  }
  
/**
 * updates the bigball, checks if the the target is supposed to be active and if so moves it to the target.
 * 
 * @param
 * @return 
 */
 void Update(){
  if (users>=secondUserPoint){
    moveToTarget();
    Position.add(Velocity);     
  }
  else{
    Position.set(Position.x, -100); 
    Velocity.set(0,0);
  }
   
 }
 
/**
 * draws the bigball 
 * 
 * @param
 * @return 
 */
 void Draw(){
   if (users>=secondUserPoint){
     noStroke();
     fill(colour);
     ellipse(Position.x,Position.y,Radius,Radius); 
   }
 }

 
/**
 * recalculates the new velocity
 * 
 * @param
 * @return 
 */
 void moveToTarget(){
   this.DeltaTarget = new PVector(this.Target.x - this.Position.x, this.Target.y- this.Position.y);
     if(DeltaTarget.y > 0){
         Velocity.set(Velocity.x , DeltaTarget.y/height*moveSpeedBig);       
     }
     else if(DeltaTarget.y < 0){
         Velocity.set(Velocity.x , DeltaTarget.y/height*moveSpeedBig);       
     }
    if(Velocity.y > 30){
      Velocity.set(Velocity.x , 30);
    }
  } 
}

class Ball {
  PVector Position;
  PVector Velocity;
  float Radius;
  color colour;

  PVector Target;
  PVector DeltaTarget;
  int targetNumber;

  int ballID;
  int userTarget;
  int oldUserTotal;

  boolean arrived;
  boolean randomized;  

  int updateNumberBall;
  boolean stay;
/**
 * the constructor for the ball class. initializes everything and gives it a random location and velocity.
 * 
 * @param float radius - sets the radius of the ball 
 * @param int id - gives the ball an id by witch we can recognize it later
 * @return 
 */
  Ball(float radius, int id) {
    this.ballID = id;
    Position = new PVector(random(width), random(height));
    Velocity = new PVector(random(-defaultSpeed, defaultSpeed), random(-defaultSpeed, defaultSpeed));
    Radius = radius;
    Target = null;
    userTarget = -1;
    oldUserTotal = 0;
    updateNumberBall = int(random(0,2));

    //float[] temp = {random(0,255),random(0,255),random(0,255)};
    //colour = color(int(temp[0]),int(temp[1]),int(temp[2]));

    switch(int(random(0,1))){//now will only give case 0
    case 0:
      stay = false;
      break;
    case 1:
      stay = true;
      break;
    default:
      stay = true;
    }

    switch(int(random(0, 6))) {
    case 0:
      colour = people;
      break;
    case 1:
      colour = security;
      break;
    case 2:
      colour = environment;
      break;
    case 3:
      colour = urbanLifestyle;
      break;
    case 4:
      colour = entertainment;
      break;
    case 5:
      colour = health;
      break;
    default:
      colour = standart;
    }

    randomized = true;
    arrived = true;
  }

/**
 * updates the ball by: looking if the targeted user is still falid. changes the velocity to move the target if there is a target.
 * moves to new location, checks if the ball is outside of the screen and if so bounces it back in.
 * 
 * @param
 * @return 
 */
  void Update() {
    setUser();
    movement();
    Position.add(Velocity);
    ResolveBoundary();
    updateNumberBall++;
    if(updateNumberBall > 2){
      updateNumberBall = 0;
    }
  }
/**
 * draws the ball.
 * 
 * @param
 * @return 
 */
  void Draw() {
    noStroke();
    fill(colour);
    ellipse(Position.x, Position.y, Radius, Radius);
  }

/**
 * checks if the ball is outside the screen, and if reflects it back inside.
 * 
 * @param
 * @return 
 */
  void ResolveBoundary() {
    if (Position.x + Radius > width) {
      Position.x = width - Radius;
      if (Velocity.x > 0)
        Velocity.x *= -1;
    } else if (Position.x - Radius < 0) {
      Position.x = Radius;
      if (Velocity.x < 0)
        Velocity.x *= -1;
    }

    if (Position.y + Radius > height) {
      Position.y = height - Radius;
      if (Velocity.y > 0)
        Velocity.y *= -1;
    } else if (Position.y - Radius < 0) {
      Position.y = Radius;
      if (Velocity.y < 0)
        Velocity.y *= -1;
    }
  }
 
/**
 * checks if a ball is overlapping with an other ball, and if so they bounce of eachother.
 * 
 * @param Ball other - the other ball that it is checks if they are overlapping
 * @return 
 */
  void HandleBallCollission(Ball other) {

    PVector deltaPosition = PVector.sub(this.Position, other.Position);
    float deltaLength = deltaPosition.mag();

    if (deltaLength > this.Radius)
      return;

    PVector translationVector = PVector.mult(deltaPosition, ((this.Radius + other.Radius) - deltaLength) / deltaLength);

    float thisMass = 1/this.Radius;
    float otherMass = 1/other.Radius;

    PVector normalizedTranslationVector = translationVector;
    normalizedTranslationVector.normalize();   

    PVector impactSpeed = PVector.sub(this.Velocity, other.Velocity);
    float velocityNormal = impactSpeed.dot(normalizedTranslationVector);

    if (velocityNormal > 0)
      return;

    float i = (-(1.0f + 1) * velocityNormal) / (thisMass + otherMass);
    PVector impulse = PVector.mult(normalizedTranslationVector, i);

    this.Velocity.add(PVector.mult(impulse, thisMass));
    other.Velocity.sub(PVector.mult(impulse, otherMass));
  }

/**
 * changes the velocity of the ball depending if it has a target, is already inside the target or is just floating around.
 * 
 * @param
 * @return 
 */
  void movement() {
    updateTarget();
    if (arrived == false) {
      moveToTarget();
    } else if(randomized == false){
      MoveInsideTarget();
    } else {
      randomizedMovement();
    }
  }

/**
 * directly moves the ball to the target location.
 * 
 * @param
 * @return 
 */
  void moveToTarget() {
    if (Target == null) {
      return ;
    }
    this.DeltaTarget = new PVector(this.Target.x - this.Position.x, this.Target.y- this.Position.y);
    if (DeltaTarget.x > 0) {
      Velocity.set(DeltaTarget.x/width*moveSpeed, Velocity.y);
    } else if (DeltaTarget.x < 0) {
      Velocity.set(DeltaTarget.x/width*moveSpeed, Velocity.y);
    }  
    if (DeltaTarget.y > 0) {
      Velocity.set(Velocity.x, DeltaTarget.y/height*moveSpeed);
    } else if (DeltaTarget.y < 0) {
      Velocity.set(Velocity.x, DeltaTarget.y/height*moveSpeed);
    }
    if (DeltaTarget.mag() < 10) {
      this.arrived = true;
    }
  }

/**
 * makes it that the ball moves around in the target.
 * 
 * @param
 * @return 
 */
  void MoveInsideTarget() {
    updateTarget();
    if (Target == null) {
      return ;
    }
    this.DeltaTarget = new PVector(this.Target.x - this.Position.x, this.Target.y- this.Position.y);

    if (DeltaTarget.x > 0) {
      Velocity.set(Velocity.x + random(-0.1, 0.2), Velocity.y);
    } else if (DeltaTarget.x < 0) {
      Velocity.set(Velocity.x + random(-0.2, 0.1), Velocity.y);
    }  
    if (DeltaTarget.y > 0) {
      Velocity.set(Velocity.x, Velocity.y + random(-0.1, 0.2));
    } else if (DeltaTarget.y < 0) {
      Velocity.set(Velocity.x, Velocity.y + random(-0.2, 0.1));
    }
    if (Velocity.x > defaultSpeed) {
      Velocity.set(defaultSpeed, Velocity.y);
    } else if (Velocity.x < -1*defaultSpeed) {
      Velocity.set(-1*defaultSpeed, Velocity.y);
    }
    if (Velocity.y > defaultSpeed) {
      Velocity.set(Velocity.x, defaultSpeed);
    } else if (Velocity.y < -1*defaultSpeed) {
      Velocity.set(Velocity.x, -1*defaultSpeed);
    }
  }
  
/**
 * gives the ball small changes to the velocity so that it doesnt move in straight lines 
 * 
 * @param
 * @return 
 */
  void randomizedMovement(){
    if(updateNumberBall == 0){
    Velocity.set(Velocity.x+ random(-0.1, 0.1), Velocity.y + random(-0.1, 0.1));
      if (Velocity.x > defaultSpeed) {
        Velocity.set(defaultSpeed, Velocity.y);
      } else if (Velocity.x < -1*defaultSpeed) {
        Velocity.set(-1*defaultSpeed, Velocity.y);
      }
      if (Velocity.y > defaultSpeed) {
        Velocity.set(Velocity.x, defaultSpeed);
      } else if (Velocity.y < -1*defaultSpeed) {
        Velocity.set(Velocity.x, -1*defaultSpeed);
      }
    }
  }

/**
 * updates the target of the ball by checking by checking if: the ball has arrived, 
 * if there are users present, if it has a user set as target, if target is still legit and if it is exploding.
 *
 * and if any of those are a no it resets the ball by giving it a random velocity.
 * 
 * @param
 * @return 
 */
  void updateTarget() {

    if (updateNumberBall == 0) {
      if (arrived) {
        if (users>0) {
          if (userTarget != -1) {
            if (checkTarget()) {
              if(!exploding){
                this.Target = getTarget();
                this.randomized = false;
                this.arrived = false;
              }
            }
          }
        } else if (randomized == false) {
          this.Target = null;
          this.Velocity = new PVector(random(-defaultSpeed, defaultSpeed), random(-defaultSpeed, defaultSpeed));
          this.randomized = true;
          this.arrived = true;
        }
      }
    }
  }

/**
 * was supposed to give a new target inside the same user without going out of bounds of that user. But that still on the to do...
 * 
 * @param
 * @return 
 */
  void updateTargetInside(){
    int[][] temp = persons[userTarget].getFilter();
  }
  
/**
 * checks if the userTarget still has the targetNumber in the falidLocation list.
 * 
 * @param
 * @return 
 */
  boolean checkTarget(){
    if(userTarget != -1){
      if(persons[userTarget].falidLocations != null){
        if(persons[userTarget].falidLocations.contains(targetNumber) ){
          if(Target != null){
            return false;
          }
        }
      }
    }
    return true;
  }

  // use this if you want to test stuff
  //  boolean checkTarget() {
  //  if (userTarget != -1) {
  //    if (test != null) {
  //      if (test.contains(targetNumber) ) {
  //        if (Target != null) {
  //          return false;
  //        }
  //      }
  //    }
  //  }
  //  return true;
  //}

/**
 * gets a target from the falidLocaions form the userTarget.
 * 
 * @param
 * @return 
 */
  PVector getTarget() {

    float targetListChoice = random(0,persons[userTarget].falidLocations.size());
    try{
      if(persons[userTarget].falidLocations.size() > 0){
        this.targetNumber = persons[userTarget].falidLocations.get(int(targetListChoice));
      }
    }
    catch(Exception E){
      println(E);
    }
    //float targetListChoice = random(0, test.size()); 
    //this.targetNumber = test.get(int(targetListChoice));

    float tempX = targetNumber % width;
    float tempY = targetNumber / width;

    if (tempX < int(Radius)) {
      tempX = int(Radius);
    } else if (tempX-width+int(Radius)>0) {
      tempX = width-int(Radius);
    }
    if (tempY < 0+int(Radius)) {
      tempY = int(Radius);
    } else if (tempY-height+int(Radius)>0) {
      tempY = height-int(Radius);
    }

    PVector temp = new PVector(tempX, tempY);
    return temp;
  }

/**
 * so does nothing right now, so you can ingore it. But it was suposed to give a new target inside the the userTarget
 * if there was some movement
 *
 * @param
 * @return 
 */  
  PVector getTargetInside(){
    if(persons[userTarget].getChangeValue()>1000){
      if(updateNumberBall == 1){
        float targetListChoice = random(0,persons[userTarget].getChange().length); 
        this.targetNumber = persons[userTarget].getFalidLocations().get(int(targetListChoice));

        float tempX = targetNumber % width;
        float tempY = targetNumber / width;
    
        PVector tempVector = new PVector(tempX - this.Position.x, tempY - this.Position.y);
      }
    }
    
    int[][] temp = persons[userTarget].getFilter();
    
    float targetListChoice = random(0,persons[userTarget].getFalidLocations().size()); 
    this.targetNumber = persons[userTarget].getFalidLocations().get(int(targetListChoice));

    float tempX = targetNumber % width;
    float tempY = targetNumber / width;
    
    PVector tempVector = new PVector(tempX - this.Position.x, tempY - this.Position.y);
    if(tempVector.x>tempVector.y||tempVector.x<tempVector.y){
      
    } else{
      
    }
    
    return null;
  }

/**
 * checks if there was a change since the last user update for this ball
 * 
 * @param
 * @return 
 */
  boolean checkUser() {
    if (this.oldUserTotal == users) {
      return false;
    } else {
      this.oldUserTotal = users;
      return true;
    }
  }

/**
 * set a new userTarget for the ball
 * 
 * @param
 * @return 
 */
  void setUser() {
    if (checkUser()) {
      if(userTarget != -1){
        leave(userTarget);
      }
      userTarget = int(random(0, users));
    }
    if (users == 0) {
      if(userTarget != -1){
        leave(userTarget);
      }
      userTarget = -1;
      //userTarget = 0;
      //println(":("+userTarget);
    }
  }
  
/**
 * set a specific user as the new userTarget for hte ball. 
 * 
 * @param int user - the new userTarget
 * @return 
 */  
  void setUser(int user){
    leave(userTarget);
    this.userTarget = user;
    joinUser(userTarget);
  }

/**
 * sets the color to a specific color
 * 
 * @param color clr - the new color
 * @return 
 */
  void setColor(color clr) {
    this.colour = clr;
  }
  
/**
 * sets the velocity of the ball to a new velocity
 * 
 * @param PVector vel - the new velocity.
 * @return 
 */  
  void setVelocity(PVector vel){
    this.Velocity = vel; 
  }
  
/**
 * if boolean stay is false it is supposed to move to the last user (doens't always work), and update the new target
 * 
 * @param
 * @return 
 */
  void exploding(){
    if(!stay){
      setUser(users-1);
      this.Target = getTarget();
      this.arrived = false;
    }
  }

/**
 * If during the explosion a ball gets oustide of the screen, the velocity is set to 0
 * 
 * @param
 * @return 
 */  
  void outsideExplosion(){
    if((this.Position.x > width +100 || this.Position.x < -100)){
      this.Velocity.set(0,0);
    }
  }

/**
 * gives a new random velocity thats way higher than the normal random velocity
 * 
 * @param
 * @return 
 */
  void randomizeVelocity(){
    this.Velocity = new PVector(random(-explodingValue, explodingValue), random(-explodingValue, explodingValue));
    this.arrived = true;
    this.randomized = true;
  }
  
/**
 * joins a new person. 
 * 
 * @param int user - the new person to join
 * @return 
 */
  void joinUser(int user){
    if(users >0){
      persons[user].addBallArrayLocation(ballID);
    }
  }
  
/**
 * lets the user leave the person. but does nothing right now
 * 
 * @param
 * @return 
 */  
  void leave(int user){
    if(users > 0){
      //persons[user].removeBallArrayLocation(ballID);
    }
  }
  
/**
 * sets the target to the given target
 * 
 * @param PVector tar - the new target
 * @return 
 */  
  void setTarget(PVector tar){
    this.Target = tar;
  }
  
/**
 * sets arrived depending on the given boolean
 * 
 * @param boolean arri - the boolean arrived is set to
 * @return 
 */  
  void setArrived(boolean arri){
    this.arrived = arri;
  }
  
  
  
  
}

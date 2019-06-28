import java.util.ArrayList;
/**
 * The basic setup part where most things are initiated.
 * 
 * @param
 * @return 
 */
void setup(){
 //size(1280,600); 
 fullScreen();
 frameRate(60);

 
 balls = new Ball[ballNumber];
 freeBalls = new int[ballNumber];
 
 bigBalls = new bigBall[6];
 persons = new person[maxUsers];
 closeUsers = new int[maxUsers];
 dbCon = new dataBase();
 //dbCon.update();
 
 updateNumber = 0;
 count = 490;
 explosionCounter = 0;
 users = 0;          //setBack to 0
 oldUsers = 0;
 flashyStuff = 0;
 tempTarget = null;
 textLocation = new int[] {width/3,height/10};
 textVariable=0;
 
 exploding = false;
 explosionRearm = true;
 

 for(int i = 0;i<closeUsers.length;i++){
   closeUsers[i] = 0;
 }

 for(int i = 0;i < balls.length;i++){
   //balls[i] = new Ball(random(5,10));
   balls[i] = new Ball(10,i);
 }
 for(int i = 0; i< freeBalls.length;i++){
   freeBalls[i] = i;
 }
 ballPointer = ballNumber-1;
 
 for(int i = 0;i < bigBalls.length;i++){
   //balls[i] = new Ball(random(5,10));
   bigBalls[i] = new bigBall(width/9, template[i],i);
 }
 
 kinectSetup(minD,maxD);
 depthStuff();
}

/**
 * So this is the update function from processing that it keeps repeating.
 * and well it calls the logic update and the draw update
 * 
 * @param
 * @return 
 */
void draw(){
  HandleLogicUpdate();
  HandleDrawCall();
 
}

/**
 * calls all of the update functions
 * 
 * @param
 * @return 
 */
void HandleLogicUpdate(){
  //kinectUpdate();          
  setPersonStuff();                  
  sharing();
  targetUpdate();
  explosionStuff();
  colorStuff();
  for(int i = 0;i < balls.length;i++){
   balls[i].Update();
  }  
  for(int i = 0;i < bigBalls.length;i++){
    bigBalls[i].Update();
  } 
  //for(int i = 0; i < balls.length; i++){          //So if you wanted to add ballCollision this uncommend this.
  //  for(int j = i+1; j < balls.length;j++){
  //    balls[i].HandleBallCollission(balls[j]);
  //  }
  //}
  if(updateNumber >= 30){
    //depthStuff();

    updateNumber = 0;
  }
  updateNumber++;
  count++;
  if(count == 500){
    count = 0;
    dbCon.update();
  }
  
}

/**
 * calls the draw function from the balls and checks if it is explosion time. 
 * 
 * @param
 * @return 
 */
void HandleDrawCall(){
  background(0);
  kinectDraw();
  for(int i = 0;i < balls.length/2;i++){
    balls[i].Draw();
  }
  if(users != 1){
    for(int i = balls.length/2; i< balls.length; i++){
          balls[i].Draw();
    }
  } 
  if(users >= secondUserPoint){
    for(int i = 0;i < bigBalls.length;i++){
      //bigBalls[i].Draw();
    }
    if(!exploding && explosionRearm){
      explosion();
    } 
  } else{
    exploding = false;
    explosionRearm = true;
  }
}

/**
 * if you want to get a targetList just form a sertain depth use this.
 * 
 * @param
 * @return 
 */
void depthStuff(){
  rawData = getRaw();
  targetList = new ArrayList<Integer>(50000);
  moveList = new ArrayList<Integer>(10000);
  
  if (rawData != null) {
    for (int i = 0; i<rawData.length; i++) {
      if (rawData[i]>=minD && rawData[i]<=maxD) {
        targetList.add(i);
      }
    }
  }
}


/**
 * set the persons array if there are users and fills it in with all of users. and if not it empties it.
 * 
 * @param
 * @return 
 */
void setPersonStuff(){
  oldUsers = users;
  if(bodyTrackList != null){
    users = 0;
    //users = bodyTrackList.size();
    for(int i = 0; i < bodyTrackList.size(); i++){
      persons[i] = new person((PImage)bodyTrackList.get(i));
      users++;
    }
    for(int i = bodyTrackList.size(); i < persons.length; i++) {
      persons[i] = null;
    }
  }
  else{
    users = 0;
    for(int i = 0; i < persons.length; i++) {
      persons[i] = null;
    }
  }
}

/**
 * updates the tempTarget.
 * 
 * @param
 * @return 
 */
void targetUpdate(){
  if(users>0){
    tempTarget = resizePixels(kinect.getBodyTrackImage().pixels,
                          kinect.getBodyTrackImage().width,
                          kinect.getBodyTrackImage().height,
                          width,height);
  
  }
  
}

/**
 * does explosionStuff. makes them explode after explosionCounter is the same explosionTimer.
 * 
 * @param
 * @return 
 */
void explosionStuff(){
  if(explosionRearm){
    if(exploding){
      explosionCounter++;
      if(explosionCounter == explosionTimer){
        for(int i = 0;i < balls.length;i++){
          balls[i].randomizeVelocity();
        }
      }
      if(explosionCounter > explosionReset){
        exploding = false;
        for(int i = 0;i < balls.length;i++){
          balls[i].setUser(int(random(0, users)));
          balls[i].setTarget(balls[i].getTarget());
          balls[i].setArrived(false);
        }
        explosionCounter = 0;
        explosionRearm =false;
      }
    }  
  }
}

/**
 * sets all the ball to exploding.
 * 
 * @param
 * @return 
 */
void explosion(){
  exploding = true;
  for(int i = 0; i< balls.length;i++){
    balls[i].exploding();
  }
}

/**
 * puts text on screen.
 * 
 * @param
 * @return 
 */
void explenation(){
  textSize(30);
  fill(255,255,255);
  text("dummy text",textLocation[0], textLocation[1]);
  
  if(textVariable > 50){
    fill(255,0,0);
    text("spooky text >:D",textLocation[0], textLocation[1]+30);
  }
  if(textVariable > 95){
    fill(255,0,0);
    text("doot",textLocation[0], textLocation[1]+60);
  }
  textVariable++;
  if(textVariable>100){
    textVariable = 0;
  }
}

/**
 * resizes the given array to a bigger array.
 * 
 * @param int[] pixels - the array that needs to be resized  
 * @param int w1 - the old width size.
 * @param int h1 - the old height size.
 * @param int w2 - the new width
 * @param int h2 - the new height
 * @return int [] - the new bigger array
 */
public int[] resizePixels(int[] pixels,int w1,int h1,int w2,int h2) {
  int[] temp = new int[w2*h2] ;
  int x_ratio = (int)((w1<<16)/w2) +1;
  int y_ratio = (int)((h1<<16)/h2) +1;
  int x2, y2,i,j;
  //int xUpper,yUpper,xLower,yLower ;
  for (i=0;i<h2;i++) {
      for (j=0;j<w2;j++) {
          x2 = ((j*x_ratio)>>16) ;
          y2 = ((i*y_ratio)>>16) ;
          temp[(i*w2)+j] = pixels[(y2*w1)+x2] ;
      }                
  }
  return temp ;
}

/**
 * checks if there is a key pressed and if so do the something depending on the key pressed.
 * 
 * @param
 * @return 
 */
void keyPressed() {
  if (key == '1') {
    dbCon.updatePress(0);
    println("added people");
  }
  if (key == '2') {
    dbCon.updatePress(1);
    println("added security");
  }
  if (key == '3') {
    dbCon.updatePress(2);
    println("added environment");
  }
  if (key == '4') {
    dbCon.updatePress(3);
    println("added urbanLifestyle");
  }
    if (key == '5') {
    dbCon.updatePress(4);
    println("added entertainment");
  }
  if (key == '6') {
    dbCon.updatePress(5);
    println("added health");
  }
  if (key == 'r') {
    dbCon = new dataBase();
    dbCon.updatePress(7);
    println("reset");
  }
}

/**
 * give a ball out of freeBalls
 * 
 * @param
 * @return int - the ball thats given.
 */
int giveBall(){
  int temp = freeBalls[ballPointer];
  freeBalls[ballPointer] = -1;
  ballPointer--;
  return temp;
}

/**
 * adds a ball to freeBalls;
 * 
 * @param int temp - the value freeBalls is set to
 * @return 
 */
void addBall(int temp){
  ballPointer++;
  freeBalls[ballPointer] = temp;
}

/**
 * checks if users are close to eachother or not.
 * 
 * @param
 * @return 
 */
void together(){
  for(int i = 0;i<closeUsers.length;i++){
    closeUsers[i] = 0;
  }
  if(users >= 2){
    for(int i =0; i< users; i++){
      for(int j = i+1;j<users;j++){
        if(persons[i].getRightX()>persons[j].getLeftX()||persons[j].getRightX()>persons[i].getLeftX()){
          if(persons[i].getUpperY()>persons[j].getUnderY()||persons[j].getUpperY()>persons[i].getUnderY()){
            closeUsers[i]++;
            closeUsers[j]++;
          }
        }
      }
    }
  }
}

/**
 * so that if two people are close this is suposed to share the balls but it doesnt right now. (needs more testing) 
 * 
 * @param
 * @return 
 */
void sharing(){
  if(users >= 2 && updateNumber == 0){
    for(int i =0; i< users; i++){
      for(int j = i+1;j<users;j++){
        if(closeUsers[i]>0||closeUsers[j]>0){
          for (int z = 0; z<ballSharingAmount;z++){
            balls[persons[i].giveBallID()].joinUser(j);
            balls[persons[j].giveBallID()].joinUser(i);
          }
        }
      }
    }
  }
}

/**
 * Sets the color depending on the amount of users there are.
 * 
 * @param
 * @return 
 */
void colorStuff(){
  if( users!=oldUsers && users  <2){        //All ifs check if the oldUsers isn't the same als users so that
    dbCon.setBallColor();                   //it doesn't keep changing the colour.
  } else if(users!=oldUsers &&users == 2){
    dbCon.setBallColor2();
  } else if(users!=oldUsers && users >2){
    dbCon.setBallColor3();
  } 
}

/**
 * For if you want to test something with a target and dont want to use the kinect you can use this to 
 * 
 * @param
 * @return 
 */
ArrayList<Integer> setTest(){
    ArrayList<Integer> temp = new ArrayList<Integer>(10000);
    for(int i = 100; i< 300;i++){
      for(int j = 0; j< 200;j++){
        temp.add(j + i*width);
      }
    }
    for(int i = 100; i< 200;i++){
      for(int j = 200; j< 500;j++){
        temp.add(j + i*width);
      }
    }
    for(int i = 200; i< 400;i++){
      for(int j = 400; j< 500;j++){
        temp.add(j + i*width);
      }
    }
    return temp;
}

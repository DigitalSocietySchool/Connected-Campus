class person{
  int[] location;
  int[] resizedLocation;
  ArrayList<Integer> falidLocations;
  int[][] filter;
  PImage pic;
  PImage img = createImage(width,height,0);
  PImage imgTemp = createImage(standardKinectX, standardKinectY,0);
  int maxBalls;
  int totalBalls;
  int maxBallsVariable = 200;
  
  int leftX, rightX, upperY, underY;
  int[] personBoundary;          //left,right,upper,under
  
  Ball[] userBalls;
  boolean[] ballArrayLocation;
  ArrayList<Integer>[] changeAL;
  int[] change;
  int changeValue;
  int personUpdateNumber;
  
  //int[] mates;
  //ArrayList<Integer> closeUsers;


  /**
 * the constructor for the person class, basically initalizes everything 
 * 
 * @param PImage foto - the first image that will be used to calculate everything
 * @return 
 */
  person(PImage foto){
    changeValue = 0;
    personBoundary = new int[4];
    pic = foto;
    userBalls = new Ball[ballNumber];
    ballArrayLocation = new boolean[ballNumber];
    
    for(int i =0;i<ballArrayLocation.length;i++){
      ballArrayLocation[i] = false;
    }
    
    location = pic.pixels;
    resizing(pic.width,pic.height); 
    filter = new int[width][height];
    target();  

    //mates = new int[maxUsers];
    //closeUsers = new ArrayList<Integer>(users);
    
    maxBalls = 300;
    totalBalls = 0;
    
    personUpdateNumber = int(random(0,50));
  }
  
/**
 * update the person
 * 
 * @param PImage foto - the PImage that will be used in location updating
 * @return 
 */
  void update(PImage foto){
    pic = foto;
    location = pic.pixels;
    resizing(pic.width,pic.height);
    //checkBalls();
    target(); 
    checkBoundaries();
    personUpdateNumber++;
    if(personUpdateNumber > 50){
      personUpdateNumber = 0;
    }
  }
  
  /**
   * add a ball to the ballArrayLocation array
   * 
   * @param int location - the location of the ball that will be set to active.
   * @return 
   */
  void addBallArrayLocation(int location){
    this.ballArrayLocation[location] = true;
    totalBallsplus();
  }
  
  /**
   * remove a ball from the ballArrayLocation array
   * 
   * @param
   * @return 
   */
  void removeBallArrayLocation(int location){
    this.ballArrayLocation[location] = false;
    totalBallsmin();
  }
  
  /**
   * is supposed to draw one specifik users silhouette
   * butt it isnt working right now suspect pic to be the cause.
   * 
   * @param
   * @return 
   */
  void personDraw(){
    PImage imgTemp = createImage(standardKinectX,standardKinectY,0);
    //int[] kinectPixels = resizePixels(pic.pixels, standardKinectX,
    //                     standardKinectY, width,height);
       
    //int[] kinectPixels = kinect.getBodyTrackImage().pixels;
    int[] kinectPixels = pic.pixels;
    //for(int i = 0; i< 10;i++){
    //  print(kinectPixels[i]);
    //  //kinectPixels[i] = 100;
    //}
    //println();
    for(int i = 0; i< kinectPixels.length;i++){
      //if(kinectPixels[i]!=0){
      //  kinectPixels[i] = 100;
      //}
      if(kinectPixels[i]==0){
        kinectPixels[i] = -1;
      }
    }


    imgTemp.loadPixels();
    imgTemp.pixels = kinectPixels; 
    
    imgTemp.updatePixels();  
    image(imgTemp,0,0); 
  }
  
  /**
   * resize location so that it fits the screen.
   * 
   * @param int imgWidth - the old width of location
   * @param int imgHeight - the old height of location.
   * @return 
   */
  void resizing(int imgWidth, int imgHeight){
    resizedLocation = resizePixels(location, imgWidth, imgHeight, width, height );
  }
  
  /**
   * updates the target locations the balls can go for. in falidLocations all of the falid locations are stored
   * and in change[] is stored if there is a change in a location compared check before.
   * changeValue is the amount of changed (also has to be active) locations.
   * 
   * @param
   * @return 
   */
  void target(){
    falidLocations = new ArrayList<Integer>(10000);
    
    if (resizedLocation != null) {
      change = new int[resizedLocation.length];
      changeValue = 0;
      for (int i = 0; i<resizedLocation.length; i++){
        if (resizedLocation[i]!=0){
          falidLocations.add(i);
          //println(resizedLocation.length+" "+i);
          filter[i%width][i/width] = 1;
          if (change[i] == 0){
            change[i] = 1;
            changeValue++;
          } else{
            change[i] = 0;
            changeValue--;
          }
        }
        else{
          filter[i%width][i/width] = 0;
          if(change[i] == 1){
            change[i] = 0;
            changeValue--;
          }
        }
      }
    }
  }
  
  //void checkBalls(){
  //  setMaxBalls();
  //  if(totalBalls < maxBalls){
  //    for(int i = totalBalls; i < maxBalls;i++){
  //      ballArrayLocation[i] = giveBall();
  //      totalBalls++;
  //    }
  //  }
  //  else if(totalBalls>maxBalls){
  //    for(int i = totalBalls-1; i >= maxBalls;i--){
  //      addBall(ballArrayLocation[i]);
  //      totalBalls--;
  //    }
  //  }
  //}
  
  /**
   * set maxBalls to a given value
   * 
   * @param int max - the value maxBalls will be set to
   * @return 
   */  
  void setMaxBalls(int max){
    this.maxBalls = max;
  }
  /**
   * recalculates the max amount of balls the person can have.
   * 
   * @param
   * @return 
   */
  void setMaxBalls(){
    this.maxBalls = this.falidLocations.size()/this.maxBallsVariable;
  }  
  /**
   * set totalBalls to a given value
   * 
   * @param int total - the value totalBalls will be set to.
   * @return 
   */
  void setTotalBalls(int total){
    this.totalBalls = total;
  }
  /**
   * add 1 to totalBalls
   * 
   * @param
   * @return 
   */
  void totalBallsplus(){
    this.totalBalls++;
  }
  /**
   * subtract 1 from totalBalls;
   * 
   * @param
   * @return 
   */
  void totalBallsmin(){
    this.totalBalls--;
  }
  /**
   * returns the max amount of balls this person can have
   * 
   * @param
   * @return int - maxBalls
   */
  int getMaxBalls(){
    return this.maxBalls;
  }
  /**
   * returns the total amount of balls this person has.
   * 
   * @param
   * @return int - totalBalls
   */
  int getTotalBalls(){
    return this.totalBalls;
  }
  /**
   * returns the filtered data
   * 
   * @param
   * @return int[][] - filter.
   */
  int[][] getFilter(){
    return this.filter;
  }
  /**
   * returns an ArrayList<Integer> with all of the falidlocations
   * 
   * @param
   * @return ArrayList<Integer> - falidLocations
   */
  ArrayList<Integer> getFalidLocations(){
    return this.falidLocations;
  }
  /**
   * returns change
   * 
   * @param
   * @return int[] - change
   */
  int[] getChange(){
    return this.change;
  }
  /**
   * returns the changeValue
   * 
   * @param
   * @return int - ChangeValue
   */
  int getChangeValue(){
    return this.changeValue;
  }
  /**
   * sets the boundaries in upperY & underY and rightX & leftX
   * 
   * @param
   * @return 
   */
  void checkBoundaries(){
    if(personUpdateNumber == 0){
      outer: for(int i =0; i< width;i++){
        inner: for(int j =0; j<height;j++){
          if(filter[i][j] == 1){
            this.leftX = i;
            personBoundary[0] = i;
            break outer;
          } 
        }
      }
      outer: for(int i =width-1; i>= 0;i--){
        inner: for(int j =0; j<height;j++){
          if(filter[i][j] == 1){
            this.rightX = i;
            personBoundary[1] = i;
            break outer;
          } 
        }
      }
      outer: for(int i =0; i< height;i++){
        inner: for(int j =0; j<width;j++){
          if(filter[j][i] == 1){
            this.leftX = i;
            personBoundary[2] = i;
            break outer;
          } 
        }
      }
      outer: for(int i =height-1; i>= 0;i--){
        inner: for(int j =0; j<width;j++){
          if(filter[j][i] == 1){
            this.leftX = i;
            personBoundary[3] = i;
            break outer;
          } 
        }
      }
    }
  }
  /**
   * returns rightX
   * 
   * @param
   * @return int - rightX
   */
  int getRightX(){
    return this.rightX;
  }
  /**
   * returns upperY
   * 
   * @param
   * @return int - upperY
   */
  int getUpperY(){
    return this.upperY;
  }
  /**
   *  returns leftX
   * 
   * @param
   * @return  int - leftX
   */
  int getLeftX(){
    return this.leftX;
  }
  /**
   * returns underY 
   * 
   * @param
   * @return int - underY
   */
  int getUnderY(){
    return this.underY;
  }
  /**
   * returns a random location from a ball in the ballArrayLocation.
   * 
   * @param
   * @return int - a random location of a ball a person has.
   */
  int giveBallID(){
    int temp = int(random(0,totalBalls));//could be all the values of 0 up to & including totalBalls-1
    for(int i = 0; i< ballArrayLocation.length;i++){
      if(ballArrayLocation[i]){
        temp--;
      }
      if(temp==0){
        return i;
      }
    }
    return 0;
  }
  //void setCloseUsers(int close){
  //  closeUsers.add(close);
  //}
}

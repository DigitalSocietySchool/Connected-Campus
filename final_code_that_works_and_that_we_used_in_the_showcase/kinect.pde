
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
boolean done;
int[] points;
PImage body;
ArrayList<PImage> bodyTrackList;

int intervalTracker = 0;

/**
 * the setup for the kinect.
 * 
 * @param int min - the min depth the kinect checks (we're not using this in the end)
 * @param int max - the max depth the kinect checks (we're not using this in the end)
 * @return 
 */
void kinectSetup(int min, int max){
  done = false;
  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  
  kinect.enableBodyTrackImg(true);
  kinect.enableDepthMaskImg(true);

  kinect.init();
  kinect.setLowThresholdPC(min);
  kinect.setHighThresholdPC(max);
  done = true;
  kinectCount =0;
  
}

/**
 * draws the bodyTrackImage from the kinect. And over lays a transparent image depending on the users
 * 
 * @param
 * @return 
 */
void kinectDraw() {
  bodyTrackList = kinect.getBodyTrackUser();
  if(users >= firstUserPoint){
    

    PImage img = createImage(width,height,0);
    int[] kinectPixels = resizePixels(kinect.getBodyTrackImage().pixels,
                          kinect.getBodyTrackImage().width,
                          kinect.getBodyTrackImage().height,
                          width,height);
     
    img.loadPixels();
    
    img.pixels = kinectPixels;
    img.updatePixels();
     
    image(img,0,0);
      
    fill(0,0,0,255-kinectCount);
    rect(0,0,width,height);
    kinectCount += 4;
     
    if(kinectCount > 255){
      kinectCount = 255;
    }
       
    ////image(kinect.getBodyTrackImage(), 0, 0, width, height);
   
    //for (int i = 0; i < bodyTrackList.size(); i++) {
    //  PImage bodyTrackImg = (PImage)bodyTrackList.get(i);
    
    //  println(bodyTrackImg.width+" "+bodyTrackImg.height);
    //  //println(bodyTrackImg.pixels.length);
    //  //image(bodyTrackImg, 0, 0, width, height);
    //}
  } else{
    
    fill(255,255,255,kinectCount);
    rect(0,0,width,height);
    if(kinectCount >0){
      kinectCount -=4;
      if(kinectCount <0){
        kinectCount = 0;
      }
    }
  }
  
  //fill(120);
  //textSize(16);
  //text(frameRate,50, 30);
  //text(kinect.getNumOfUsers(), 50, 50);
  //text(bodyTrackList.size(), 50, 70);
  
}

//KinectDraw kind of does the update so ignore this.
void kinectUpdate(){
  
}



/**
 * returns the raw data from the kinect in an int[].
 * 
 * @param
 * @return int[] the raw data from the kinect.
 */
int[] getRaw(){
 return kinect.getRawDepthData(); 
}

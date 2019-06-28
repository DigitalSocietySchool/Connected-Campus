public static int ballNumber = 1500;
public int ballPointer;
public int[] freeBalls;
public int[] personBalls;

public Ball[] balls;
public bigBall[] bigBalls;
public person[] persons;

public dataBase dbCon;

public int[] tempTarget;

public static int maxD = 900; 
public static int minD = 700;

public static int standardKinectX = 512;
public static int standardKinectY = 424;

public int updateNumber;
public int count;

public int explosionCounter;
public static int explosionTimer = 20;
public static int explosionReset = 40;
public boolean exploding;
public static int explodingValue = 30;
public boolean explosionRearm;

public ArrayList<Integer> targetList;
public ArrayList<Integer> oldTargetList;
public ArrayList<Integer> moveList;

public int[] choData;
public int[] rawData;
public int[] oldRawData;

public int users;
public int oldUsers;
public int flashyStuff;

public static int firstUserPoint = 2;
public static int secondUserPoint = 3;
public static int maxUsers = 10;
public int[] closeUsers;

public color people = color(214,181,43);
public color security = color(67,102,254);
public color environment = color(132,193,0);
public color urbanLifestyle = color(114,58,39);
public color entertainment = color(170,2,166);
public color health = color(158,0,0);
public color standart = color(0,0,0);

public color[] template = {people,security,environment,
                    urbanLifestyle,entertainment,
                    health,standart};
                    
public color people2 = color(255,236,0);
public color security2 = color(0,195,255);
public color environment2 = color(0,211,10);
public color urbanLifestyle2 = color(211,85,0);
public color entertainment2 = color(200,0,206);
public color health2 = color(198,0,0);
public color standart2 = color(0,0,0);

public color[] template2 = {people2,security2,environment2,
                    urbanLifestyle2,entertainment2,
                    health2,standart2};       

public color people3 = color(255,255,0);
public color security3 = color(0,255,242);
public color environment3 = color(6,255,0);
public color urbanLifestyle3 = color(255,163,0);
public color entertainment3 = color(255,0,243);
public color health3 = color(255,0,0);
public color standart3 = color(0,0,0);

public color[] template3 = {people3,security3,environment3,
                    urbanLifestyle3,entertainment3,
                    health3,standart3};                              
// ball
public static int moveSpeed = 150;
public static int defaultSpeed = 1;



// bigBall
public static int moveSpeedBig = 10;
                    
public ArrayList<Integer> test;

public int[] textLocation;
public int textVariable;

// persons
public static int closeVar = 30;
public static int ballSharingAmount = 10;

public int kinectCount;

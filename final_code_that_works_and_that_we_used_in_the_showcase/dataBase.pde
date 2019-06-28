class dataBase{
  int[] votes;
  int[] votesOld;
  int total;
  JSONObject json;
  int people;
  int security;
  int environment;
  int urban;
  int entertainment;
  int health;
  boolean voteChange;
/**
 * the constructor for the dataBase class, basically initalizes everything 
 * 
 * @param
 * @return 
 */
  dataBase(){
    this.people = 1;
    this.security = 1;
    this.environment = 1;
    this.urban = 1;
    this.entertainment = 1;
    this.health = 1;
    
    this.votes = new int[]  {people, security, environment, urban, entertainment, health};
    this.votesOld = votes;
    this.total = people + security + environment+urban+entertainment+health;
    
  }
/**
 * updates the votes by getting info from website & changes the color from the balls if there is a change in votes
 * 
 * @param
 * @return 
 */
  void update(){
    this.json = loadJSONObject("https://campus.2019.dss.cloud/Votes/public/json");
    
    this.people = json.getInt("people");
    this.security = json.getInt("security");
    this.environment = json.getInt("environment");
    this.urban = json.getInt("urban");
    this.entertainment = json.getInt("entertainment");
    this.health = json.getInt("health");
    
    this.votes = new int[]  {people, security, environment, urban, entertainment, health};
    this.total = people + security + environment+urban+entertainment+health;
    
    
    check: for(int i = 0; i<votes.length;i++){
      if(votes[i]!=votesOld[i]){
        voteChange = true;
        break check;
      } else{
        voteChange = false;
      }      
    }
    
    if(voteChange){
      //setBallColor();
      println("yay");
    }
    votesOld = votes;
    
  }
/**
 * sets the ball color depending on the votes in the array votes
 * 
 * @param
 * @return 
 */  
  void setBallColor(){
    float val;
    float temp = 0;
    for(int i = 0; i< balls.length;i++){
      val = random(0,1);
      inner: for(int j =0; j<votes.length;j++){
        temp += (float)votes[j]/total;
        if(val <= temp){
          balls[i].setColor(template[j]);
          break inner;
        }
      }
      temp = 0;
    }
  }
/**
 * same as setBallColor only with a different color pallet 
 * 
 * @param
 * @return 
 */
  void setBallColor2(){
    float val;
    float temp = 0;
    for(int i = 0; i< balls.length;i++){
      val = random(0,1);
      inner: for(int j =0; j<votes.length;j++){
        temp += (float)votes[j]/total;
        if(val <= temp){
          balls[i].setColor(template2[j]);
          break inner;
        }
      }
      temp = 0;
    }
  }
  
/**
 * same as setBallColor only with a different color pallet 
 * 
 * @param
 * @return 
 */
  void setBallColor3(){
    float val;
    float temp = 0;
    for(int i = 0; i< balls.length;i++){
      val = random(0,1);
      inner: for(int j =0; j<votes.length;j++){
        temp += (float)votes[j]/total;
        if(val <= temp){
          balls[i].setColor(template3[j]);
          break inner;
        }
      }
      temp = 0;
    }
  }
  
  
/**
 * updates the votes array by adding 1 to the indicated value 
 * 
 * @param int val - is the index the votes array is going to be updated
 * @return 
 */
  void updatePress(int val){
    switch(val){
      case 0:
        votes[0]++;
        break;
      case 1:
        votes[1]++;
        break;
      case 2:
        votes[2]++;
        break;
      case 3:
        votes[3]++;
        break;
      case 4:
        votes[4]++;
        break;
      case 5:
        votes[5]++;
        break;
      default:
        println("no color added");  
    }
    total++;
    setBallColor();
  }
}

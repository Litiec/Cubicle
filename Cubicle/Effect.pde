class Effect {
  Light light;
  GameOver gOver;
  GameStart gStart;
  RotateSpace rotSpace;
  Cube cubeRef;
  VirtualRoom roomRef;
  Box [] winBox;
  Box [] filledBox;
  long currentTIME;
  long warningTIME;
  long targetTIME;
  PVector distortion;
  boolean eventFill, eventCelebrate;
  Effect(VirtualRoom roomRef) {
    this.roomRef = roomRef;
    light = new Light();
    rotSpace = new RotateSpace();
    targetTIME = 30000;
    distortion = new PVector(0,0,0);
    gOver = new GameOver();
    gStart = new GameStart();
  }
  void setCubeRef(Cube ref) {
    this.cubeRef = ref;
    winBox = new Box[cubeRef.nrbox];
    filledBox = new Box[cubeRef.nrbox];
  }
  void lightprocess() {
    light.process();
    cubeRef.outline.setStroke(color(light.r, light.g, light.b));
    roomRef.setColor(light.r, light.g, light.b);
  }
  void rotateprocess() {
    rotSpace.process();
  }
  void setLightSpeed(float r, float g, float b) {
    light.setSpeed(r, g, b);
  }
  void setRotateSpeed(float s) {
    rotSpace.setSpeed(s);
  }
  void warning(){
    if(warningTIME == 0){
      warningTIME = millis();
    }
    long delta = millis()-warningTIME;
    if(delta>=targetTIME){
      background(255);
      if(frameCount%5==0){
        distortion = PVector.random3D();
        distortion.mult(50);
      }
      pushMatrix();
      translate(width/2+distortion.x,height/2+distortion.y, rotSpace.zoom+distortion.z);
      rotSpace.rotateNoInc();
      for(Box bx : cubeRef.box) bx.display();
      cubeRef.displayFrame();
      popMatrix();
      if(delta>=targetTIME+250){
        targetTIME += 1500;
      }
    }
  }
  void whenWinBox(){
    if(eventCelebrate){
      eventFill = false;
      if(currentTIME == 0){
        currentTIME = millis();
      }
      long delta = millis()-currentTIME;
      if(frameCount%5 == 0)background(winBox[0].gem.gemColor);
      else background(0);
      pushMatrix();
      lightprocess();
      translate(width/2, height/2, rotSpace.zoom);
      room.display();
      rotateprocess();
      for(Box bx : winBox){
        bx.process();
        bx.display();
      }
      cubeRef.displayOutline();
      cubeRef.displayFrame();
      popMatrix();
      if(delta>=1000){
        eventCelebrate = false;
        currentTIME = 0;
      }
    }
  }
  void whenFillBox() {
    if (eventFill&&!eventCelebrate) {
      if(currentTIME==0){
        currentTIME = millis();
      }
      long delta = millis()-currentTIME;
      pushMatrix();
      lightprocess();
      fill(200,40);
      rect(0,0, width, height);
      translate(width/2, height/2,rotSpace.zoom);
      room.display();
      rotateprocess();
      for (Box bx : filledBox) {
        bx.process();
        bx.display();
      }
      cubeRef.displayOutline();
      cubeRef.displayFrame();
      popMatrix();
      if(delta>=500){
        eventFill = false;
        currentTIME = 0;
      }
    }
  }
  void gameDuration(){
    if(millis()> gOver.gameLast){
      zoomZ+=5;
      gOver.countDown = true;
      if(zoomZ>8660) gOver.endGame = true;
    }
  }
  void gameStart(){
    gStart.display();
  }
  class GameOver{
    long gameLast = 600000;
    boolean endGame;
    boolean countDown;
    PFont font;
    int alpha, alpha2 = 0;
    float dist;
    
    GameOver(){
      font = createFont("earthorbiter", 102, true);
    }
    void display(){
      background(0);
      textFont(font);
      textAlign(CENTER);
      color c = color((float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255));
      fill(255, alpha2);
      if(frameCount%10==0)dist=(float)Math.random()*40-20;
      text("Game Over", width/2+dist, height/2);
      fill(c, alpha);
      text("Game Over", width/2, height/2);
      if(alpha<255) alpha+=5;
      if(alpha2<50) alpha2+=1;
    }
  }
  class GameStart{
    boolean canStart;
    boolean start;
    long reset;
    PFont font;
    String [] count = {"5","4","3","2","1","0"};
    float dist;
    GameStart(){
      font = createFont("earthorbiter", 400, true);
    }
    void display(){
      background(0);
      if(canStart){
        if(reset==0)reset=millis();
        textFont(font);
        textAlign(CENTER);
        long delta = millis()-reset;
        color c = color((float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255));
        fill(c);
        textAlign(CENTER);
        text(count[(int)(delta/1000)], width/2, height/2);
        fill(255, 100);
        if(frameCount%10==0)dist=(float)Math.random()*40-20;
        text(count[(int)(delta/1000)], width/2+dist, height/2);
        if(delta>=5000) start=true;
      }
    }
  }
}

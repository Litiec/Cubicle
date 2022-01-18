class Light{
  float r,g,b;
  float incR, incG, incB;
  float incRspeed,incGspeed,incBspeed;
  
  void setSpeed(float incRspeed,float incGspeed,float incBspeed){
    this.incRspeed = incRspeed;
    this.incGspeed = incGspeed;
    this.incBspeed = incBspeed;
  }
  void changeColor(){
    r = lerp(0,255, ((sin(radians(incR))*0.5+0.5)*10)/10.0);
    g = lerp(0,255, ((sin(radians(incG))*0.5+0.5)*10)/10.0);
    b = lerp(0,255, ((sin(radians(incB))*0.5+0.5)*10)/10.0);
    incR+= incRspeed; ;
    incG+= incGspeed;
    incB+= incRspeed;;
  }
  void process(){
    changeColor();
    lightSpecular(r,g,b);
    directionalLight(255, 0, 0, 0, 1, -1);
  }
}

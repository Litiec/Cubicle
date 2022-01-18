class RotateSpace {
  float rx,ry,rz,inc, speed;
  boolean keypressed;
  int dir;
  float zoom;
  float incZoom;
  
  void setSpeed(float speed){
    this.speed = speed;
  }
  void process(){
    ZoomInOut();
    if(keypressed)inc+= speed*dir;
    rx+= 0.003+inc;
    ry+= 0.005+inc;
    rz+= 0.002+inc;
    rotateX(rx%TWO_PI);
    rotateY(ry%TWO_PI);
    rotateZ(rz%TWO_PI);
  }
  void rotateNoInc(){
    rotateX(rx%TWO_PI);
    rotateY(ry%TWO_PI);
    rotateZ(rz%TWO_PI);
  }
  void ZoomInOut(){
    zoom = lerp(0,200, (sin(radians(incZoom))*0.5+0.5)*10/10.0)-zoomZ; 
    incZoom+=0.1;
  }
}

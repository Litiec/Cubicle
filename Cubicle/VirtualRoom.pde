class VirtualRoom{
  PShape room;
  float incx, incy, incz;
  float speedX, speedY, speedZ;
  VirtualRoom(int size){
    room = createShape(BOX, size);
    room.setFill(false);
  }
  void display(){
    process();
    pushMatrix();
    rotateX(incx%TWO_PI);
    rotateY(incy%TWO_PI);
    rotateZ(incz%TWO_PI);
    shape(room);
    popMatrix();
  }
  void process(){
    incx+=speedX;
    incy+=speedY;
    incz+=speedZ;
  }
  void setSpeedRotation(float... inc){
    speedX = inc[0];
    speedY = inc[1];
    speedZ = inc[2];
  }
  void setColor(float r, float g, float b){
    room.setStroke(color(r,g,b));
  }
}

class Pointer {
  PVector pos, vertex, lineUp, heading, point;
  PShape pspointer;
  float amt, speed;
  int iFrame;
  Frame frame;
  Pointer(PVector pos, int size, Frame frame) {
    heading = new PVector(size, size, 0);
    vertex = new PVector(pos.x*heading.x, pos.y*heading.y, pos.z*heading.z);
    lineUp = new PVector(0, 0, 0);
    this.pos = new PVector();
    this.pos.set(pos);
    point = new PVector();
    pspointer = createShape(BOX, 20);
    pspointer.setStroke(false);
    pspointer.setFill(color(124,252,0, 150));
    speed = 200;
    iFrame=0;
    this.frame = frame;
  }
  void setLineUp(PVector v) {
    lineUp.set(v);
    iFrame = 0;
    amt = 0;
  }
  void setHeading(float x, float y, float z) {
    heading.set(x, y, z);
    iFrame = 0;
    amt=0;
  }
  void display() {
    pushMatrix();
    translate(vertex.x, vertex.y, vertex.z);
    shape(pspointer);
    popMatrix();
  }
  void moveInFrame(PVector[]v) {
    if (amt>speed) {
      amt = 0;
      iFrame++;
    }
    if (iFrame==v.length) iFrame=0;
    pos = PVector.lerp(v[iFrame], v[(iFrame+1)%v.length], amt++/speed);
    vertex.set(pos.x*heading.x, pos.y*heading.y, pos.z*heading.z);
    vertex.add(lineUp);
    if (amt<speed/2)genPoint(v[(iFrame+1)%v.length]);
    else genPoint(v[(iFrame)%v.length]);
  }

  boolean isPointing(PVector a, PVector b, PVector t) {
    float dxc = t.x - a.x; 
    float dyc = t.y - a.y; 
    float dxl = b.x - a.x; 
    float dyl = b.y - a.y; 
    float cross = dxc * dyl - dyc * dxl;
    return cross == 0;
  }
  PVector halfPiRot(PVector o, PVector t) {
    float x = (t.x-o.x)*cos(HALF_PI)-(t.y-o.y)*sin(HALF_PI);
    float y = (t.x-o.x)*sin(HALF_PI)+(t.y-o.y)*cos(HALF_PI);
    return PVector.add(new PVector(Math.round(x), Math.round(y)), o);
  }
  void genPoint(PVector v) {
    switch(frame.currentAxis) {
    case 0:
      point.set(halfPiRot(new PVector(Math.round(pos.x), Math.round(pos.y)), new PVector(v.x, v.y)));
      break;
    case 1: 
      point.set(halfPiRot(new PVector(Math.round(pos.z), Math.round(pos.y)), new PVector(v.z, v.y)));
      break;
    case 2:
      point.set(halfPiRot(new PVector(Math.round(pos.x), Math.round(pos.z)), new PVector(v.x, v.z)));
      break;
    }
  }
}

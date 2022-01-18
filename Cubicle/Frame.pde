import java.util.Arrays;
class Frame {
  PShape psframe;
  Box[]pointedBox;
  Gem[] rndgem;
  GemType[]types;
  Cube cubeRef;
  int [][]orderGem;
  int indexPosFrame;
  boolean clean = true;
  PVector[]vector;
  Pointer pointer;
  int size; 
  int boxSize;
  int currentAxis=0;
  int currentRow = 2;
  boolean canSwitchAxis = true;
  boolean stop = true;
  boolean inEdge;
  int theta;
  int thetaTarget;
  int center, gap;
  float thetaSpeed;
  Frame(Cube cubeRef, int nrbox, int center, int size, int boxSize, int gap, int thetaTarget, float thetaSpeed) {
    this.cubeRef = cubeRef;
    pointedBox = new Box[nrbox];
    this.size=size;
    this.boxSize = boxSize;
    this.center=center;
    this.gap=gap;
    this.thetaTarget = thetaTarget;
    this.thetaSpeed = thetaSpeed;
    vector = new PVector[4];
    vector[0] = new PVector(-center, -center, 0);
    vector[1] = new PVector(center, -center, 0);
    vector[2] = new PVector(center, center, 0);
    vector[3] = new PVector(-center, center, 0);
    psframe = createShape();
    psframe.setFill(false);
    psframe.setStrokeWeight(5);
    psframe.setStroke(color(255));
    createFrame();
    rndgem = new Gem[nrbox];
    types = new GemType[nrbox];
    int i = 0;
    for (GemType t : GemType.values()) types[i++] = t;
    genRandomGem();
    orderGem = new int[6][vector.length];
    orderGem[0] = new int[]{0, -(nrbox-1), -(nrbox-1), 0};
    orderGem[1] = new int[]{0, -(nrbox-1), -(nrbox-1), 0};
    orderGem[2] = new int[]{-(nrbox-1), -(nrbox-1), 0, 0};
    orderGem[3] = new int[]{-(nrbox-1), 0, 0, -(nrbox-1)};
    orderGem[4] = new int[]{-(nrbox-1), 0, 0, -(nrbox-1)};
    orderGem[5] = new int[]{-(nrbox-1), -(nrbox-1), 0, 0};
    pointer = new Pointer(vector[0], size, this);
  }
  void fillpointedBox() {
    for (int i = 0; i<pointedBox.length; i++) {
      pointedBox[i].linkGem();
      if (cubeRef.midi!=null) cubeRef.midi.sendMidi(pointedBox[i]);
      cubeRef.effectRef.filledBox[i] = new Box(pointedBox[i].cordX, pointedBox[i].cordY, pointedBox[i].cordZ, pointedBox[i].size, pointedBox[i].gap, pointedBox[i].psbox, pointedBox[i].gem);
    }
    cubeRef.effectRef.warningTIME = 0;
    cubeRef.effectRef.targetTIME = 60000;
    cubeRef.effectRef.eventFill = true;
    genRandomGem();
  }
  void genRandomGem() {
    if (next!=null) {
      if (next.gem == null) {
        next.gem = new Gem[pointedBox.length];
        for (int i = 0; i < next.gem.length; i++) {
          next.gem[i] = new Gem(types[(int)Math.floor(Math.random()*rndgem.length)], boxSize/2);
        }
      }
      rndgem = Arrays.copyOf(next.gem, next.gem.length);
      for (int i = 0; i < next.gem.length; i++) {
        next.gem[i] = new Gem(types[(int)Math.floor(Math.random()*rndgem.length)], boxSize/2);
      }
      next.update();
    }else{
      for (int i = 0; i < next.gem.length; i++) {
        rndgem[i] = new Gem(types[(int)Math.floor(Math.random()*rndgem.length)], boxSize/2);
      }
    }
  }
  void createFrame() {
    psframe.beginShape();
    for (PVector v : vector) {
      psframe.vertex(v.x*size, v.y*size, v.z*size);
    }
    psframe.endShape(CLOSE);
  }
  void display() {
    shape(psframe);
    if (stop)
      pointer.display();
  }
  void update() {
    for (int i =0; i<4; i++) {
      psframe.setVertex(i, PVector.mult(vector[i], size));
    }
  }
  void update(PVector v, int index) {
    PVector tmp = psframe.getVertex(index);
    tmp.add(v);
    psframe.setVertex(index, tmp);
    if (index==0)pointer.setLineUp(PVector.add(pointer.lineUp, v));
  }
  void process() {
    switchAxis();
    pointer.moveInFrame(vector);
    psframe.setStroke(color(Math.round(Math.random()*255), Math.round(Math.random()*255), Math.round(Math.random()*255)));
  }
  void swAxisProcess(Cord a, Cord b) {
    float tmp = a.value;
    a.value = a.value*cos(thetaSpeed)-b.value*sin(thetaSpeed);
    b.value = tmp*sin(thetaSpeed)+b.value*cos(thetaSpeed);
  }
  boolean isFinish() {
    if (theta==thetaTarget) stop = true;
    return stop;
  }
  void switchAxis() {
    if (canSwitchAxis) {
      if (!stop) {
        if (clean) for (Box bx : pointedBox) bx.isPointMe = false;
        int index = 0;
        switch(currentAxis) {
        case 0:
          for (PVector v : vector) {
            Cord a = new Cord(v.x);
            Cord b = new Cord(v.z);
            swAxisProcess(a, b);
            v.x=a.value;
            v.z=b.value;
            if (isFinish()) {
              roundVector(v);
              if (index++==0)pointer.setHeading(0, size, size);
            }
          }
          break;
        case 1:
          for (PVector v : vector) {
            Cord a = new Cord(v.x);
            Cord b = new Cord(v.y);
            swAxisProcess(a, b);
            v.x = a.value;
            v.y = b.value;
            if (isFinish()) {
              roundVector(v);
              if (index++==0)pointer.setHeading(size, 0, size);
            }
          }
          break;
        case 2:
          for (PVector v : vector) {
            Cord a = new Cord(v.y);
            Cord b = new Cord(v.z);
            swAxisProcess(a, b);
            v.y = a.value;
            v.z = b.value;
            if (isFinish()) {
              roundVector(v);
              if (index++==0)pointer.setHeading(size, size, 0);
            }
          }
          break;
        }
        theta++;
        if (stop) {
          clean = true;
          currentAxis++;
          theta = 0;
          indexPosFrame++;
        }
        if (currentAxis>2) currentAxis = 0;
        if (indexPosFrame == orderGem.length) indexPosFrame = 0;
        update();
      }
    } else stop = true;
  }
  float swRowProcess(Cord c, int dir) {
    inEdge = false;
    c.value+=dir;
    currentRow = (int)c.value+center;
    if (c.value<-center) {
      c.value = -center;
      inEdge = true;
      currentRow =(int)(c.value+center);
    } else if (c.value>center) {
      c.value = center;
      inEdge =true;
      currentRow = (int)c.value+center;
    }
    if (c.value==0)canSwitchAxis = true;
    else canSwitchAxis = false;
    return c.value;
  }
  void switchRow(int direction) {
    if (stop) {
      for (Box bx : pointedBox) bx.isPointMe = false;
      PVector tmp = new PVector();
      switch(currentAxis) {
      case 0: 
        for (int i=0; i<vector.length; i++) {
          vector[i].z = swRowProcess(new Cord(vector[i].z), direction);
          if (!inEdge)update(tmp.set(0, 0, gap*direction), i);
        }
        break;
      case 1:
        for (int i=0; i<vector.length; i++) {
          vector[i].x = swRowProcess(new Cord(vector[i].x), direction);
          if (!inEdge)update(tmp.set(gap*direction, 0, 0), i);
        }
        break;
      case 2:
        for (int i=0; i<vector.length; i++) {
          vector[i].y = swRowProcess(new Cord(vector[i].y), direction);
          if (!inEdge)update(tmp.set(0, gap*direction, 0), i);
        }
        break;
      }
    }
  }
}

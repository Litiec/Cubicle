import themidibus.*;
class Cube {
  Box[] box;
  Box[] ligth;
  Matrix matrix;
  Frame frame;
  GameLogic logic;
  Effect effectRef;
  Midi midi;
  PShape outline;
  int center;
  int nrbox;
  int gap;
  int theta;
  int thetaTarget = 90;
  float thetaSpeed;
  int currentAxis = 0;
  int currentRow = 0;
  boolean isRotating;
  boolean stop = true;
  Cube(Effect effectRef, int size, int nrbox, PitchSet pset, SpeedSet speed) {
    gap = (int)Math.round(pow(sqrt(size*2), 2));
    box = new Box[(int)Math.floor(pow(nrbox, 3))];
    ligth = new Box[nrbox*nrbox];
    this.nrbox = nrbox;
    matrix = new Matrix(nrbox);
    int i =0;
    this.nrbox = nrbox;
    this.center =nrbox/2;
    for (int x = 0; x< nrbox; x++) {
      for (int y = 0; y<nrbox; y++) {
        for (int z = 0; z<nrbox; z++) {
          box[i] = new  Box(x-center, y-center, z-center, size, gap, pset.getPitch(y, z), speed.getSpeed(y, z));
          matrix.insert('x', box[i], center, nrbox);
          matrix.insert('y', box[i], center, nrbox);
          matrix.insert('z', box[i], center, nrbox);
          i++;
        }
      }
    }
    thetaTarget = 90;
    thetaSpeed = radians(1);
    int sideCube =((size/2)*(nrbox-2));
    int frameSize =(int)Math.round(pow(sqrt(sideCube*2), 2));
    outline = createShape(BOX, frameSize*4);
    outline.setFill(false);
    outline.setStrokeWeight(2);
    frame = new Frame(this, nrbox, center, frameSize, size, gap, thetaTarget, thetaSpeed);
    logic = new GameLogic(this);
    this.effectRef = effectRef;
    this.effectRef.setCubeRef(this);
  }
  void createMidiBus(String bus) {
    midi = new Midi(bus);
  }
  void midiBusList() {
    MidiBus.list();
  }
  void update() {
    for (Box bx : box) {
      matrix.insert('x', bx, center, nrbox);
      matrix.insert('y', bx, center, nrbox);
      matrix.insert('z', bx, center, nrbox);
    }
  }
  void display() {
    for (Box bx : box) {
      bx.process();
      bx.display();
    }
    displayOutline();
  }
  void displayOutline() {
    shape(outline);
  }
  void displayFrame() {
    frame.display();
  }
  void process() {
    frame.process();
    rotateBox();
    if (!isRotating&&frame.stop)boxPointed();
    highlightBox();
  }
  void searchForLines() {
    boolean end = false;
    if (logic.event) {
      if (!logic.iterateMatrix(matrix.mtx)) {
        if (logic.turns==1) end = true;
        if (!logic.iterateMatrix(matrix.mty)) {
          if (logic.turns==1) end = true;
          if (!logic.iterateMatrix(matrix.mtz)) {
            if (logic.turns==1) end = true;
          }
        }
      }
      if (logic.turns==0) logic.turns++;
      if (end) {
        logic.event = false;
        logic.turns = 0;
      }
    }
  }
  boolean isFinish() {
    if (theta == thetaTarget) {
      stop = true;
      isRotating = false;
    }
    return stop;
  }
  void trigerRotation() {
    if (!isRotating) {
      for (Box bx : frame.pointedBox) bx.isPointMe = false;
      currentAxis = frame.currentAxis;
      currentRow = frame.currentRow;
      theta = 0;
      stop = false;
    }
  }
  void rotationProcess(Cord a, Cord b) {
    float temp = a.value;
    a.value = a.value*cos(thetaSpeed)-b.value*sin(thetaSpeed);
    b.value = temp*sin(thetaSpeed)+b.value*cos(thetaSpeed);
  }
  void highlightBox() {
    int i = 0;
    if (ligth[0] != null) {
      for (Box b : ligth) b.highlight = false;
    }
    if (frame.stop) {
      switch(frame.currentAxis) {
      case 0:
        for (Box bx : matrix.mtz[frame.currentRow]) {
          bx.highlight = true;
          ligth[i++] = bx;
        }
        break;
      case 1:
        for (Box bx : matrix.mtx[frame.currentRow]) {
          bx.highlight = true;
          ligth[i++] = bx;
        }
        break;
      case 2:
        for (Box bx : matrix.mty[frame.currentRow]) {
          bx.highlight = true;
          ligth[i++] = bx;
        }
        break;
      }
    }
  }
  void rotateBox() {
    if (!stop) {
      isRotating = true;
      switch(currentAxis) {
      case 0:
        for (Box bx : matrix.mtz[currentRow]) {
          rotationProcess(bx.cordX, bx.cordY);
          if (isFinish()) {
            bx.cordX.value = Math.round(bx.cordX.value);
            bx.cordY.value = Math.round(bx.cordY.value);
          }
        }
        break;
      case 1:
        for (Box bx : matrix.mtx[currentRow]) {
          rotationProcess(bx.cordZ, bx.cordY);
          if (isFinish()) {
            bx.cordZ.value = Math.round(bx.cordZ.value);
            bx.cordY.value = Math.round(bx.cordY.value);
          }
        }
        break;
      case 2:
        for (Box bx : matrix.mty[currentRow]) {
          rotationProcess(bx.cordX, bx.cordZ);
          if (isFinish()) {
            bx.cordX.value = Math.round(bx.cordX.value);
            bx.cordZ.value = Math.round(bx.cordZ.value);
          }
        }
        break;
      }
      theta++;
      if (stop) {
        update();
        logic.event = true;
      }
    }
  }
  void boxPointed() {
    int i = 0;
    switch(frame.currentAxis) {
    case 0:
      for (Box bx : matrix.mtz[frame.currentRow]) {
        if (frame.pointer.isPointing(new PVector(Math.round(frame.pointer.pos.x), Math.round
          (frame.pointer.pos.y)), frame.pointer.point, new PVector(bx.cordX.value, bx.cordY.value))) {
          bx.isPointMe = true;
          bx.nullGem = frame.rndgem[abs(i+frame.orderGem[frame.indexPosFrame][frame.pointer.iFrame])];
          frame.pointedBox[i++] = bx;
        } else bx.isPointMe=false;
      }
      break;
    case 1:
      for (Box bx : matrix.mtx[frame.currentRow]) {
        if (frame.pointer.isPointing(new PVector(Math.round(frame.pointer.pos.z), Math.round
          (frame.pointer.pos.y)), frame.pointer.point, new PVector(bx.cordZ.value, bx.cordY.value))) {
          bx.isPointMe = true;
          bx.nullGem = frame.rndgem[abs(i+frame.orderGem[frame.indexPosFrame][frame.pointer.iFrame])];
          frame.pointedBox[i++] = bx;
        } else bx.isPointMe=false;
      }
      break;
    case 2:
      for (Box bx : matrix.mty[frame.currentRow]) {
        if (frame.pointer.isPointing(new PVector(Math.round(frame.pointer.pos.x), Math.round
          (frame.pointer.pos.z)), frame.pointer.point, new PVector(bx.cordX.value, bx.cordZ.value))) {
          bx.isPointMe = true;
          bx.nullGem = frame.rndgem[abs(i+frame.orderGem[frame.indexPosFrame][frame.pointer.iFrame])];
          frame.pointedBox[i++] = bx;
        } else bx.isPointMe = false;
      }
      break;
    }
  }
  class Midi {
    MidiBus bus;
    MidiBus aux;
    Midi(String busName) {
      bus = new MidiBus(this, -1, busName);
      aux = new MidiBus(this, -1, "Bus 1");
    }
    void sendMidi(Box box) {
      bus.sendNoteOn(box.gem.index, box.pitch, 60);
      bus.sendNoteOff(box.gem.index, box.pitch, 0);
      bus.sendControllerChange(box.gem.index, 0, box.speed);
    }
    void specialMessage(Box box, int msg) {
      bus.sendControllerChange(box.gem.index, msg, 0);
    }
    void specialMessage() {
      aux.sendControllerChange(6, 6, 0);
    }
  }
  class Matrix {
    Box[][]mtx;
    Box[][]mty;
    Box[][]mtz;

    Matrix(int nrbox) {
      mtx = new Box[nrbox][nrbox*nrbox];
      mty = new Box[nrbox][nrbox*nrbox];
      mtz = new Box[nrbox][nrbox*nrbox];
    }

    void insert(char axis, Box box, int center, int nrbox) {
      float x = box.cordX.value;
      float y = box.cordY.value;
      float z = box.cordZ.value;
      int index = 0;

      switch(axis) {
      case'x':
        index = (int)((z+center)+((y+center)*nrbox));
        mtx[(int)x+center][index] = box;
        break;
      case 'y':
        index = (int)((x+center)+((z+center)*nrbox));
        mty[(int)y+center][index] = box;
        break;
      case 'z':
        index = (int)((x+center)+((y+center)*nrbox));
        mtz[(int)z+center][index] = box;
        break;
      }
    }
  }
}

Cube cube;
Effect effect;
VirtualRoom room;
InterfaceNext next;
float zoomZ = 10;
long count = 0;
void setup() {
  size(1600, 900, P3D);
  //fullScreen(P3D);
  smooth(4);
  hint(DISABLE_DEPTH_SORT);
  hint(DISABLE_DEPTH_TEST);
  hint(DISABLE_DEPTH_MASK);
  room = new VirtualRoom(1500);
  room.setSpeedRotation(0.001, 0.003, 0.0015);
  effect = new Effect(room);
  effect.setLightSpeed(10/10.0, 10/5.0, 10/4.0);
  effect.setRotateSpeed(0.0001);
  next = new InterfaceNext(5);
  cube = new Cube(effect, 40, 5, new PitchSet(5, new int[]{2, 1, 4, 4}, 12, 48), new SpeedSet(5, 5, 10));
  //cube.midiBusList();
  cube.createMidiBus("cubicle");
}

void draw() {
  if (!effect.gStart.start) effect.gameStart();
  else {
    if (!effect.gOver.endGame) {
      effect.gameDuration();
      if (!effect.eventFill&&!effect.eventCelebrate)normalDraw();
      if (!effect.eventCelebrate)cube.searchForLines();
      if (!effect.gOver.countDown) {
        effect.whenWinBox();
        effect.whenFillBox();
        effect.warning();
      }
      next.display();
    } else {
      effect.gOver.display();
      if(count==0)count=millis();
      if(millis()-count>5000){
        background(0);
        cube.midi.specialMessage();
        noLoop();
      }
    }
  }
}
void normalDraw() {
  background(0);
  effect.lightprocess();
  cube.process();
  pushMatrix();
  translate(width/2, height/2, effect.rotSpace.zoom);
  room.display();
  effect.rotateprocess();
  cube.displayFrame();
  cube.display();
  popMatrix();
}
void roundVector(PVector v) {
  v.set(Math.round(v.x), Math.round(v.y), Math.round(v.z));
}
void keyPressed() {
  if(key=='s'|| key=='S') effect.gStart.canStart=true;
  if (keyCode == UP) {
    effect.rotSpace.dir = 1;
    effect.rotSpace.keypressed = true;
  }
  if (keyCode == DOWN) {
    effect.rotSpace.dir = -1;
    effect.rotSpace.keypressed = true;
  }
  if (keyCode == LEFT)cube.frame.switchRow(-1);
  if (keyCode == RIGHT)cube.frame.switchRow(1);
  if (keyCode == ENTER) cube.trigerRotation();
  if (keyCode == ALT) cube.frame.stop = false;
  if (keyCode == CONTROL) {
    cube.frame.fillpointedBox();
    cube.logic.event = true;
  }
}
void keyReleased() {
  if (keyCode == UP) effect.rotSpace.keypressed = false;
  if (keyCode == DOWN) effect.rotSpace.keypressed = false;
}

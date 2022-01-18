class InterfaceNext {
  Box[] box;
  PGraphics display;
  Gem[] gem;

  InterfaceNext(int nrBox) {
    box = new Box[nrBox];
    int size = 40;
    int gap = 55;
    box[0] = new Box(-2, 0, 0, size, gap, 0, 0);
    box[1] = new Box(-1, 0, 0, size, gap, 0, 0);
    box[2] = new Box(0, 0, 0, size, gap, 0, 0);
    box[3] = new Box(1, 0, 0, size, gap, 0, 0);
    box[4] = new Box(2, 0, 0, size, gap, 0, 0);
    display = createGraphics(350, 100, P3D);
   
  }
  void update() {
    if (gem!=null) {
      for (int i = 0; i < box.length; i++) {
        box[i].gem = gem[i];
        box[i].psbox.setFill(color(box[i].gem.gemColor, 80));
        box[i].psbox.setEmissive(box[i].gem.gemColor);
      }
    }
  }
  void display() {
    lights();
    display.beginDraw();
    display.hint(DISABLE_DEPTH_SORT);
    display.hint(DISABLE_DEPTH_TEST);
    display.hint(DISABLE_DEPTH_MASK);
    display.background(0,0);
    display.stroke(255);
    display.strokeWeight(5);
    display.noFill();
    display.rect(0,0,display.width,display.height);
    display.translate(display.width/2, display.height/2, ((sin(radians(frameCount+90))+0.5+0.5)*18)-10);
    display.scale(0.5);
    display.rotateY(radians(frameCount/2));

    for (Box bx : box) {
      bx.display(display);
    }
    display.endDraw();
    image(display, 0, 0);
  }
}

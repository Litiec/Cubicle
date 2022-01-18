class Box {
  Gem gem;
  Gem nullGem;
  PShape psbox;
  color initColor;
  Cord cordX, cordY, cordZ;
  int size, gap, pitch, speed;
  boolean isPointMe, highlight;
  color pointed;
  Box(float x, float y, float z, int size, int gap, int pitch, int speed) {
    cordX = new Cord(x);
    cordY = new Cord(y);
    cordZ = new Cord(z);
    this.size = size;
    this.gap = gap;
    this.pitch = pitch;
    this.speed = speed;
    psbox = createShape(BOX, size);
    psbox.setStroke(false);
    pointed = color(255, 255, 0);
    initColor = genColor(40);
    psbox.setFill(initColor);
    nullGem = new NullGem();
    gem = new NullGem();
  }
  Box(Cord x, Cord y, Cord z, int size, int gap, PShape psbox, Gem gem){
    cordX = new Cord(x.value);
    cordY = new Cord(y.value);
    cordZ = new Cord(z.value);
    this.size = size;
    this.gap = gap;
    this.gem = gem;
    this.psbox = psbox;
    nullGem = new NullGem();
  }
  Box(Box copy){
    this(copy.cordX, copy.cordY,copy.cordZ, copy.size, copy.gap,copy.psbox,copy.gem);
  }
  void display() {
    pushMatrix();
    translate(cordX.value*gap, cordY.value*gap, cordZ.value*gap);
    shape(psbox);
    if (gem instanceof NullGem==false)shape(gem.getGem());
    if (nullGem instanceof NullGem ==false)shape(nullGem.getGem());
    popMatrix();
  }
  void display(PGraphics pg){
    pg.beginDraw();
    pg.pushMatrix();
    pg.translate(cordX.value*gap, cordY.value*gap, cordZ.value*gap);
    pg.shape(psbox);
    if (gem instanceof NullGem==false)pg.shape(gem.getGem());
    if (nullGem instanceof NullGem ==false)pg.shape(nullGem.getGem());
    pg.popMatrix();
  }
  void process() {
    if (isPointMe)whenIsPointed();
    else {
      whenIsnotPointed();
      if(highlight) whenHighLighted();
    }
  }
  void linkGem(){
    this.gem = nullGem;
  }
  void reset(){
    gem = new NullGem();
  }
  void whenHighLighted(){
    psbox.setStroke(true);
    psbox.setStrokeWeight(1);
    psbox.setStroke(color((float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255),(float)Math.floor(Math.random()*255)));
  }
  void whenIsPointed() {
    psbox.setFill(color(nullGem.gemColor,80));
    psbox.setEmissive(nullGem.gemColor);
    psbox.setStroke(true);
    psbox.setStrokeWeight(2);
    psbox.setStroke(color(255, 255, 0, 200));
  }
  void whenIsnotPointed() {
    psbox.setStroke(false);
    if(gem instanceof NullGem == false){
      psbox.setFill(color(gem.gemColor,80));
      psbox.setEmissive(gem.gemColor);
    }else{
      psbox.setFill(initColor);
      psbox.setEmissive(0);
    }
    nullGem = new NullGem();
  }
  color genColor(int alpha) {
    return color(Math.round(Math.random()*100), 0, Math.round(Math.random()*200+55), alpha);
  }
}

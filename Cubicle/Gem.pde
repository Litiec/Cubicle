class Gem {
  PShape psGem;
  int index;
  color gemColor;
  Gem() {
    index = -1;
  }
  Gem(GemType type, int size) {
    index = type.index;
    gemColor = color(type.coulor[0], type.coulor[1], type.coulor[2]);
    psGem = createShape(BOX, size);
    psGem.setStroke(false);
    psGem.setFill(color(gemColor));
    psGem.setEmissive(gemColor);
    psGem.setShininess(5.0);
  }
  PShape getGem() {
    return psGem;
  }
}
class NullGem extends Gem {
  NullGem() {
    super();
  }
}
public enum GemType {
  RED(0, new int[]{255, 0, 0}), GREEN(1, new int[]{0, 255, 0}), BLUE(2, new int[]{0, 191, 255}), YELLOW(3, new int[]{255, 153, 51}), PURPLE(4, new int[]{255, 0, 255});
  int index;
  int[] coulor;
  private GemType(int index, int[]coulor) {
    this.index = index;
    this.coulor = coulor;
  }
}

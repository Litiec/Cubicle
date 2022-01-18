class GameLogic{
  Cube cubeRef;
  Box[]vertical;
  Box[] horizontal;
  boolean event;
  int turns;
  GameLogic(Cube cubeRef){
    this.cubeRef = cubeRef;
    vertical = new Box[cubeRef.nrbox];
    horizontal = new Box[cubeRef.nrbox];
  }
  boolean iterateMatrix(Box[][] bx){
    boolean stop = false;
    boolean found = false;
    for(int i = 0; i < bx.length; i++){
      for(int a = 0; a< bx.length; a++){
        for(int b = 0; b< bx.length; b++){
          vertical[b] = bx[i][b+a*cubeRef.nrbox];
          horizontal[b] = bx[i][b*cubeRef.nrbox+a];
        }
        if(isLine(vertical)){
          sendMidiSpecialMsg(vertical);
          createCopyBoxforEffect(vertical);
          resetBox(vertical);
          found = true;
          stop = true;
          break;
        }else if(isLine(horizontal)){
          sendMidiSpecialMsg(horizontal);
          createCopyBoxforEffect(horizontal);
          resetBox(horizontal);
          found = true;
          stop = true;
          break;
        }
      }
      if(stop) break;
    }
    return found;
  }
  void resetBox(Box[]box){
    for(Box bx : box){
      bx.reset();
    }
  }
  void sendMidiSpecialMsg(Box[] box){
    if(cubeRef.midi!=null)cubeRef.midi.specialMessage(box[0],1);
  }
  void createCopyBoxforEffect(Box[] box){
    for(int i = 0; i<box.length;i++){
      cubeRef.effectRef.winBox[i] = new Box(box[i].cordX,box[i].cordY,box[i].cordZ,box[i].size,box[i].gap,box[i].psbox,box[i].gem);
    }
    cubeRef.effectRef.warningTIME = 0;
    cubeRef.effectRef.targetTIME = 60000;
    cubeRef.effectRef.eventCelebrate = true;
  }
  boolean isLine(Box[] bx){
    boolean result = false;
    int tmp = bx[0].gem.index;
    if(tmp!= -1){
      for(int i =1; i< bx.length; i++){
        if(bx[i].gem.index==-1){
          result = false;
          break;
        }else if(tmp == bx[i].gem.index){
          result = true;
        }else {
          result = false;
          break;
        }
      }
    }
    return result;
  }
}

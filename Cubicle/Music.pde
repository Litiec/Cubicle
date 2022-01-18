class PitchSet {
  int[][]colls;
  PitchSet(int nr_row, int intervals[], int trans, int startPitch) {
    if (intervals.length<nr_row) {
      int[] tmp = new int[nr_row];
      tmp[0] = startPitch+trans*2;
      for (int i = 0; i < intervals.length; i++) {
        tmp[i+1] = tmp[i]+intervals[i];
      }
      int t = trans*-2;
      colls = new int[nr_row][nr_row];
      for (int i = 0; i< colls.length; i++) {
        //println();
        for (int k = 0; k < colls[i].length; k++) {
          colls[i][k] = tmp[k]+t;
          //print(colls[i][k]," ");
        }
        t+=trans;
      }
      //println();
    }
  }
  int getPitch(int y, int z) {
    return colls[y][z];
  }
}
class SpeedSet{
  int[][]colls;
  SpeedSet(int nr_row, int multi, int startSpeed){
    int speed = startSpeed;
    colls = new int[nr_row][nr_row];
    for(int i = 0; i< colls.length;i++){
      //println();
      for(int k = 0; k < colls[i].length; k++){
        colls[i][k] = speed;
        //print(colls[i][k], " ");
        speed+=multi;
      }
    }
    //println();
  }
  int getSpeed(int y, int z){
    return colls[y][z];
  }
}

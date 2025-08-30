
class MatchBoard { final int width; final int height; late List<int> cells;
  MatchBoard(this.width, this.height){ cells = List<int>.filled(width*height, 0); }
  int index(int x,int y)=> y*width + x;
}

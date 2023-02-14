class Ball {
  Player player;
  int stroke;
  boolean sunk;
  boolean past;
  float distance;
  Terrain terrain;

  Ball(Player p, float dist) {
    player = p;
    stroke = 0;
    sunk = false;
    past = false;
    distance = dist;
    terrain = Terrain.TEE;
  }
  
  Ball(Ball b) {
    player = b.player;
    stroke = b.stroke;
    sunk = b.sunk;
    distance = b.distance;
    terrain = b.terrain;
  }
  
  void sunk() { sunk = true; }
}

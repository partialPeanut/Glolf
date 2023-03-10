class PlayerManager {
  int minID = 100000;
  int maxID = 999999;
  ArrayList<Player> allPlayers;
  ArrayList<Player> livePlayers;
  ArrayList<Player> deadPlayers;

  PlayerManager() {
    allPlayers = new ArrayList<Player>();
    livePlayers = new ArrayList<Player>();
    deadPlayers = new ArrayList<Player>();
  }

  void clearAllPlayers() { allPlayers.clear(); }

  void addNewPlayers(int num) {
    for (int i = 0; i < num; i++) {
      addNewPlayer();
    }
  }
  Player addNewPlayer() {
    Player newPlayer = new Player(generateNewID());
    allPlayers.add(newPlayer);
    livePlayers.add(newPlayer);
    return newPlayer;
  }
  
  void killPlayer(Player p) {
    livePlayers.remove(p);
    deadPlayers.add(p);
  }
  
  Player getPlayer(String id) {
    for (Player p : allPlayers) if (p.id == id) return p;
    return null;
  }
  
  ArrayList<Player> chooseRandomLivingPlayers(int num) {
    if (num >= livePlayers.size()) return new ArrayList<Player>(livePlayers);
    
    ArrayList<Player> chosenPlayers = new ArrayList<Player>();
    while (chosenPlayers.size() < num) {
      int idx = int(random(livePlayers.size()));
      Player p = livePlayers.get(idx);
      if (!chosenPlayers.contains(p)) chosenPlayers.add(p);
    }
    return chosenPlayers;
  }
  
  ArrayList<Player> chooseRandomAllPlayers(int num) {
    if (num >= allPlayers.size()) return new ArrayList<Player>(allPlayers);
    
    ArrayList<Player> chosenPlayers = new ArrayList<Player>();
    while (chosenPlayers.size() < num) {
      int idx = int(random(allPlayers.size()));
      Player p = allPlayers.get(idx);
      if (!chosenPlayers.contains(p)) chosenPlayers.add(p);
    }
    return chosenPlayers;
  }

  String generateNewID() {
    boolean isNew = false;
    String newID = "-1";
    while (!isNew) {
      isNew = true;
      int newIDint = int(random(minID, maxID+1));
      newID = "" + newIDint;
      for (Player p : allPlayers) {
        if (p.id == newID) isNew = false;
      }
    }
    return newID;
  }

  void savePlayersToJSON() {
    JSONArray players = new JSONArray();

    int i = 0;
    for (Player p : allPlayers) {
      players.setJSONObject(i, p.toJSON());
      i++;
    }

    saveJSONArray(players, "data/players.json");
  }

  void loadPlayersFromJSON(String filename) {
    clearAllPlayers();
    JSONArray players = loadJSONArray(filename);

    for (int i = 0; i < players.size(); i++) {
      JSONObject player = players.getJSONObject(i);
      allPlayers.add(new Player(player));
    }
  }
}

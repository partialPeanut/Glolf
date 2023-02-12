class VariableDisplayer {
  PApplet applet;
  TourneyManager tourneyManager;
  DisplayType type;

  int x, y, w, h;
  int margin = 10;
  int offset = 4;

  int staticDisplayHeight = 80;
  color staticBgCol = color(50);
  color staticStrokeCol = color(255, 0, 0);
  color staticTextCol = color(255, 0, 0);

  color bgCol = 50;
  color strokeCol = 0;
  color textCol = 255;
  color inactiveTextCol = 160;
  int textSize = 36;

  int varDisplayY, varDisplayH;

  String statsPlaceholder = "---";
  int statsTextLeading = 40;

  String scorePlaceholder = "-";
  int playerListUnitHeight = 48;
  int playerListUnitOffset = 12;
  int playerListTotalHeight;
  float listScrollOffset = 0;
  int scrollSpeed = 60;
  
  GGroup dcbGroup;
  GButton[] displayOptions = new GButton[4];
  int varDisButtonY;
  int varDisButtonH = 40;

  VariableDisplayer(PApplet app, TourneyManager tm, int _x, int _y, int _w, int _h) {
    applet = app;
    type = DisplayType.PLAYER_STATS;
    tourneyManager = tm;

    x = _x;
    y = _y;
    w = _w;
    h = _h;

    varDisplayY = y + staticDisplayHeight + margin;
    varDisplayH = h - staticDisplayHeight - varDisButtonH - margin;

    varDisButtonY = y+h - varDisButtonH;
    
    G4P.setDisplayFont("data/Calibri-Light-48.vlw", G4P.PLAIN, 30);
    GButton.useRoundCorners(false);

    displayOptions[0] = new GButton(applet, x+0*w/4, varDisButtonY, w/4, varDisButtonH, "Player");
    displayOptions[1] = new GButton(applet, x+1*w/4, varDisButtonY, w/4, varDisButtonH, "Hole");
    displayOptions[2] = new GButton(applet, x+2*w/4, varDisButtonY, w/4, varDisButtonH, "Strokes");
    displayOptions[3] = new GButton(applet, x+3*w/4, varDisButtonY, w/4, varDisButtonH, "Tourney");
    
    dcbGroup = new GGroup(applet);
    for (GButton b : displayOptions) dcbGroup.addControl(b);
  }

  void changeType(DisplayType dt) { type = dt; }
  int getPlayerListHeight() { return getHoleControl().balls.size() * playerListUnitHeight - varDisplayH; }
  
  HoleControl getHoleControl() { return tourneyManager.holeControl; }
  Player getCurrentPlayer() { return tourneyManager.currentPlayer(); }

  void scroll(float amount) {
    listScrollOffset = constrain(listScrollOffset-amount*scrollSpeed, -getPlayerListHeight(), 0);
  }

  void display() {
    // Static display box
    fill(staticBgCol);
    stroke(staticStrokeCol);
    strokeWeight(2);
    rectMode(CORNER);
    rect(x, y, w, staticDisplayHeight);

    // Static display text
    fill(staticTextCol);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(nameOf(getCurrentPlayer()), x+margin, y+staticDisplayHeight/2-offset);
    textAlign(RIGHT, CENTER);
    text(strokeOf(getCurrentPlayer()), x+w-margin, y+staticDisplayHeight/2-offset);

    // Var display box
    fill(bgCol);
    stroke(strokeCol);
    rect(x, varDisplayY, w, varDisplayH);

    // Var display contents
    clip(x, varDisplayY, w, varDisplayH);
    switch(type) {
    case PLAYER_STATS:
    case COURSE_STATS:
      displayStats();
      break;
    case HOLE_SCORES:
    case TOURNEY_SCORES:
      displayScores();
      break;
    }
    noClip();
  }

  void displayStats() {
    String text = statsPlaceholder;
    if (type == DisplayType.PLAYER_STATS) text = playerToText(getCurrentPlayer());
    if (type == DisplayType.COURSE_STATS) text = courseToText(getHoleControl().hole);

    fill(textCol);
    textAlign(LEFT);
    textSize(textSize);
    textLeading(statsTextLeading);
    text(text, x+margin, varDisplayY+margin, w-2*margin, varDisplayH-2*margin);
  }

  void displayScores() {
    line(x, varDisplayY+listScrollOffset, x+w, varDisplayY+listScrollOffset);

    IntDict scores;
    switch(type) {
    case HOLE_SCORES:
      scores = getHoleControl().playersAndStrokes();
      break;
    case TOURNEY_SCORES:
      scores = tourneyManager.playersByScores();
      break;
    default:
      scores = null;
    }

    int i = 1;
    for (String id : scores.keys()) {
      int scoreInt = scores.get(id);
      
      if (scoreInt < 0 || id == getCurrentPlayer().id) {
        if (scoreInt < 0) scoreInt *= -1;
        
        if (id == getCurrentPlayer().id) fill(staticTextCol);
        else fill(inactiveTextCol);
      }
      else fill(textCol);
      
      String score = null;
      switch(type) {
        case HOLE_SCORES:
          score = strokeOf(scoreInt);
          break;
        case TOURNEY_SCORES:
          score = scoreOf(scoreInt);
          break;
        default:
          scores = null;
      }

      textSize(textSize);
      textAlign(LEFT, BOTTOM);
      text(nameOf(id), x+margin, varDisplayY+listScrollOffset+margin+i*playerListUnitHeight-playerListUnitOffset);
      textAlign(RIGHT, BOTTOM);
      text(score, x+w-margin, varDisplayY+listScrollOffset+margin+i*playerListUnitHeight-playerListUnitOffset);

      strokeWeight(2);
      stroke(0);
      line(x, varDisplayY+listScrollOffset+i*playerListUnitHeight, x+w, varDisplayY+listScrollOffset+i*playerListUnitHeight);

      i++;
    }
  }

  String nameOf(Player player) {
    return Format.playerToName(player);
  }
  String nameOf(String id) {
    return nameOf(playerManager.getPlayer(id));
  }

  String strokeOf(int strokes) {
    return Format.intToStrokes(strokes);
  }
  String strokeOf(Player player) {
    return strokeOf(getHoleControl().currentStrokeOf(player));
  }

  String scoreOf(int score) {
    return Format.intToScore(score);
  }

  String playerToText(Player player) {
    if (player == null) return statsPlaceholder;
    else return "Name: " + player.firstName + " " + player.lastName +
      "\nGender: " + player.gender +
      "\nCringe: " + player.cringe +
      "\nDumbassery: " + player.dumbassery +
      "\nYeetness: " + player.yeetness +
      "\nTrigonometry: " + player.trigonometry +
      "\nBisexuality: " + player.bisexuality +
      "\nAsexuality: " + player.asexuality +
      "\nScrappiness: " + player.scrappiness +
      "\nCharisma: " + player.charisma +
      "\nAutism: " + player.autism;
  }

  String courseToText(Hole hole) {
    if (hole == null) return statsPlaceholder;
    else return "Current Hole" +
      "\nPar: " + hole.par +
      "\nRoughness: " + hole.roughness +
      "\nHeterosexuality: " + hole.heterosexuality +
      "\nThicc: " + hole.thicc +
      "\nVerdancy: " + hole.verdancy +
      "\nObedience: " + hole.obedience +
      "\nQuench: " + hole.quench +
      "\nThirst: " + hole.thirst;
  }
}

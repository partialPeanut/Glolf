// Tourney: 18 courses of stroke play, sudden death on tie
// Save backup before play
// Save on each step
// Save backup and stop after every course

class TourneyManager {
  Tourney tourney;
  int currentHole;
  HoleControl holeControl;
  GlolfEvent lastEvent;

  IntDict currentScores = new IntDict();

  // Generate a new tourney
  TourneyManager(Tourney t) {
    tourney = t;

    for (Player p : t.players) {
      currentScores.set(p.id, 0);
    }

    currentHole = 0;
    generateNewHole();
  }

  GlolfEvent nextEvent() {
    if (feed.lastEvent() instanceof EventTourneyFinish) exit();
    switch (feed.lastEvent().nextPhase()) {
      case VOID:
        lastEvent = new EventVoid();
        break;
      case TOURNEY_START:
        lastEvent = new EventTourneyStart();
        break;
      case HOLE_SETUP:
        lastEvent = new EventHoleSetup(currentHole, tourney.holes.get(currentHole));
        holeVisualizer.setHole(tourney.holes.get(currentHole));
        generateNewHole();
        break;
      case HOLE_FINISH:
        for (Ball b : holeControl.balls) {
          tourneyManager.currentScores.add(b.player.id, b.stroke);
        }
        boolean last = (currentHole == tourney.holes.size()-1);
        lastEvent = new EventHoleFinish(currentHole, tourney.holes.get(currentHole), last);
        currentHole++;
        break;
      case TOURNEY_FINISH:
        currentScores.sortValues();
        
        int bestScore = 0;
        for (int s : currentScores.values()) {
          bestScore = s;
          break;
        }
        
        ArrayList<Player> winners = new ArrayList<Player>();
        for (String id : currentScores.keys()) {
          if (currentScores.get(id) != bestScore) break;
          else winners.add(playerManager.getPlayer(id));
        }
        lastEvent = new EventTourneyFinish(winners);
        break;
      default:
        lastEvent = holeControl.nextEvent();
        break;
    }
    feed.addEvent(lastEvent);
    println(lastEvent.toText());
    return lastEvent;
  }

  // Create control for next hole
  void generateNewHole() {
    holeControl = new HoleControl(tourney.players, tourney.holes.get(currentHole), lastEvent);
  }

  Player currentPlayer() { return holeControl.currentPlayer(); }
  int currentScoreOf(Player player) { return currentScores.get(player.id); }
  int currentStrokeOf(Player player) { return holeControl.currentStrokeOf(player); }

  IntDict playersByScores() {
    currentScores.sortValues();
    return currentScores;
  }
}

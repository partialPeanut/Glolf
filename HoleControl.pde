// Runs singular holes
// a. Pick an order the players go in
// 1. Introductory message when hole starts
// 2. The players do a round of glolfin
//   i.   On tee, check for ace
//   ii.  Decide the type of hit
//   iii. Do a hit (of weed)
//   iv.  Do a hit (of glolf)
//   v.   The ball go somewhere
// 3. Players that have orgasmed are removed from the order
// 4. Repeat rounds until everyone has came

class HoleControl {
  Hole hole;
  int currentBall = 0;
  StrokeType nextStrokeType;

  HoleControl(Hole h) { hole = h; }
  
  GlolfEvent nextEvent() {
    GlolfEvent lastEvent = feed.lastEvent();
    PlayState playState = lastEvent.playState();
    PlayState newPlayState;
    switch(lastEvent.nextPhase()) {
      case UP_TOP:
        currentBall = 0;
        newPlayState = new PlayState(playState, currentBall);
        
        hole.randomizeWind();
        newPlayState.hole = hole;
        
        boolean last = true;
        for (Ball b : playState.balls) if (!b.sunk) last = false;
        lastEvent = new EventUpTop(newPlayState, last);
        return lastEvent;
        
      case STROKE_TYPE:
        newPlayState = new PlayState(playState, currentBall);
        
        nextStrokeType = Calculation.calculateStrokeType(newPlayState);
        if (nextStrokeType != StrokeType.NOTHING) newPlayState.currentBall.stroke++;
        lastEvent = new EventStrokeType(newPlayState, newPlayState.currentPlayer(), nextStrokeType);
        return lastEvent;
        
      case STROKE_OUTCOME:
        StrokeOutcome so = Calculation.calculateStrokeOutcome(playState, nextStrokeType);
        
        newPlayState = new PlayState(playState);
        Ball ball = newPlayState.currentBall;
        
        switch(so.type) {
          case ACE:
          case SINK:
            orgasm(newPlayState, ball);
            break;
          case FLY:
          case WHIFF:
            if (!so.newTerrain.outOfBounds) {
              if (so.distance > ball.distance) ball.past = !ball.past;
              ball.distance = Calculation.newDistToHole(ball.distance, so.distance, so.angle);
              ball.terrain = so.newTerrain;
            }
            break;
          case NOTHING: break;
        }
        
        if (!ball.sunk) currentBall++;
        boolean returnUpTop = currentBall >= newPlayState.balls.size() || newPlayState.balls.get(currentBall).sunk;
        
        lastEvent = new EventStrokeOutcome(newPlayState, playState, so, nextStrokeType, ball.distance, returnUpTop);
        return lastEvent;
        
      default:
        lastEvent = new EventVoid();
        return lastEvent;
    }
  }
  
  void undoEvent(GlolfEvent e) {
    PlayState playState = e.playState();
    if (e instanceof EventStrokeType) {
      currentBall = (currentBall+playState.balls.size()-1) % playState.balls.size();
    }
  }
  
  void orgasm(PlayState ps, Ball b) {
    b.sunk();
    b.distance = 0;
    b.terrain = Terrain.HOLE;
    ps.balls.remove(b);
    ps.balls.add(b);
  }
}

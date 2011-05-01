package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.Signal;
  
  public class GameState {
    public var finished:Boolean;
    public var gameLost:Boolean;
    public var gameWon:Boolean;
    public var onBegin:Signal;
    public var onEnd:Signal;
    public var onGameLost:Signal;
    public var onGameWon:Signal;
    public var onMonsterKilled:Signal;
    public var onTreasureCollected:Signal;
    public var world:Game;
    
    function GameState(world:Game) {
      this.world = world;
      onBegin = new Signal();
      onEnd = new Signal();
      onGameLost = new Signal();
      onGameWon = new Signal();
      onMonsterKilled = new Signal();
      onTreasureCollected = new Signal();
      
      onMonsterKilled.add(function(monster:Monster):void {
        checkGameLost();
      });
      
      onTreasureCollected.add(function(treasure:Treasure):void {
        checkGameWon();
      });
    }
    
    protected function checkGameLost():void {
      if (gameWon || gameLost) {
        return;
      }
      var warriorsDead:Boolean = true;
      for (var e:Entity = world.typeFirst('warrior'); e; e = e.typeNext) {
        var health:Health = e.getComponent('health') as Health;
        if (e.active && e.collidable && health && health.alive) {
          warriorsDead = false;
          break;
        }
      }
      if (warriorsDead) {
        gameLost = true;
        onGameLost.dispatch();
      }
    }
    
    protected function checkGameWon():void {
      if (gameWon || gameLost) {
        return;
      }
      var treasuresCollected:Boolean = true;
      for (var e:Entity = world.typeFirst('treasure'); e; e = e.typeNext) {
        if (e.active && e.collidable) {
          treasuresCollected = false;
          break;
        }
      }
      if (treasuresCollected) {
        gameWon = true;
        onGameWon.dispatch();
      }
    }
  }
}
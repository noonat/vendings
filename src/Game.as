package {
  import items.*;
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  
  public class Game extends World {
    public var level:Level;
    public var state:GameState;
    public var treasure:Treasure;
    
    function Game(level:Level) {
      add(this.level = level);
      level.createEntities(this);
      state = new GameState(this);
      state.onGameWon.add(function():void {
        trace('winnar!');
      });
      state.onGameLost.add(function():void {
        trace('you lost, broseph');
      });
    }
    
    override public function begin():void {
      super.begin();
      state.onBegin.dispatch();
      if (typeCount('treasure') === 0) {
        trace('WARNING: treasure missing from level');
      }
    }
    
    override public function end():void {
      super.end();
      state.onEnd.dispatch();
      recycleAll();
    }
    
    override public function update():void {
      super.update();
      if (Input.pressed(Key.Z)) {
        var warrior:Warrior = typeFirst('warrior') as Warrior;
        warrior.boon = new WoodenSword();
      }
    }
  }
}

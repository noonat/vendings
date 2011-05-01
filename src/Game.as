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
    
    function Game(level:Level) {
      add(this.level = level);
      level.createEntities(this);
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

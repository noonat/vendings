package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  
  public class Game extends World {
    public var level:Level;
    
    function Game(level:Level) {
      add(this.level = level);
      level.createEntities(this);
    }
  }
}

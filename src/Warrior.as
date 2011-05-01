package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.pathfinding.Path;
  
  public class Warrior extends Entity {
    protected var _health:Health;
    protected var _item:Item;
    protected var _thinkDuration:Number;
    protected var _thinkTimer:Number;
    
    function Warrior() {
      super(0, 0, Image.createRect(Level.TILE, Level.TILE, 0x00ff00));
      (graphic as Image).centerOO();
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      type = 'warrior';
      _thinkDuration = 1;
      _thinkTimer = 0;
      addComponent('health', _health = new Health());
    }
    
    public function get item():Item {
      return _item;
    }
    
    public function set item(value:Item):void {
      if (_item != value) {
        _item = value;
        think();
      }
    }
    
    protected function think():void {
      _thinkTimer = _thinkDuration;
      if (_item != null) {
        var level:Level = (world as Game).level;
        var treasure:Treasure = world.typeFirst('treasure') as Treasure;
        var path:Path = level.grid.findPath(x, y, treasure.x, treasure.y);
        while (path != null) {
          if (distanceToPoint(path.x, path.y) >= Level.TILE) {
            moveTowards(path.x, path.y, Level.TILE, 'solid', true);
            break;
          }
          path = path.next;
        }
      }
    }
    
    override public function update():void {
      _thinkTimer -= FP.elapsed;
      if (_thinkTimer <= 0) {
        think();
      }
    }
  }
}

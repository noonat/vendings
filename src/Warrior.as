package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.pathfinding.Path;
  
  public class Warrior extends Monster {
    protected var _item:Item;
    
    function Warrior() {
      super();
      type = 'warrior';
      layer = Layers.WARRIORS;
      _thinkDuration = 0.5;
    }
    
    override public function created():void {
      super.created();
      _color = 0x00ff00;
    }
    
    protected function hitMonster(monster:Monster):void {
      var health:Health = monster.getComponent('health') as Health;
      if (health != null) {
        health.hurt(1, this);
      }
    }
    
    protected function hitSolid(entity:Entity):void {
      
    }
    
    public function get item():Item {
      return _item;
    }
    
    public function set item(value:Item):void {
      if (_item != value) {
        _item = value;
        onThink();
      }
    }
    
    override protected function think():void {
      if (_item != null) {
        var level:Level = (world as Game).level;
        var treasure:Treasure = world.typeFirst('treasure') as Treasure;
        var path:Path = level.grid.findPath(x, y, treasure.x, treasure.y);
        while (path != null) {
          var px:Number = path.x;
          var py:Number = path.y;
          if (distanceToPoint(path.x, path.y) >= Level.TILE) {
            var hit:Entity = collideTypes(['monster', 'solid'], px, py);
            if (hit == null) {
              moveTo(px, py);
            } else if (hit.type == 'monster') {
              hitMonster(hit as Monster);
            } else if (hit.type == 'solid') {
              hitSolid(hit)
            }
            break;
          }
          path = path.next;
        }
      }
    }
  }
}

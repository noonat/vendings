package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.pathfinding.Path;
  
  public class Warrior extends Monster {
    protected var _boon:Item;
    
    function Warrior() {
      super();
      type = 'warrior';
      layer = Layers.WARRIORS;
      _baseStats.damage = 1;
      _baseStats.health = 3;
      _thinkDuration = 0.5;
    }
    
    public function get boon():Item {
      return _boon;
    }
    
    public function set boon(value:Item):void {
      if (_boon !== value) {
        if (_boon !== null) {
          _inventory.remove(_boon);
        }
        _boon = value;
        if (_boon !== null) {
          _inventory.add(_boon);
        }
        onThink();
      }
    }
    
    override public function created():void {
      super.created();
      _boon = null;
      _color = 0x00ff00;
    }
    
    protected function hitMonster(monster:Monster):void {
      var health:Health = monster.getComponent('health') as Health;
      if (health !== null) {
        health.hurt(stats.damage, this);
      }
    }
    
    protected function hitSolid(entity:Entity):void {
      
    }
    
    override protected function think():void {
      if (_boon === null) {
        return;
      }
      var level:Level = (world as Game).level;
      var goal:Entity = world.typeFirst('treasure');
      if (goal === null) {
        return;
      }
      var path:Path = level.grid.findPath(x, y, goal.x, goal.y);
      while (path !== null) {
        var px:Number = path.x;
        var py:Number = path.y;
        if (distanceToPoint(path.x, path.y) >= Level.TILE) {
          var hit:Entity = collideTypes(['monster', 'solid'], px, py);
          if (hit === null) {
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
    
    override public function update():void {
      var hit:Entity = collide('treasure', x, y);
      if (hit) {
        var treasure:Treasure = hit as Treasure;
        treasure.collected(this);
      }
    }
  }
}

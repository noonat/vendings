package {
  import flash.display.BitmapData;
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  
  public class Warrior extends Monster {
    [Embed(source="../assets/warrior.png")]
    static protected const IMAGE:Class;
    
    protected var _boon:Item;
    protected var _wanderX:Number = 0;
    protected var _wanderY:Number = 0;
    
    function Warrior() {
      super();
      type = 'warrior';
      layer = Layers.WARRIORS;
      _baseStats.damage = 1;
      _baseStats.health = 3;
      _collideTypes = ['monster', 'trap', 'warrior', 'solid'];
      _thinkDuration = 0.5;
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      });
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
          beginWander();
        }
        onThink();
      }
    }
    
    protected function beginWander():void {
      _wander = true;
      _wanderAngle = 0;
    }
    
    override public function created():void {
      super.created();
      _boon = null;
      _color = 0xffffff;
    }
    
    override protected function think():void {
      if (_boon !== null) {
        super.think();
      }
    }
    
    override protected function thinkCollide(entity:Entity):Boolean {
      if (entity.type === 'monster') {
        _target = entity;
      } else if (entity.type === 'warrior') {
        thinkMoveTurn();
      }
      return super.thinkCollide(entity);
    }
    
    override public function update():void {
      var hit:Entity = collide('treasure', x, y);
      if (hit) {
        var treasure:Treasure = hit as Treasure;
        treasure.collected(this);
        _wander = false;
      }
    }
  }
}

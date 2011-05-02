package {
  import flash.display.BitmapData;
  import flash.geom.Point;
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Graphic;
  import net.flashpunk.graphics.Image;
  
  public class Warrior extends Monster {
    [Embed(source="../assets/warrior.png")]
    static protected const IMAGE:Class;
    
    protected var _boon:Item;
    protected var _wanderX:Number = 0;
    protected var _wanderY:Number = 0;
    private var _camera:Point = new Point();
    private var _point:Point = new Point();
    
    function Warrior() {
      super();
      type = 'warrior';
      layer = Layers.WARRIORS;
      collidable = false;
      visible = false;
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
          collidable = true;
          visible = true;
          beginWander();
        } else {
          collidable = false;
          visible = false;
          _wander = false;
        }
      }
    }
    
    protected function beginWander():void {
      _wander = true;
      _wanderAngle = 0;
    }
    
    override public function created():void {
      super.created();
      boon = null;
    }
    
    override public function render():void {
      super.render();
      if (_health.alive && _boon !== null) {
        var g:Graphic = _boon.graphic;
        if (g && g.visible) {
          if (g.relative) {
            _point.x = x + _boon.offsetX;
            _point.y = y + _boon.offsetY;
          } else {
            _point.x = _point.y = 0;
          }
          _camera.x = FP.camera.x;
          _camera.y = FP.camera.y;
          g.render(renderTarget ? renderTarget : FP.buffer, _point, _camera);
        }
      }
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

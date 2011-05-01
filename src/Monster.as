package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.pathfinding.Path;
  import net.flashpunk.tweens.misc.Alarm;
  
  public class Monster extends Entity {
    public var stats:Stats;
    protected var _baseStats:Stats;
    protected var _collideTypes:Array;
    protected var _color:uint;
    protected var _health:Health;
    protected var _hurtDuration:Number;
    protected var _hurtTimer:Alarm;
    protected var _image:Image;
    protected var _inventory:Inventory;
    protected var _target:Entity;
    protected var _thinkDuration:Number;
    protected var _thinkTimer:Alarm;
    protected var _wander:Boolean;
    protected var _wanderAngle:Number;
    protected var _wanderCollideAngle:Number;
    
    function Monster() {
      super(0, 0);
      type = 'monster';
      layer = Layers.MONSTERS;
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      
      _collideTypes = ['trap', 'warrior', 'solid'];
      
      _image = Image.createRect(Level.TILE, Level.TILE, 0xffffff);
      _image.centerOO();
      addGraphic(_image);
      
      stats = new Stats();
      _baseStats = new Stats();
      _baseStats.damage = 1;
      _baseStats.health = 5;
      calcStats();
      
      _health = new Health(stats.health);
      _health.onHurt.add(onHurt);
      _health.onKilled.add(onKilled);
      _health.recycleKilled = false;
      addComponent('health', _health);
      
      _inventory = new Inventory();
      _inventory.onAdded.add(onItemAdded);
      _inventory.onRemoved.add(onItemRemoved);
      addComponent('inventory', _inventory);
      
      _hurtDuration = 0.5;
      _hurtTimer = new Alarm(0, onHurtFinished);
      addTween(_hurtTimer);
      
      _thinkDuration = 0.5;
      _thinkTimer = new Alarm(0, onThink);
      addTween(_thinkTimer);
      
      _wander = false;
      _wanderAngle = 0;
      _wanderCollideAngle = 90;
    }
    
    protected function calcStats():void {
      stats.reset();
      stats.add(_baseStats);
      if (_inventory) {
        for each (var item:Item in _inventory.items) {
          stats.add(item.stats);
        }
      }
      if (_health) {
        var percent:Number = _health.healthPercent;
        _health.maxHealth = stats.health;
        _health.health = _health.maxHealth * percent;
      }
    }
    
    protected function canAttack(entity:Entity):Boolean {
      if (entity === null) {
        return false;
      }
      var health:Health = entity.getComponent('health') as Health;
      if (health === null || health.dead) {
        return false;
      }
      var x:Number = this.x - originX;
      var y:Number = this.y - originY;
      var distanceX:Number = FP.distanceRects(
        x, y, width, height,
        entity.x - entity.originX, y, entity.width, entity.height);
      if (distanceX > stats.range * Level.TILE) {
        return false;
      }
      var distanceY:Number = FP.distanceRects(
        x, y, width, height,
        x, entity.y - entity.originY, entity.width, entity.height);
      if (distanceY > stats.range * Level.TILE) {
        return false;
      }
      return true;
    }
    
    override public function created():void {
      super.created();
      collidable = true;
      _color = 0x0000ff;
      _hurtTimer.reset(0.01);
      _thinkTimer.reset(0.01);
      calcStats();
    }
    
    protected function onHurt(damage:Number, hurter:Entity):void {
      _hurtTimer.reset(_hurtDuration);
      if (hurter !== null) {
        var health:Health = hurter.getComponent('health') as Health;
        if (health !== null && health.alive) {
          _target = hurter;
        }
      }
    }
    
    protected function onHurtFinished():void {
      _image.color = _color;
    }
    
    protected function onItemAdded(item:Item):void {
      calcStats();
    }
    
    protected function onItemRemoved(item:Item):void {
      calcStats();
    }
    
    protected function onKilled(killer:Entity):void {
      collidable = false;
      _color = 0x000000;
      _thinkTimer.reset(0);
    }
    
    protected function onThink():void {
      _thinkTimer.reset(_thinkDuration);
      think();
    }
    
    override public function render():void {
      if (_hurtTimer.active) {
        _image.color = FP.colorLerp(_color, 0xff0000, 1.0 - _hurtTimer.percent)
      }
      super.render();
    }
    
    protected function think():void {
      thinkMove();
      if (_target !== null) {
        thinkAttack();
      }
    }
    
    protected function thinkAttack():void {
      if (canAttack(_target)) {
        (_target.getComponent('health') as Health).hurt(stats.damage, this);
      } else {
        _target = null;
      }
    }
    
    protected function thinkCollide(hit:Entity):Boolean {
      if (hit.type === 'solid') {
        _wanderAngle = FP.normalizeAngle(_wanderAngle + _wanderCollideAngle);
      }
      return true;
    }
    
    protected function thinkMove():Boolean {
      var moved:Boolean = false;
      if (_target !== null) {
        var level:Level = (world as Game).level;
        var path:Path = level.grid.findPath(x, y, _target.x, _target.y);
        while (path !== null) {
          if (distanceToPoint(path.x, path.y) >= Level.TILE) {
            moved = thinkMoveStep(path.x, path.y);
            break;
          }
          path = path.next;
        }
      } else if (_wander) {
        FP.angleXY(FP.point, _wanderAngle, Level.TILE, x, y);
        moved = thinkMoveStep(FP.point.x, FP.point.y);
      }
      return moved;
    }
    
    protected function thinkMoveStep(x:Number, y:Number):Boolean {
      var hit:Entity = collideTypes(_collideTypes, x, y);
      if (hit === null || !thinkCollide(hit)) {
        moveTo(x, y);
        return true;
      } else {
        return false;
      }
    }
  }
}

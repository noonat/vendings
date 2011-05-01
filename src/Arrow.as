package {
  import items.WoodenShield;
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.tweens.motion.LinearMotion;
  
  public class Arrow extends Entity {
    protected var _damage:Number;
    protected var _motion:LinearMotion;
    protected var _target:Entity;
    
    function Arrow() {
      super(0, 0, Image.createRect(2, 2, 0x00ffff));
      (graphic as Image).centerOO();
      setHitbox(2, 2, 1, 1);
      active = true;
      layer = Layers.TRAPS;
      type = 'arrow';
      _motion = new LinearMotion(onMotionFinished);
      addTween(_motion);
    }
    
    protected function onMotionFinished():void {
      if (_target !== null) {
        var inventory:Inventory = _target.getComponent('inventory') as Inventory;
        if (inventory !== null && inventory.hasType('shield')) {
          var monster:Monster = _target as Monster;
          if (monster !== null) {
            monster.blocked(this);
          }
        } else {
          var health:Health = _target.getComponent('health') as Health;
          if (health !== null) {
            health.hurt(isNaN(_damage) ? health.health : _damage, this);
          }
        }
        target = null;
      }
      world.recycle(this);
    }
    
    protected function onTargetKilled(killer:Entity):void {
      target = null;
    }
    
    
    public function shoot(startX:Number, startY:Number, target:Entity, damage:Number=NaN):void {
      if (target !== null) {
        this.target = target;
        _damage = damage;
        _motion.setMotion(startX, startY, _target.x, _target.y, 0.2);
      }
    }
    
    public function get target():Entity {
      return _target;
    }
    
    public function set target(value:Entity):void {
      if (_target !== value) {
        var health:Health;
        if (_target !== null) {
          health = _target.getComponent('health') as Health;
          if (health !== null) {
            health.onKilled.remove(onTargetKilled);
          }
        }
        _target = value;
        if (_target !== null) {
          health = _target.getComponent('health') as Health;
          if (health !== null) {
            health.onKilled.remove(onTargetKilled);
          }
        }
      }
    }
    
    override public function update():void {
      super.update();
      x = _motion.x;
      y = _motion.y;
    }
  }
}

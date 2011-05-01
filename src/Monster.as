package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.tweens.misc.Alarm;
  
  public class Monster extends Entity {
    protected var _color:uint;
    protected var _health:Health;
    protected var _hurtDuration:Number;
    protected var _hurtTimer:Alarm;
    protected var _image:Image;
    protected var _target:Entity;
    protected var _thinkDuration:Number;
    protected var _thinkTimer:Alarm;
    
    function Monster() {
      super(0, 0);
      type = 'monster';
      layer = Layers.MONSTERS;
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      
      _image = Image.createRect(Level.TILE, Level.TILE, 0xffffff);
      _image.centerOO();
      addGraphic(_image);
      
      _health = new Health(3);
      _health.onHurt.add(onHurt);
      _health.onKilled.add(onKilled);
      _health.recycleKilled = false;
      addComponent('health', _health);
      
      _hurtDuration = 0.5;
      _hurtTimer = new Alarm(0, onHurtFinished);
      addTween(_hurtTimer);
      
      _thinkDuration = 0.5;
      _thinkTimer = new Alarm(0, onThink);
      addTween(_thinkTimer);
    }
    
    override public function created():void {
      super.created();
      collidable = true;
      _color = 0x0000ff;
      _hurtTimer.reset(0.01);
      _thinkTimer.reset(0.01);
    }
    
    override public function render():void {
      if (_hurtTimer.active) {
        _image.color = FP.colorLerp(_color, 0xff0000, 1.0 - _hurtTimer.percent)
      }
      super.render();
    }
    
    protected function onHurt(damage:Number, hurter:Entity):void {
      _hurtTimer.reset(_hurtDuration);
      if (hurter != null) {
        var health:Health = hurter.getComponent('health') as Health;
        if (health != null && health.alive) {
          _target = hurter;
        }
      }
    }
    
    protected function onHurtFinished():void {
      _image.color = _color;
    }
    
    protected function onKilled(killer:Entity):void {
      collidable = false;
      _color = 0x000000;
    }
    
    protected function onThink():void {
      _thinkTimer.reset(_thinkDuration);
      think();
    }
    
    protected function think():void {
      
    }
  }
}

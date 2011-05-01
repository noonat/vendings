package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  
  public class Monster extends Entity {
    protected var _health:Health;
    protected var _hurtDuration:Number;
    protected var _hurtTimer:Number;
    protected var _image:Image;
    
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
      _hurtTimer = 0;
    }
    
    override public function created():void {
      super.created();
      collidable = true;
    }
    
    override public function render():void {
      var color:uint = _health.alive ? 0x0000ff : 0x000000;
      if (_hurtTimer > 0) {
        color = FP.colorLerp(color, 0xff0000, _hurtTimer / _hurtDuration)
      }                                     
      _image.color = color;
      super.render();
    }
    
    protected function onHurt(damage:Number, hurter:Entity):void {
      _hurtTimer = _hurtDuration;
    }
    
    protected function onKilled(killer:Entity):void {
      collidable = false;
    }
    
    override public function update():void {
      super.update();
      if (_hurtTimer > 0) {
        _hurtTimer = Math.max(0, _hurtTimer - FP.elapsed);
      }
    }
  }
}

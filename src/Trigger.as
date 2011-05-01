package {
  import net.flashpunk.Entity;
  import net.flashpunk.Signal;
  import net.flashpunk.utils.Draw;
  
  public class Trigger extends Entity {
    public var onTriggered:Signal;
    public var signX:int;
    public var signY:int;
    public var triggerTypes:Array;
    
    function Trigger(x:Number, y:Number, width:Number, height:Number):void {
      super(x, y);
      setHitbox(width, height);
      type = 'trigger';
      active = false;
      visible = false;
      onTriggered = new Signal();
      triggerTypes = ['warrior'];
    }
    
    override public function render():void {
      Draw.rect(x, y, width, height, 0xff00ff);
    }
    
    public function triggered(entity:Entity):void {
      onTriggered.dispatch(this, entity);
    }
  }
}

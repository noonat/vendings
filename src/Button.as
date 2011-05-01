package {
  import net.flashpunk.Entity;
  import net.flashpunk.Signal;
  
  public class Button extends Entity {
    public var anchorEntity:Entity;
    public var anchorPadding:int;
    public var mouseOver:Boolean;
    public var onClicked:Signal;
    public var useHandCursor:Boolean;
    protected var _anchorName:String;
    
    function Button(x:Number=0, y:Number=0, width:Number=1, height:Number=1) {
      super(x, y);
      type = 'button';
      setHitbox(width, height);
      anchorEntity = null;
      anchorPadding = 0;
      mouseOver = false;
      onClicked = new Signal();
      useHandCursor = true;
      _anchorName = null;
    }
    
    override public function added():void {
      super.added();
      if (_anchorName !== null) {
        anchorEntity = world.getInstance(_anchorName);
      }
    }
    
    public function get anchorName():String {
      return _anchorName;
    }
    
    public function set anchorName(value:String):void {
      _anchorName = value === "" ? null : value;
      if (world && _anchorName !== null) {
        anchorEntity = world.getInstance(_anchorName);
      } else {
        anchorEntity = null;
      }
    }
    
    public function get clickable():Boolean {
      if (!collidable || !visible) {
        return false;
      } else if (anchorEntity !== null && !anchorEntity.visible) {
        return false;
      } else {
        return true;
      }
    }
    
    public function clicked():void {
      onClicked.dispatch(this);
    }
    
    override public function render():void {
      if (anchorEntity !== null && !anchorEntity.visible) {
        return;
      }
      super.render();
    }
    
    override public function update():void {
      if (anchorEntity !== null) {
        x = anchorEntity.x - anchorPadding;
        y = anchorEntity.y - anchorPadding;
        setHitbox(
          anchorEntity.width + anchorPadding * 2,
          anchorEntity.height + anchorPadding * 2,
          anchorEntity.originX,
          anchorEntity.originY);
      }
      super.update();
    }
  }
}
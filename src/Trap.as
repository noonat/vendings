package {
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.masks.Grid;
  import net.flashpunk.World;
  
  public class Trap extends Entity {
    [Embed(source="../assets/trap.png")]
    static protected const IMAGE:Class;
    
    protected var _image:Image;
    protected var _triggers:Vector.<Trigger>;
    
    function Trap() {
      super(0, 0);
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      })
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      layer = Layers.ITEMS;
      type = 'trap';
      _triggers = new Vector.<Trigger>();
    }
    
    override public function added():void {
      super.added();
      createTriggers();
    }
    
    protected function createTriggers():void {
      var trigger:Trigger;
      if ((trigger = traceTrigger(-1,  0))) _triggers.push(trigger);
      if ((trigger = traceTrigger( 1,  0))) _triggers.push(trigger);
      if ((trigger = traceTrigger( 0, -1))) _triggers.push(trigger);
      if ((trigger = traceTrigger( 0,  1))) _triggers.push(trigger);
      if (_triggers.length > 0) {
        for each (trigger in _triggers) {
          trigger.onTriggered.add(onTriggered);
          world.add(trigger);
        }
      } else {
        trace('WARNING: no triggers created for trap at', x, ',', y);
      }
    }
    
    protected function onTriggered(trigger:Trigger, entity:Entity):void {
      
    }
    
    override public function removed(world:World):void {
      super.removed(world);
      for each (var trigger:Trigger in _triggers) {
        trigger.onTriggered.remove(onTriggered);
        world.recycle(trigger);
      }
      _triggers.length = 0;
    }
    
    protected function traceDirection(types:Array, signX:int, signY:int, out:Rectangle=null):Entity {
      if (signX === 0 && signY === 0) {
        return null;
      }
      var hit:Entity;
      var grid:Grid = (world as Game).level.grid;
      var gx1:int = Math.floor(x / Level.TILE) + signX;
      var gy1:int = Math.floor(y / Level.TILE) + signY;
      var gx2:int = gx1;
      var gy2:int = gy1;
      while (gx2 >= 0 && gy2 >= 0 && gx2 < grid.columns && gy2 < grid.rows) {
        for each (var type:String in types) {
          hit = world.collideRect(
            type, gx2 * Level.TILE, gy2 * Level.TILE, Level.TILE, Level.TILE);
          if (hit !== null) {
            break;
          }
        }
        if (hit !== null) {
          break;
        }
        gx2 += signX;
        gy2 += signY;
      }
      if (out !== null) {
        out.x = out.y = out.width = out.height = 0;
        if (gx1 !== gx2 || gy1 !== gy2) {
          out.x = (gx1 < gx2 ? gx1 : gx2) * Level.TILE;
          out.y = (gy1 < gy2 ? gy1 : gy2) * Level.TILE;
          out.width = (Math.abs(gx2 - gx1) || 1) * Level.TILE;
          out.height = (Math.abs(gy2 - gy1) || 1) * Level.TILE;
        }
      }
      return hit;
    }
    
    protected function traceTrigger(signX:int, signY:int):Trigger {
      var bounds:Rectangle = new Rectangle();
      traceDirection(['solid'], signX, signY, bounds);
      if (bounds.width > 0 && bounds.height > 0) {
        var trigger:Trigger  = new Trigger(
          bounds.x, bounds.y, bounds.width, bounds.height);
        trigger.signX = signX;
        trigger.signY = signY;
        return trigger;
      } else {
        return null;
      }
    }
  }
}

package {
  import flash.geom.Rectangle;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.masks.Grid;
  import net.flashpunk.World;
  
  public class Trap extends Entity {
    protected var _triggers:Vector.<Trigger>;
    
    function Trap() {
      super(0, 0, Image.createRect(8, 8, 0x00ffff));
      (graphic as Image).centerOO();
      setHitbox(8, 8, 4, 4);
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
    
    protected function traceTrigger(signX:int, signY:int):Trigger {
      if (signX === 0 && signY === 0) {
        return null;
      }
      var grid:Grid = (world as Game).level.grid;
      var gx1:int = Math.floor(x / Level.TILE) + signX;
      var gy1:int = Math.floor(y / Level.TILE) + signY;
      var gx2:int = gx1;
      var gy2:int = gy1;
      while (gx2 >= 0 && gy2 >= 0 && gx2 < grid.columns && gy2 < grid.rows) {
        if (grid.getTile(gx2 * Level.TILE, gy2 * Level.TILE)) {
          break;
        } else {
          gx2 += signX;
          gy2 += signY;
        }
      }
      if (gx1 === gx2 && gy1 === gy2) {
        return null;
      } else {
        var x:Number = (gx1 < gx2 ? gx1 : gx2) * Level.TILE;
        var y:Number = (gy1 < gy2 ? gy1 : gy2) * Level.TILE;
        var w:Number = (Math.abs(gx2 - gx1) || 1) * Level.TILE;
        var h:Number = (Math.abs(gy2 - gy1) || 1) * Level.TILE;
        return new Trigger(x, y, w, h);
      }
    }
  }
}

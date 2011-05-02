package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Item extends Entity {
    public var stats:Stats;
    public var itemName:String;
    public var offsetX:Number;
    public var offsetY:Number;
    protected var _inventory:Inventory;
    
    function Item() {
      super(0, 0);
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      ++originX;
      ++width;
      layer = Layers.ITEMS;
      type = 'item';
      itemName = 'Item';
      stats = new Stats();
    }
    
    public function get inventory():Inventory {
      return _inventory;
    }
    
    public function set inventory(value:Inventory):void {
      _inventory = value;
    }
  }
}

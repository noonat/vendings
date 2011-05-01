package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Item extends Entity {
    public var stats:Stats;
    protected var _inventory:Inventory;
    
    function Item() {
      super(0, 0, Image.createRect(8, 8, 0x00ffff));
      (graphic as Image).centerOO();
      setHitbox(8, 8, 4, 4);
      layer = Layers.ITEMS;
      type = 'item';
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

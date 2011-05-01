package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Item extends Entity {
    function Item() {
      super(0, 0, Image.createRect(8, 8, 0x00ffff));
      (graphic as Image).centerOO();
      setHitbox(8, 8, 4, 4);
      layer = Layers.ITEMS;
      type = 'item';
    }
  }
}

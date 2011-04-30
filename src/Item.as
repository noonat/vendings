package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Item extends Entity {
    function Item() {
      super(0, 0, Image.createRect(16, 16, 0x00ffff));
      (graphic as Image).centerOO();
      setHitbox(16, 16, 8, 8);
      type = 'item';
    }
  }
}

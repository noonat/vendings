package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Vendor extends Entity {
    function Vendor() {
      super(0, 0, Image.createRect(16, 16, 0xff0000));
      (graphic as Image).centerOO();
      setHitbox(16, 16, 8, 8);
    }
  }
}

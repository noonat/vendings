package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Vendor extends Entity {
    function Vendor() {
      super(0, 0, Image.createRect(Level.TILE, Level.TILE, 0xff0000));
      (graphic as Image).centerOO();
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      layer = Layers.WARRIORS;
      type = 'vendor';
    }
  }
}

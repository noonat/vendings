package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Treasure extends Entity {
    function Treasure() {
      super(0, 0, Image.createRect(16, 16, 0xffff00));
      (graphic as Image).centerOO();
      setHitbox(16, 16, 8, 8);
      type = 'treasure';
    }
  }
}

package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Warrior extends Entity {
    function Warrior() {
      super(0, 0, Image.createRect(16, 16, 0x00ff00));
      (graphic as Image).centerOO();
      setHitbox(16, 16, 8, 8);
    }
  }
}

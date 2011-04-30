package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Monster extends Entity {
    function Monster() {
      super(0, 0, Image.createRect(16, 16, 0x0000ff));
      (graphic as Image).centerOO();
      setHitbox(16, 16, 8, 8);
    }
  }
}

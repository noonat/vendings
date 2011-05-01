package {
  import net.flashpunk.components.Health;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Monster extends Entity {
    protected var _health:Health;
    
    function Monster() {
      super(0, 0, Image.createRect(Level.TILE, Level.TILE, 0x0000ff));
      (graphic as Image).centerOO();
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      type = 'monster';
      addComponent('health', _health = new Health());
    }
  }
}

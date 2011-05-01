package {
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Treasure extends Entity {
    function Treasure() {
      super(0, 0, Image.createRect(Level.TILE, Level.TILE, 0xffff00));
      (graphic as Image).centerOO();
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      layer = Layers.ITEMS;
      type = 'treasure';
    }
    
    public function collected(warrior:Warrior):void {
      collidable = false;
      visible = false;
      (world as Game).state.onTreasureCollected.dispatch(this);
    }
  }
}

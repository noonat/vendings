package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Treasure extends Entity {
    [Embed(source="../assets/treasure.png")]
    static protected const IMAGE:Class;
    
    protected var _image:Image;
    
    function Treasure() {
      super(0, 0);
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(IMAGE);
        _image.centerOO();
        graphic = _image;
      });
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      layer = Layers.ITEMS;
      type = 'treasure';
    }
    
    override public function created():void {
      super.created();
      collidable = true;
      visible = true;
    }
    
    public function collected(warrior:Warrior):void {
      collidable = false;
      visible = false;
      (world as Game).state.onTreasureCollected.dispatch(this);
    }
  }
}

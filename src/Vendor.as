package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Image;
  
  public class Vendor extends Entity {
    [Embed(source="../assets/doors.png")]
    static protected const IMAGE:Class;
    
    protected var _image:Image;
    
    function Vendor() {
      super(0, 0);
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      });
      setHitbox(Level.TILE, Level.TILE);
      centerOrigin();
      layer = Layers.WARRIORS;
      type = 'vendor';
    }
  }
}

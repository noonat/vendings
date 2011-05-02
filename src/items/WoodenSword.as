package items {
  import flash.display.BitmapData;
  import net.flashpunk.graphics.Image;
  
  public class WoodenSword extends Item {
    [Embed(source="../../assets/wooden_sword.png")]
    static protected const IMAGE:Class;
    
    protected var _image:Image;
    
    function WoodenSword() {
      super();
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      });
      type = 'sword';
      stats.damage = 1;
      itemName = 'Wooden Sword';
    }
  }
}

package items {
  import flash.display.BitmapData;
  import net.flashpunk.graphics.Image;
  
  public class WoodenShield extends Item {
    [Embed(source="../../assets/wooden_shield.png")]
    static protected const IMAGE:Class;
    
    protected var _image:Image;
    
    function WoodenShield() {
      super();
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      });
      type = 'shield';
      itemName = 'Wooden Shield';
      offsetX = -2;
      offsetY = 0;
    }
  }
}

package {
  import flash.display.BitmapData;
  import net.flashpunk.graphics.Image;
  
  public class Skeleton extends Monster {
    [Embed(source="../assets/skeleton.png")]
    static protected const IMAGE:Class;
    
    function Skeleton() {
      super();
      Assets.getBitmap(IMAGE, function(bitmap:BitmapData):void {
        _image = new Image(bitmap);
        _image.centerOO();
        graphic = _image;
      });
    }
  }
}
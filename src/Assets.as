package {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.media.Sound;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.utils.ByteArray;
  import flash.utils.describeType;
  
  public class Assets {
    static public function getURLRequest(cls:Class):URLRequest {
      var path:String = (describeType(cls).factory.metadata.(@name == 'Embed')
        .arg.(@key == 'source').@value);
      return new URLRequest(path);
    }

    static public function getBitmap(cls:Class, callback:Function):void {
      ENV::debug {
        var loader:Loader = new Loader;
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
          var bitmap:Bitmap = loader.content as Bitmap;
          callback(bitmap.bitmapData);
        });
        loader.load(getURLRequest(cls));
      }
      ENV::release {
        var bitmap:Bitmap = new cls();
        callback(bitmap.bitmapData);
      }
    }

    static public function getBytes(cls:Class, callback:Function):void {
      ENV::debug {
        var loader:URLLoader = new URLLoader;
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, function(event:Event):void {
          callback(loader.data as ByteArray);
        });
        loader.load(getURLRequest(cls));
      }
      ENV::release {
        callback(new cls());
      }
    }

    static public function getSound(cls:Class, callback:Function):void {
      ENV::debug {
        var sound:Sound = new Sound;
        sound.addEventListener(Event.COMPLETE, function(event:Event):void {
          callback(sound);
        });
        sound.load(getURLRequest(cls));
      }
      ENV::release {
        callback(new cls());
      }
    }
    
    static public function getText(cls:Class, callback:Function):void {
      getBytes(cls, function(bytes:ByteArray):void {
        bytes.position = 0;
        callback(bytes.readUTFBytes(bytes.length));
      });
    }
  }
}

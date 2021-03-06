package {
  import flash.display.BitmapData;
  import items.*;
  import net.flashpunk.Engine;
  import net.flashpunk.FP;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  
  [SWF(width="768", height="576", backgroundColor="#000000")]
  public class Main extends Engine {
    [Embed(source="../assets/level_1.png")]
    static protected const LEVEL_1:Class;
    
    [Embed(source="../assets/level_2.png")]
    static protected const LEVEL_2:Class;
    
    [Embed(source="../assets/tileset.png")]
    static protected const TILESET:Class;
    
    protected var _levelIndex:int = 0;
    protected var _levels:Array = [
      LEVEL_1,
      LEVEL_2
    ];
    protected var _levelsItems:Array = [
      [WoodenSword],
      [WoodenSword, WoodenShield]
    ];
    protected var _stamp:int = 0;
    
    function Main() {
      super(256, 192, 60);
      FP.screen.scale = 3;
    }
    
    override public function init():void {
      loadLevel(_levels[0]);
    }
    
    public function loadLevel(cls:Class):void {
      _levelIndex = _levels.indexOf(cls);
      trace('Loading level', _levelIndex, '-', cls);
      var itemClasses:Array = _levelsItems[_levelIndex];
      itemClasses ||= [WoodenSword];
      var stamp:int = ++_stamp;
      var data:BitmapData = null;
      var tileset:BitmapData = null;
      Assets.getBitmap(cls, function(bitmap:BitmapData):void {
        data = bitmap;
        if (_stamp === stamp && tileset !== null) {
          loadLevelFinish(data, tileset, itemClasses);
        }
      });
      Assets.getBitmap(TILESET, function(bitmap:BitmapData):void {
        tileset = bitmap;
        if (_stamp === stamp && data !== null) {
          loadLevelFinish(data, tileset, itemClasses);
        }
      });
    }
    
    protected function loadLevelFinish(data:BitmapData, tileset:BitmapData, itemClasses:Array):void {
      FP.world = new Game(new Level(data, tileset), itemClasses);
    }
    
    public function loadNextLevel():void {
      _levelIndex = (_levelIndex + 1) % _levels.length;
      loadLevel(_levels[_levelIndex]);
    }
    
    public function loadPrevLevel():void {
      _levelIndex = (_levelIndex - 1) % _levels.length;
      if (_levelIndex < 0) {
        _levelIndex = _levels.length - _levelIndex;
      }
      loadLevel(_levels[_levelIndex]);
    }
    
    public function restartLevel():void {
      loadLevel(_levels[_levelIndex]);
    }
    
    override public function update():void {
      super.update();
      ENV::debug {
        if (Input.pressed(Key.N)) {
          loadNextLevel();
        } else if (Input.pressed(Key.B)) {
          loadPrevLevel();
        } else if (Input.pressed(Key.R)) {
          restartLevel();
        }
      }
    }
  }
}

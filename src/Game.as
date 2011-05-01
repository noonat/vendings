package {
  import items.*;
  import flash.display.BitmapData;
  import flash.ui.MouseCursor;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  
  public class Game extends World {
    public var level:Level;
    public var state:GameState;
    public var treasure:Treasure;
    public var warrior:Warrior;
    public var warriorSpawnX:Number;
    public var warriorSpawnY:Number;
    protected var _button:Button;
    protected var _itemClasses:Array;
    protected var _vendorMenu:VendorMenu;
    
    function Game(level:Level, itemClasses:Array) {
      state = new GameState(this);
      state.onGameWon.add(function():void {
        trace('winnar!');
      });
      state.onGameLost.add(function():void {
        trace('you lost, broseph');
      });
      
      add(this.level = level);
      level.createEntities(this);
      
      _vendorMenu = new VendorMenu(itemClasses, 0, 0, FP.width, FP.height);
      _vendorMenu.onItem.add(onVendorItem);
      _vendorMenu.show();
      add(_vendorMenu);
    }
    
    override public function begin():void {
      super.begin();
      state.onBegin.dispatch();
      
      if (typeCount('treasure') === 0) {
        throw new Error('ERROR: treasure missing from level');
      }
      
      warrior = typeFirst('warrior') as Warrior;
      if (warrior === null) {
        throw new Error('ERROR: warrior missing from level');
      } else {
        warriorSpawnX = warrior.x
        warriorSpawnY = warrior.y;
      }
    }
    
    override public function end():void {
      super.end();
      state.onEnd.dispatch();
      recycleAll();
    }
    
    protected function onVendorItem(item:Item):void {
      warrior.boon = create(item.getClass()) as Item;
      _vendorMenu.hide();
    }
    
    override public function update():void {
      super.update();
      updateButtons();
    }
    
    protected function updateButtons():void {
      var x:Number = mouseX;
      var y:Number = mouseY;
      var bestButton:Button = null;
      var bestLayer:Number = Infinity;
      for (var e:Entity = typeFirst('button'); e; e = e.typeNext) {
        var button:Button = e as Button;
        if (button.layer < bestLayer && button.clickable && button.collidePoint(button.x, button.y, x, y)) {
          bestButton = button;
          bestLayer = button.layer;
        }
      }
      if (_button !== bestButton) {
        if (_button !== null) {
          _button.mouseOver = false;
        }
        _button = bestButton;
        if (_button !== null) {
          _button.mouseOver = true;
        }
      }
      var cursor:String = MouseCursor.AUTO;
      if (_button !== null) {
        if (_button.useHandCursor) {
          cursor = MouseCursor.BUTTON;
        }
        if (Input.mousePressed) {
          _button.clicked();
        }
      }
      Input.mouseCursor = cursor;
    }
  }
}

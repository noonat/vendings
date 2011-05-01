package {
  import flash.geom.Rectangle;
  import net.flashpunk.FP;
  import net.flashpunk.Signal;
  import net.flashpunk.World;
  import net.flashpunk.utils.Draw;
  
  public class VendorMenu extends Button {
    public var item:Item;
    public var onItem:Signal;
    protected var _buttons:Vector.<Button>;
    protected var _items:Vector.<Item>;
    protected var _rect:Rectangle;
    
    function VendorMenu(itemClasses:Array, x:Number, y:Number) {
      super(x, y, 1, 1);
      type = 'menu';
      layer = Layers.MENU;
      
      item = null;
      onItem = new Signal();
      _buttons = new Vector.<Button>();
      _items = new Vector.<Item>();
      for each (var cls:Class in itemClasses) {
        _items.push(new cls() as Item);
      }
      createButtons();
    }
    
    override public function added():void {
      super.added();
      for each (var item:Item in _items) {
        world.add(item);
      }
      for each (var button:Button in _buttons) {
        world.add(button);
      }
    }
    
    protected function createButtons():void {
      var ix:Number = 0;
      var iy:Number = 0;
      _rect = new Rectangle();
      for each (var item:Item in _items) {
        var button:Button = new Button();
        button.anchorEntity = item;
        button.layer = Layers.MENU_BUTTON;
        button.onClicked.add(onItemClicked);
        _buttons.push(button);
        item.x = ix + item.originX;
        item.y = iy + item.originY;
        ix += item.width + Level.TILE;
        _rect.width = Math.max(_rect.width, item.right);
        _rect.height = Math.max(_rect.height, item.bottom);
      }
      _rect.x = x - (_rect.width / 2);
      _rect.y = y - (_rect.height / 2);
      for each (item in _items) {
        item.x += _rect.x;
        item.y += _rect.y;
      }
      _rect.inflate(Level.TILE, Level.TILE);
      setHitbox(_rect.width, _rect.height);
    }
    
    public function hide():void {
      visible = false;
      for each (var item:Item in _items) {
        item.visible = false;
      }
    }
    
    protected function onItemClicked(button:Button):void {
      item = button.anchorEntity as Item;
      onItem.dispatch(item);
    }
    
    override public function removed(world:World):void {
      super.removed(world);
      for each (var item:Item in _items) {
        world.remove(item);
      }
      for each (var button:Button in _buttons) {
        world.remove(button);
      }
    }
    
    override public function render():void {
      Draw.rect(_rect.x, _rect.y, _rect.width, _rect.height, 0xff0000, 0.1);
      super.render();
    }
    
    public function show():void {
      visible = true;
      for each (var item:Item in _items) {
        item.visible = true;
      }
    }
  }
}

package {
  import net.flashpunk.Component;
  import net.flashpunk.Signal;
  
  public class Inventory extends Component {
    public var items:Vector.<Item>;
    public var onAdded:Signal;
    public var onRemoved:Signal;
    
    function Inventory() {
      super();
      items = new Vector.<Item>();
      onAdded = new Signal();
      onRemoved = new Signal();
    }
    
    public function add(item:Item):void {
      if (item === null) {
        return;
      }
      if (item.inventory) {
        item.inventory.remove(item);
      }
      if (items.indexOf(item) === -1) {
        items.push(item);
      }
      item.inventory = this;
      onAdded.dispatch(item);
    }
    
    public function clear():void {
      while (items.length > 0) {
        remove(items[0]);
      }
    }
    
    public function has(item:Item):Boolean {
      return items.indexOf(item) !== -1;
    }
    
    public function hasClass(cls:Class):Boolean {
      for each (var item:Item in items) {
        if (item is cls) {
          return true;
        }
      }
      return false;
    }
    
    public function hasType(type:String):Boolean {
      for each (var item:Item in items) {
        if (item.type === type) {
          return true;
        }
      }
      return false;
    }
    
    public function remove(item:Item):void {
      if (item.inventory !== this) {
        return;
      }
      var index:int = items.indexOf(item);
      if (index !== -1) {
        items.splice(index, 1);
      }
      item.inventory = null;
      onRemoved.dispatch(item);
    }
    
    override public function update():void {
      for each (var item:Item in items) {
        if (item.active) {
          item.update();
        }
      }
    }
  }
}

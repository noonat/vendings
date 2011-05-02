package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  
  public class Level extends Entity {
    static public const TILE:uint = 8;
    static protected const COLOR_EMPTY:uint = 0xffffffff;
    static protected const COLOR_SOLID:uint = 0xff000000;
    static protected const COLOR_VENDOR:uint = 0xffff0000;
    static protected const COLOR_WARRIOR:uint = 0xff00ff00;
    static protected const COLOR_SKELETON:uint = 0xff0000ff;
    static protected const COLOR_TREASURE:uint = 0xffffff00;
    static protected const COLOR_ARROW_TRAP:uint = 0xff00ffff;
    static protected const DATA_TILE:uint = 8;
    
    public var grid:PathGrid;
    public var tilemap:Tilemap;
    protected var _entities:Vector.<LevelEntity>;
    protected var _tileset:BitmapData;
    
    function Level(data:BitmapData, tileset:BitmapData) {
      type = 'solid';
      layer = Layers.LEVEL;
      _entities = new Vector.<LevelEntity>();
      _tileset = tileset;
      graphic = tilemap = new Tilemap(
        tileset, data.width * TILE, data.height * TILE, TILE, TILE);
      tilemap.usePositions = true;
      loadData(data);
      mask = grid = tilemap.createGrid([1], PathGrid) as PathGrid;
      grid.usePositions = true;
    }
    
    public function createEntities(world:World):void {
      for each (var levelEntity:LevelEntity in _entities) {
        var entity:Entity = world.create(levelEntity.cls);
        entity.x = levelEntity.x + entity.originX;
        entity.y = levelEntity.y + entity.originY;
      }
    }
    
    protected function loadData(data:BitmapData):void {
      tilemap.setRect(0, 0, tilemap.width, tilemap.height, 0);
      for (var dy:uint = 0; dy < data.height; ++dy) {
        var y:uint = dy * DATA_TILE;
        for (var dx:uint = 0; dx < data.width; ++dx) {
          var x:uint = dx * DATA_TILE;
          var color:uint = data.getPixel32(dx, dy);
          switch (color) {
            case COLOR_EMPTY:
              break;
            
            case COLOR_SOLID:
              tilemap.setTile(x, y, 1);
              break;
            
            case COLOR_VENDOR:
              _entities.push(new LevelEntity(Vendor, x, y))
              break;
            
            case COLOR_WARRIOR:
              _entities.push(new LevelEntity(Warrior, x, y));
              break;
            
            case COLOR_SKELETON:
              _entities.push(new LevelEntity(Skeleton, x, y));
              break;
            
            case COLOR_TREASURE:
              _entities.push(new LevelEntity(Treasure, x, y));
              break;
            
            case COLOR_ARROW_TRAP:
              tilemap.setTile(x, y, 1);
              _entities.push(new LevelEntity(ArrowTrap, x, y));
              break;
            
            default:
              trace('Unknown color', color.toString(16), 'at', x, y);
              break;
          }
        }
      }
    }
  }
}

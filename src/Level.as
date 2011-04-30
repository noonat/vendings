package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  
  public class Level extends Entity {
    static protected const COLOR_EMPTY:uint = 0xffffffff;
    static protected const COLOR_SOLID:uint = 0xff000000;
    static protected const COLOR_VENDOR:uint = 0xffff0000;
    static protected const COLOR_WARRIOR:uint = 0xff00ff00;
    static protected const COLOR_MONSTER:uint = 0xff0000ff;
    static protected const COLOR_TREASURE:uint = 0xffffff00;
    static protected const DATA_TILE_WIDTH:uint = 8;
    static protected const DATA_TILE_HEIGHT:uint = 8;
    static protected const TILE_WIDTH:uint = 8;
    static protected const TILE_HEIGHT:uint = 8;
    
    public var grid:PathGrid;
    public var tilemap:Tilemap;
    public var tileWidth:uint;
    public var tileHeight:uint;
    protected var _entities:Vector.<LevelEntity>;
    protected var _tileset:BitmapData;
    
    function Level(data:BitmapData, tileset:BitmapData) {
      type = 'solid';
      _entities = new Vector.<LevelEntity>();
      _tileset = tileset;
      graphic = tilemap = new Tilemap(tileset,
        data.width * DATA_TILE_WIDTH, data.height * DATA_TILE_HEIGHT,
        TILE_WIDTH, TILE_HEIGHT);
      loadData(data);
      mask = grid = tilemap.createGrid([1], PathGrid) as PathGrid;
      tileWidth = TILE_WIDTH;
      tileHeight = TILE_HEIGHT;
    }
    
    public function createEntities(world:World):void {
      for each (var levelEntity:LevelEntity in _entities) {
        var entity:Entity = world.create(levelEntity.cls);
        entity.x = levelEntity.x + entity.originX;
        entity.y = levelEntity.y + entity.originY;
      }
    }
    
    protected function loadData(data:BitmapData):void {
      tilemap.setRect(0, 0, tilemap.columns, tilemap.rows, 0);
      for (var dy:uint = 0; dy < data.height; ++dy) {
        var y:uint = dy * DATA_TILE_HEIGHT;
        var row:uint = uint(y / TILE_HEIGHT);
        for (var dx:uint = 0; dx < data.width; ++dx) {
          var x:uint = dx * DATA_TILE_WIDTH;
          var col:uint = uint(x / TILE_WIDTH);
          var color:uint = data.getPixel32(dx, dy);
          switch (color) {
            case COLOR_EMPTY:
              break;
            
            case COLOR_SOLID:
              tilemap.setTile(col, row, 1);
              break;
            
            case COLOR_VENDOR:
              _entities.push(new LevelEntity(Vendor, x, y))
              break;
            
            case COLOR_WARRIOR:
              _entities.push(new LevelEntity(Warrior, x, y));
              break;
            
            case COLOR_MONSTER:
              _entities.push(new LevelEntity(Monster, x, y));
              break;
            
            case COLOR_TREASURE:
              _entities.push(new LevelEntity(Treasure, x, y));
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

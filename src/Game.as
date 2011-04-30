package {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.pathfinding.PathGrid;
  import net.flashpunk.World;
  
  public class Game extends World {
    static protected const COLOR_EMPTY:uint = 0xffffffff;
    static protected const COLOR_SOLID:uint = 0xff000000;
    static protected const COLOR_PLAYER:uint = 0xffff0000;
    static protected const COLOR_WARRIOR:uint = 0xff00ff00;
    static protected const COLOR_MONSTER:uint = 0xff0000ff;
    static protected const COLOR_TREASURE:uint = 0xffffff00;
    
    protected var _grid:PathGrid;
    protected var _level:Entity;
    protected var _tilemap:Tilemap;
    protected var _tileset:BitmapData;
    
    function Game(level:BitmapData, tileset:BitmapData) {
      _tileset = tileset;
      _tilemap = new Tilemap(
        tileset, (level.width / 2) * 16, (level.height / 2) * 16, 16, 16);
      loadFromColors(level);
      _grid = _tilemap.createGrid([1], PathGrid) as PathGrid;
      _level = new Entity(0, 0, _tilemap, _grid);
      _level.type = 'solid';
      add(_level);
    }
    
    protected function loadFromColors(level:BitmapData):void {
      for (var y:uint = 0; y < level.height; ++y) {
        var row:uint = uint(y / 2);
        for (var x:uint = 0; x < level.width; ++x) {
          var col:uint = uint(x / 2);
          var color:uint = level.getPixel32(x, y);
          switch (color) {
            case COLOR_EMPTY:
              _tilemap.setTile(col, row, 0);
              break;
            
            case COLOR_SOLID:
              _tilemap.setTile(col, row, 1);
              break;
            
            case COLOR_PLAYER:
              break;
            
            case COLOR_WARRIOR:
              break;
            
            case COLOR_MONSTER:
              break;
            
            case COLOR_TREASURE:
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
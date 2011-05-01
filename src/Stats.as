package {
  public class Stats {
    public var damage:Number;
    public var health:Number;
    public var range:uint;
    
    function Stats() {
      reset();
    }
    
    public function add(stats:Stats):void {
      damage += stats.damage;
      health += stats.health;
      range += stats.range;
    }
    
    public function reset():void {
      damage = 0;
      health = 0;
      range = 0;
    }
  }
}

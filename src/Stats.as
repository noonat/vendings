package {
  public class Stats {
    public var damage:Number;
    public var health:Number;
    
    function Stats() {
      reset();
    }
    
    public function add(stats:Stats):void {
      damage += stats.damage;
      health += stats.health;
    }
    
    public function reset():void {
      damage = 0;
      health = 0;
    }
  }
}

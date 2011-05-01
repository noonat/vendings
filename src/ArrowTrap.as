package {
  import net.flashpunk.Entity;
  
  public class ArrowTrap extends Trap {
    override protected function onTriggered(trigger:Trigger, entity:Entity):void {
      var arrow:Arrow = world.create(Arrow) as Arrow;
      arrow.shoot(x, y, entity);
    }
  }
}

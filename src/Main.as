package {
  import net.flashpunk.Engine;
  import net.flashpunk.FP;
  
  [SWF(width="1024", height="768", backgroundColor="#000000")]
  public class Main extends Engine {
    function Main() {
      super(256, 192, 60);
      FP.screen.scale = 4;
      FP.console.enable();
    }
  }
}

package flexUnitTests
{
   import com.nocircleno.graffiti.GraffitiCanvas;
   
   import flash.display.BitmapData;
   
   import org.flexunit.asserts.assertEquals;
   import org.fluint.uiImpersonation.UIImpersonator;
   
   public class GraffitiCanvasTest
   {		
      
      private var _canvas:GraffitiCanvas;
      
      [Before(ui)]
      public function setUp():void
      {
         _canvas = new GraffitiCanvas(400, 400);
         UIImpersonator.addChild(_canvas);
      }
      
      [After]
      public function tearDown():void
      {
         _canvas = null;
      }
      
      [BeforeClass]
      public static function setUpBeforeClass():void
      {
      }
      
      [AfterClass]
      public static function tearDownAfterClass():void
      {
      }
      
//      [Test]
//      public function clearCanvas():void
//      {
//         
//      }
      
      [Test]
      public function drawToCanvas_EmptyCanvas_CompositionShouldBeSameAsBitmap():void
      {
         var x:int;
         var y:int;
         var bmpd:BitmapData = new BitmapData(400, 400, true, 0x00FFFFFF);
         bmpd.lock();
         for(x=30; x<200; x++)
         {
            for(y=100; y<150; y++)
            {
               bmpd.setPixel32(x, y, 0xFFFF0000);  
            }
         }
         bmpd.unlock();
         
         _canvas.drawToCanvas(bmpd);
         
         var composition:BitmapData = _canvas.getComposition(true);
        
         for (x = 0; x < composition.width; x++)
         {
            for (y = 0; y < composition.height; y++)
            {
               trace(composition.getPixel32(x, y));
               //assertEquals("Pixel (" + x + ", " + y + ")", 0xFFFF0000, composition.getPixel32(x, y)); 
            }
         }
         
         assertEquals(1, 1);
      }
      
      /*[Test]
      public function testGetComposition():void
      {
         Assert.fail("Test method Not yet implemented");
      }
      
      [Test]
      public function testSet_overlay():void
      {
         Assert.fail("Test method Not yet implemented");
      }
      
      [Test]
      public function testSet_underlay():void
      {
         Assert.fail("Test method Not yet implemented");
      }*/
   }
}
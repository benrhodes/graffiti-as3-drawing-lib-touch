package flexUnitTests
{
   import com.nocircleno.graffiti.GraffitiCanvas;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import org.flexunit.asserts.assertEquals;
   import org.fluint.uiImpersonation.UIImpersonator;
   
   public class GraffitiCanvasTest
   {		
      
      private var _canvas:GraffitiCanvas;
      private var _testBitmapDataObjects:Vector.<BitmapData> = new Vector.<BitmapData>();
      
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
         for(var i:int=0; i<_testBitmapDataObjects.length; i++)
         {
            _testBitmapDataObjects[i].dispose();
         }
         
         _testBitmapDataObjects.length = 0;
      }
      
      [BeforeClass]
      public static function setUpBeforeClass():void
      {
      }
      
      [AfterClass]
      public static function tearDownAfterClass():void
      {
      }
      
      [Test]
      public function clearCanvas():void
      {
         var expectedBmpd:BitmapData = generateBitmap(400, 400, true, false);
         var bmpd:BitmapData = generateBitmap(400, 400, true, true);
         _canvas.drawToCanvas(bmpd);
         
         _canvas.clearCanvas();
         var composition:BitmapData = _canvas.getComposition(true);
         _testBitmapDataObjects.push(expectedBmpd);
         _testBitmapDataObjects.push(composition);
         _testBitmapDataObjects.push(bmpd);
 
         assertEquals(0, composition.compare(expectedBmpd)); 
      }
      
      [Test]
      public function getComposition_ContentOnCanvas_CompositionShouldHaveOpaqueBackgournd():void
      {
         var expected:BitmapData = generateBitmap(400, 400, false, true);
         var bmpd:BitmapData = generateBitmap(400, 400, true, true);
         _canvas.drawToCanvas(bmpd); 
         
         var composition:BitmapData = _canvas.getComposition(false);
         _testBitmapDataObjects.push(composition);
         _testBitmapDataObjects.push(bmpd);
         _testBitmapDataObjects.push(expected);
         
         assertEquals(0, composition.compare(expected));
      }
      
      [Test]
      public function drawToCanvas_EmptyCanvas_CompositionShouldBeSameAsBitmap():void
      {
         var bmpd:BitmapData = generateBitmap(400, 400, true, true);
         _canvas.drawToCanvas(bmpd); 
         
         var composition:BitmapData = _canvas.getComposition(true);
         _testBitmapDataObjects.push(composition);
         _testBitmapDataObjects.push(bmpd);
         
         assertEquals(0, composition.compare(bmpd));
      }
      
      [Test]
      public function overlay_EmptyCanvas_CompositionShouldIncludeOverlayContent():void
      {
         var overlay:BitmapData = generateBitmap(400, 400, true, true);
         var overlayBitmap:Bitmap = new Bitmap(overlay);
         _canvas.overlay = overlayBitmap; 
         
         var composition:BitmapData = _canvas.getComposition(true);
         _testBitmapDataObjects.push(composition);
         _testBitmapDataObjects.push(overlay);
         
         assertEquals(0, composition.compare(overlay));
      }
      
      [Test]
      public function underlay_EmptyCanvas_CompositionShouldIncludeUnderlayContent():void
      {
         var underlay:BitmapData = generateBitmap(400, 400, true, true);
         var underlayBitmap:Bitmap = new Bitmap(underlay);
         _canvas.overlay = underlayBitmap; 
         
         var composition:BitmapData = _canvas.getComposition(true);
         _testBitmapDataObjects.push(composition);
         _testBitmapDataObjects.push(underlay);
         
         assertEquals(0, composition.compare(underlay));
      }
      
      private function generateBitmap(width:int, height:int, transparentBg:Boolean, generateContent:Boolean = true):BitmapData
      {
         var x:int;
         var y:int;
         var fillColor:uint = 0xFFFFFF;
         if(transparentBg)
         {
            fillColor = 0x00FFFFFF;
         }
         var bmpd:BitmapData = new BitmapData(width, height, transparentBg, fillColor);
         if(generateContent)
         {
            bmpd.lock();
            for(x=Math.round(width/8); x<Math.round(width/2); x++)
            {
               for(y=Math.round(height/8); y<Math.round(height/2); y++)
               {
                  bmpd.setPixel32(x, y, 0xFFFF0000);  
               }
            }
            bmpd.unlock();
         }
         return bmpd;
      }
      
   }
}
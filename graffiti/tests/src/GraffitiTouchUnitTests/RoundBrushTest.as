package GraffitiTouchUnitTests
{
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import com.nocircleno.graffiti.tools.brushes.RoundBrush;
   
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import org.flexunit.asserts.assertEquals;
   
   public class RoundBrushTest
   {		
      
      private var _roundBrush:RoundBrush;
      private var _testBitmapDataObjects:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      [Before]
      public function setUp():void
      {
         _roundBrush = new RoundBrush(20, 0x000000, 1);
      }
      
      [After]
      public function tearDown():void
      {
         _roundBrush = null;
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
      public function apply_TwoInteraction_DrawsCorrectGraphics():void
      {
         var expectedDrawingLayer:Sprite = new Sprite();
         _roundBrush.applyGraphicsStyle(expectedDrawingLayer);
         expectedDrawingLayer.graphics.moveTo(0, 0);
         expectedDrawingLayer.graphics.lineTo(400, 400);
         expectedDrawingLayer.graphics.moveTo(0, 400);
         expectedDrawingLayer.graphics.lineTo(400, 0);
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         expected.draw(expectedDrawingLayer);
         
         var drawingLayer:Sprite = new Sprite();
         _roundBrush.applyGraphicsStyle(drawingLayer);
         
         var interactions:Vector.<InteractionInstance> = new Vector.<InteractionInstance>();
         var interaction:InteractionInstance = new InteractionInstance();
         interaction.addPointToPath(new Point(0, 0));
         interaction.addPointToPath(new Point(400, 400));
         interactions.push(interaction);
         
         var interaction2:InteractionInstance = new InteractionInstance();
         interaction2.addPointToPath(new Point(0, 400));
         interaction2.addPointToPath(new Point(400, 0));
         interactions.push(interaction2);
         
         _roundBrush.apply(drawingLayer, interactions);
         
         var actual:BitmapData = generateBitmap(400, 400, true, false);
         actual.draw(drawingLayer);
         _testBitmapDataObjects.push(expected);
         _testBitmapDataObjects.push(actual);
         
         assertEquals(0, actual.compare(expected));
      }
      
      [Test]
      public function applyGraphicsStyle_SpriteIsEmpty_GraphicsStyleShouldBeApplied():void
      {
         var expectedDrawingLayer:Sprite = new Sprite();
         expectedDrawingLayer.graphics.lineStyle(20, 0x000000, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
         expectedDrawingLayer.graphics.moveTo(0, 0);
         expectedDrawingLayer.graphics.lineTo(400, 400);
         expectedDrawingLayer.graphics.moveTo(0, 400);
         expectedDrawingLayer.graphics.lineTo(400, 0);
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         expected.draw(expectedDrawingLayer);
         
         var drawingLayer:Sprite = new Sprite();
         _roundBrush.applyGraphicsStyle(drawingLayer);
         drawingLayer.graphics.moveTo(0, 0);
         drawingLayer.graphics.lineTo(400, 400);
         drawingLayer.graphics.moveTo(0, 400);
         drawingLayer.graphics.lineTo(400, 0);
  
         var actual:BitmapData = generateBitmap(400, 400, true, false);
         actual.draw(drawingLayer);
         
         _testBitmapDataObjects.push(expected);
         _testBitmapDataObjects.push(actual);
         
         assertEquals(0, actual.compare(expected));
      }
      
      [Test]
      public function applyGraphicsStyle_SpriteHasGraphicsContent_GraphicsShouldBeCleared():void
      {
         var drawingLayer:Sprite = new Sprite();
         drawingLayer.graphics.beginFill(0xff0000, 1);
         drawingLayer.graphics.drawRect(20, 20, 40, 40);
         drawingLayer.graphics.endFill();
         
         _roundBrush.applyGraphicsStyle(drawingLayer);
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         var actual:BitmapData = generateBitmap(400, 400, true, false);
         actual.draw(drawingLayer);
         _testBitmapDataObjects.push(expected);
         _testBitmapDataObjects.push(actual);
         
         assertEquals(0, actual.compare(expected));
      }
      
      [Test]
      public function cacheToBitmap_DrawingLayerHasContent_BitmapShouldContainDrawingLayerContent():void
      {
         var drawingLayer:Sprite = new Sprite();
         drawingLayer.graphics.beginFill(0xff0000, 1);
         drawingLayer.graphics.drawCircle(50, 50, 20);
         drawingLayer.graphics.endFill();
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         expected.draw(drawingLayer);
         
         var actual:BitmapData = generateBitmap(400, 400, true, false);
         _roundBrush.cacheToBitmap(actual, drawingLayer);
         _testBitmapDataObjects.push(expected);
         _testBitmapDataObjects.push(actual);
         
         assertEquals(0, actual.compare(expected));
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
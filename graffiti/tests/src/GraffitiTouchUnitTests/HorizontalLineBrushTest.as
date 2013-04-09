package GraffitiTouchUnitTests
{
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import com.nocircleno.graffiti.tools.brushes.HorizontalLineBrush;
   
   import flash.display.BitmapData;
   import flash.display.GraphicsPathWinding;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import org.flexunit.asserts.assertEquals;
   
   public class HorizontalLineBrushTest
   {		
      
      private var _horizontalLineBrush:HorizontalLineBrush;
      private var _testBitmapDataObjects:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      [Before]
      public function setUp():void
      {
         _horizontalLineBrush = new HorizontalLineBrush(20, 0x000000, 1);
      }
      
      [After]
      public function tearDown():void
      {
         _horizontalLineBrush = null;
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
         var commands:Vector.<int> = new Vector.<int>();
         var drawingData:Vector.<Number> = new Vector.<Number>();
         commands.push(1,2,2,2,2,2,2,1,2,2,2,2,2,2);
         drawingData.push(10,-1.25,410,398.75,410,401.25,390,401.25,-10,1.25,-10,-1.25,10,-1.25,-10,398.75,390,-1.25,410,-1.25,410,1.25,10,401.25,-10,401.25,-10,398.75);
         
         var expectedDrawingLayer:Sprite = new Sprite();
         _horizontalLineBrush.applyGraphicsStyle(expectedDrawingLayer);
         expectedDrawingLayer.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         expected.draw(expectedDrawingLayer);
         
         var drawingLayer:Sprite = new Sprite();
         _horizontalLineBrush.applyGraphicsStyle(drawingLayer);
         
         var interactions:Vector.<InteractionInstance> = new Vector.<InteractionInstance>();
         var interaction:InteractionInstance = new InteractionInstance();
         interaction.addPointToPath(new Point(0, 0));
         interaction.addPointToPath(new Point(400, 400));
         interactions.push(interaction);
         
         var interaction2:InteractionInstance = new InteractionInstance();
         interaction2.addPointToPath(new Point(0, 400));
         interaction2.addPointToPath(new Point(400, 0));
         interactions.push(interaction2);
         
         _horizontalLineBrush.apply(drawingLayer, interactions);
         
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
         expectedDrawingLayer.graphics.beginFill(0x000000, 1);
         expectedDrawingLayer.graphics.drawCircle(50, 50, 20);
         expectedDrawingLayer.graphics.endFill();
         
         var expected:BitmapData = generateBitmap(400, 400, true, false);
         expected.draw(expectedDrawingLayer);
         
         var drawingLayer:Sprite = new Sprite();
         _horizontalLineBrush.applyGraphicsStyle(drawingLayer);
         drawingLayer.graphics.drawCircle(50, 50, 20);
         drawingLayer.graphics.endFill();
  
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
         
         _horizontalLineBrush.applyGraphicsStyle(drawingLayer);
         
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
         _horizontalLineBrush.cacheToBitmap(actual, drawingLayer);
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
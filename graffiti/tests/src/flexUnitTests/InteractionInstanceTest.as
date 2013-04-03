package flexUnitTests
{
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import flash.geom.Point;   
   import org.flexunit.asserts.assertEquals;
   
   public class InteractionInstanceTest
   {		
      
      private var _interactionInstance:InteractionInstance;
      
      [Before]
      public function setUp():void
      {
         _interactionInstance = new InteractionInstance();
         _interactionInstance.init(1);
      }
      
      [After]
      public function tearDown():void
      {
         _interactionInstance = null;
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
      public function addPointToPath_ValidPoint_ShouldBeLastPointInPath():void
      { 
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         assertEquals(20, _interactionInstance.getPathEndPoint().x);
         assertEquals(30, _interactionInstance.getPathEndPoint().y);
      }
      
      [Test]
      public function getInstancePath_TwoPointsOnPath_ReturnsCorrectPointsInOrder():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         var path:Vector.<Point> = _interactionInstance.getInstancePath();
         
         assertEquals(2, path.length);
         assertEquals(0, path[0].x);
         assertEquals(10, path[0].y);
         assertEquals(20, path[1].x);
         assertEquals(30, path[1].y);
      }
      
      [Test]
      public function getPathEndPoint_EmptyPath_ReturnsNull():void
      {         
         var point:Point = _interactionInstance.getPathEndPoint();
         
         assertEquals(null, point);
      }
      
      [Test]
      public function getPathEndPoint_TwoPointsOnPath_ReturnsCorrectPoint():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         var point:Point = _interactionInstance.getPathEndPoint();
         
         assertEquals(20, point.x);
         assertEquals(30, point.y);
      }
      
      [Test]
      public function getPathNextToEndPoint_TwoPointsOnPath_ReturnsCorrectPoint():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         var point:Point = _interactionInstance.getPathNextToEndPoint();
         
         assertEquals(0, point.x);
         assertEquals(10, point.y);
      }
      
      [Test]
      public function getPathNextToEndPoint_OnePointOnPath_ReturnsNull():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         
         var point:Point = _interactionInstance.getPathNextToEndPoint();
         
         assertEquals(null, point);
      }
      
      [Test]
      public function init_ExistingInteraction_ShouldContainNewInstanceId():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         _interactionInstance.init(12);
         
         assertEquals(12, _interactionInstance.interactionId);
      }
      
      [Test]
      public function init_ExistingInteraction_ShouldContainEmptyPath():void
      {
         _interactionInstance.addPointToPath(new Point(0, 10));
         _interactionInstance.addPointToPath(new Point(20, 30));
         
         _interactionInstance.init(12);
         
         assertEquals(0, _interactionInstance.getInstancePath().length);
      }
      
      [Test]
      public function setPendingPointToPath_EmptyPath_PathShouldStillBeEmpty():void
      {
         _interactionInstance.setPendingPointToPath(new Point(2, 3));
         
         assertEquals(0, _interactionInstance.getInstancePath().length);
      }
      
      [Test]
      public function setPendingPointToPath_InitInteraction_PendingPointShouldBeEmpty():void
      {
         _interactionInstance.setPendingPointToPath(new Point(2, 3));
         
         _interactionInstance.init(12);
         
         assertEquals(false, _interactionInstance.writePendingPointToPath());
      }
      
      [Test]
      public function setPendingPointToPath_EmptyPath_WritePendingPointToPathReturnsTrue():void
      {
         _interactionInstance.setPendingPointToPath(new Point(2, 3));
         
         assertEquals(true, _interactionInstance.writePendingPointToPath());
      }
      
      [Test]
      public function writePendingPointToPath_EmptyPath_PathShouldContainPendingPoint():void
      {
         _interactionInstance.setPendingPointToPath(new Point(2, 3));
         _interactionInstance.writePendingPointToPath();
         
         var point:Point = _interactionInstance.getPathEndPoint();
         
         assertEquals(2, point.x);
         assertEquals(3, point.y);
      }
   }
}
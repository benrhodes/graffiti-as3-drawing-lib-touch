package GraffitiTouchUnitTests
{
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import com.nocircleno.graffiti.interaction.InteractiveInstanceObjectPool;
   
   import flexunit.framework.Assert;
   
   import org.flexunit.asserts.assertEquals;
   
   public class InteractiveInstanceObjectPoolTest
   {		
      
      private var _interactiveInstanceObjectPool:InteractiveInstanceObjectPool;
      
      [Before]
      public function setUp():void
      {
         _interactiveInstanceObjectPool = new InteractiveInstanceObjectPool();
      }
      
      [After]
      public function tearDown():void
      {
         _interactiveInstanceObjectPool = null;
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
      public function getInstance_EmptyPool_ReturnsNewInstance():void
      {
         var interactiveInstance:InteractionInstance = _interactiveInstanceObjectPool.getInstance();
         
         assertEquals(-1, interactiveInstance.interactionId);
      }
   
      [Test]
      public function resetCount_TwoInstancesInPool_ShouldReturnFirstInstance():void
      {
         var interactiveInstance1:InteractionInstance = _interactiveInstanceObjectPool.getInstance();
         var interactiveInstance2:InteractionInstance = _interactiveInstanceObjectPool.getInstance();
         interactiveInstance1.init(20);
         interactiveInstance2.init(30);
         
         _interactiveInstanceObjectPool.resetCount();
         
         assertEquals(20, _interactiveInstanceObjectPool.getInstance().interactionId);
      }
   }
}
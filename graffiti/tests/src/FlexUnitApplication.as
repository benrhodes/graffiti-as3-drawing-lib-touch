package
{
   import Array;
   
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageAspectRatio;
   import flash.display.StageScaleMode;
   
   import flexUnitTests.GraffitiCanvasTest;
   import flexUnitTests.GraffitiTouchSuite;
   import flexUnitTests.InteractionInstanceTest;
   import flexUnitTests.InteractiveInstanceObjectPoolTest;
   
   import flexunit.flexui.FlexUnitTestRunnerUIASMobile;
   
   public class FlexUnitApplication extends Sprite
   {
      public function FlexUnitApplication()
      {
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_BORDER;
         stage.setAspectRatio(StageAspectRatio.PORTRAIT);
         onCreationComplete();
      }
      
      private function onCreationComplete():void
      {
         var testRunner:FlexUnitTestRunnerUIASMobile=new FlexUnitTestRunnerUIASMobile(stage.fullScreenWidth, stage.fullScreenHeight);
         testRunner.portNumber=8765; 
         this.addChild(testRunner); 
         testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "GraffitiTouchTests");
      }
      
      public function currentRunTestSuite():Array
      {
         var testsToRun:Array = new Array();
         testsToRun.push(flexUnitTests.GraffitiTouchSuite);
         testsToRun.push(flexUnitTests.GraffitiCanvasTest);
         testsToRun.push(flexUnitTests.InteractionInstanceTest);
         testsToRun.push(flexUnitTests.InteractiveInstanceObjectPoolTest);
         return testsToRun;
      }
   }
}
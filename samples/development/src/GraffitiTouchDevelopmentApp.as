package
{
	import com.nocircleno.graffiti.GraffitiCanvas;
	import com.nocircleno.graffiti.tools.brushes.RoundBrush;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
   [SWF(backgroundColor='#ffffff', frameRate='60')]
	public class GraffitiTouchDevelopmentApp extends Sprite
	{
		public function GraffitiTouchDevelopmentApp()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
		}
		
		private function init():void {
			
			var graffiti:GraffitiCanvas = new GraffitiCanvas(stage.fullScreenWidth, stage.fullScreenHeight);
			addChild(graffiti);
         
         var brush:RoundBrush = new RoundBrush(12, 0xff0000, 1);
         graffiti.brush = brush;
		}
	}
}
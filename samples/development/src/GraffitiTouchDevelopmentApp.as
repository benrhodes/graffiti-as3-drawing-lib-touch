package
{
	import com.nocircleno.graffiti.GraffitiCanvas;
	import com.nocircleno.graffiti.tools.brushes.RoundBrush;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
   [SWF(backgroundColor='#ffffff', frameRate='60')]
	public class GraffitiTouchDevelopmentApp extends Sprite
	{
      
      private var _graffiti:GraffitiCanvas;
      public static var debug_txt:TextField;
      
		public function GraffitiTouchDevelopmentApp()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
		}
		
		private function init():void {
			
         _graffiti = new GraffitiCanvas(stage.fullScreenWidth, stage.fullScreenHeight);
			addChild(_graffiti);
         
         var brush:RoundBrush = new RoundBrush(12, 0xff0000, 1);
         _graffiti.brush = brush;
         
         var clearButton:Sprite = new Sprite();
         clearButton.graphics.beginFill(0x666666, 1);
         clearButton.graphics.drawRoundRect(0, 0, 100, 90, 16, 16);
         clearButton.graphics.endFill();
         clearButton.x = 10;
         clearButton.y = 10;
         addChild(clearButton);
         
         clearButton.addEventListener(MouseEvent.CLICK, clearCanvas);
         
         var fmt:TextFormat = new TextFormat();
         fmt.size = 16;
         
         debug_txt = new TextField();
         debug_txt.width = stage.fullScreenWidth - 10;
         debug_txt.x = 10;
         debug_txt.multiline = true;
         debug_txt.wordWrap = true;
         debug_txt.autoSize = TextFieldAutoSize.LEFT;
         debug_txt.alpha = .5;
         debug_txt.defaultTextFormat = fmt;
         debug_txt.mouseEnabled = false;
         
         debug_txt.y = clearButton.getBounds(this).bottom + 10;
         
         addChild(debug_txt);
         
		}
      
      private function clearCanvas(e:MouseEvent):void
      {
         _graffiti.clearCanvas();
         debug_txt.text = "";
      }
	}
}
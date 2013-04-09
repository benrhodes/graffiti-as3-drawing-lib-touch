package
{
	import com.nocircleno.graffiti.GraffitiCanvas;
	import com.nocircleno.graffiti.tools.brushes.BackwardLineBrush;
	import com.nocircleno.graffiti.tools.brushes.DiamondBrush;
	import com.nocircleno.graffiti.tools.brushes.ForwardLineBrush;
	import com.nocircleno.graffiti.tools.brushes.HorizontalLineBrush;
	import com.nocircleno.graffiti.tools.brushes.RoundBrush;
	import com.nocircleno.graffiti.tools.brushes.SquareBrush;
	import com.nocircleno.graffiti.tools.brushes.VerticalLineBrush;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
   [SWF(backgroundColor='#ffffff', frameRate='60')]
	public class GraffitiTouchDevelopmentApp extends Sprite
	{
      
      private var _graffiti:GraffitiCanvas;
      public static var debug_txt:TextField;
      private var _selectedBrush:LabelButton;
      
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
         
         var clearButton:LabelButton = new LabelButton("Clear");
         clearButton.width = 70;
         clearButton.height = 55;
         clearButton.x = 10;
         clearButton.y = stage.fullScreenHeight - 65;
         addChild(clearButton);
         clearButton.addEventListener(MouseEvent.CLICK, clearCanvas);
         
         var squareBrush:LabelButton = new LabelButton("Sq");
         squareBrush.width = 55;
         squareBrush.height = 55;
         squareBrush.x = 10;
         squareBrush.y = 10;
         addChild(squareBrush);
         
         var backwardLineBrush:LabelButton = new LabelButton("Bl");
         backwardLineBrush.width = 55;
         backwardLineBrush.height = 55;
         backwardLineBrush.x = squareBrush.getBounds(this).right + 10;
         backwardLineBrush.y = 10;
         addChild(backwardLineBrush);
       
         var forwardLineBrush:LabelButton = new LabelButton("Fl");
         forwardLineBrush.width = 55;
         forwardLineBrush.height = 55;
         forwardLineBrush.x = backwardLineBrush.getBounds(this).right + 10;
         forwardLineBrush.y = 10;
         addChild(forwardLineBrush);
    
         var diamondBrush:LabelButton = new LabelButton("Di");
         diamondBrush.width = 55;
         diamondBrush.height = 55;
         diamondBrush.x = forwardLineBrush.getBounds(this).right + 10;
         diamondBrush.y = 10;
         addChild(diamondBrush);
         
         var horizontailLineBrush:LabelButton = new LabelButton("Hl");
         horizontailLineBrush.width = 55;
         horizontailLineBrush.height = 55;
         horizontailLineBrush.x = diamondBrush.getBounds(this).right + 10;
         horizontailLineBrush.y = 10;
         addChild(horizontailLineBrush);
       
         var roundBrush:LabelButton = new LabelButton("Rb");
         roundBrush.width = 55;
         roundBrush.height = 55;
         roundBrush.x = horizontailLineBrush.getBounds(this).right + 10;
         roundBrush.y = 10;
         addChild(roundBrush);
   
         var verticalLineBrush:LabelButton = new LabelButton("Vl");
         verticalLineBrush.width = 55;
         verticalLineBrush.height = 55;
         verticalLineBrush.x = roundBrush.getBounds(this).right + 10;
         verticalLineBrush.y = 10;
         addChild(verticalLineBrush);
         
         squareBrush.name = "square";
         backwardLineBrush.name = "backward"
         forwardLineBrush.name = "forward"
         diamondBrush.name = "diamond"
         horizontailLineBrush.name = "horizontail"
         roundBrush.name = "round"
         verticalLineBrush.name = "vertical"
         
         squareBrush.addEventListener(MouseEvent.CLICK, brushChange);
         backwardLineBrush.addEventListener(MouseEvent.CLICK, brushChange);
         forwardLineBrush.addEventListener(MouseEvent.CLICK, brushChange);
         diamondBrush.addEventListener(MouseEvent.CLICK, brushChange);
         horizontailLineBrush.addEventListener(MouseEvent.CLICK, brushChange);
         roundBrush.addEventListener(MouseEvent.CLICK, brushChange);
         verticalLineBrush.addEventListener(MouseEvent.CLICK, brushChange);
         
		}
      
      private function brushChange(e:MouseEvent):void
      {
         if(_selectedBrush)
         {
            _selectedBrush.setSelected(false);
         }
         
         _selectedBrush = LabelButton(e.currentTarget);
         _selectedBrush.setSelected(true);
         
         switch(e.currentTarget.name)
         {
            case "square":
               _graffiti.brush = new SquareBrush(12, 0xff0000, 1);
               break;
            case "backward":
               _graffiti.brush = new BackwardLineBrush(12, 0xff0000, 1);
               break;
            case "forward":
               _graffiti.brush = new ForwardLineBrush(12, 0xff0000, 1);
               break;
            case "diamond":
               _graffiti.brush = new DiamondBrush(12, 0xff0000, 1);
               break;
            case "horizontail":
               _graffiti.brush = new HorizontalLineBrush(12, 0xff0000, 1);
               break;
            case "round":
               _graffiti.brush = new RoundBrush(12, 0xff0000, 1);
               break;
            case "vertical":
               _graffiti.brush = new VerticalLineBrush(12, 0xff0000, 1);
               break;
         }
         
      }
      
      private function clearCanvas(e:MouseEvent):void
      {
         _graffiti.clearCanvas();
      }
	}
}
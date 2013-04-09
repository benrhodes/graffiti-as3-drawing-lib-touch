package
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class LabelButton extends Sprite
   {
      private var _background:Sprite;
      private var _labelText:String;
      private var _label:TextField;
      
      public function LabelButton(label:String)
      {
         _labelText = label;
         init();
      }
      
      private function init():void
      {
         _background = new Sprite();
         _background.graphics.beginFill(0x333333, 1);
         _background.graphics.drawRect(0, 0, 100, 50);
         _background.graphics.endFill();
         addChild(_background);
         
         var fmt:TextFormat = new TextFormat();
         fmt.size = 16;
         fmt.color = 0xffffff;
         fmt.font = "Helvetica";
         
         _label = new TextField();
         _label.selectable = false;
         _label.autoSize = TextFieldAutoSize.LEFT;
         _label.defaultTextFormat = fmt;
         _label.text = _labelText;
         addChild(_label);
         
         positionLabel();
      }
      
      public function setSelected(selected:Boolean):void
      {
         _background.graphics.clear();
         if(selected)
         { 
            _background.graphics.beginFill(0x330000, 1);
         }
         else
         {
            _background.graphics.beginFill(0x333333, 1);
         }
         _background.graphics.drawRect(0, 0, 100, 50);  
         _background.graphics.endFill();
      }
      
      private function positionLabel():void
      {
         _label.x = (_background.width - _label.width) * 0.5;
         _label.y = (_background.height - _label.height) * 0.5;
      }
      
      public override function set width(value:Number):void
      {
         _background.width = value;
         positionLabel();
      }
      
      public override function get width():Number
      {
         return _background.width;
      }
      
      public override function set height(value:Number):void
      {
         _background.height = value;
         positionLabel();
      }
      
      public override function get height():Number
      {
         return _background.height;
      }
   }
}
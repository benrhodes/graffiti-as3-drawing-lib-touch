﻿/*
*  	Graffiti Touch
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/

/*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/

package com.nocircleno.graffiti {
   
   import com.nocircleno.graffiti.interaction.IInteractionEventManager;
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import com.nocircleno.graffiti.interaction.TouchInteractionEventManager;
   import com.nocircleno.graffiti.tools.brushes.Brush;
   import com.nocircleno.graffiti.tools.ToolMode;
   import com.nocircleno.graffiti.tools.brushes.IBrush;
   import com.nocircleno.graffiti.tools.brushes.RoundBrush;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   /**
    * The GraffitiCanvas Class provides an area on stage to draw in.  It extends
    * the Sprite Class, so you can add it as a child anywhere in the display list.
    * Once you've created an instance of the GraffitiCanvas Class you can assign
    * different tools to the canvas.
    *
    * <p>2.5 Features:
    * <ul>
    *	  <li>Create a drawing area up to 4095x4095 pixels.</li>
    *	  <li>Brush Tool providing 7 different Brush shapes with transparency and blur.</li>
    *     <li>Line Tool providing Solid, Dashed and Dotted lines.</li>
    *     <li>Shape Tool providing Rectangle, Square, Oval and Circle Shapes.</li>
    *     <li>Fill Bucket Tool provides a way to quickly fill a solid area of color with another color.</li>
    *     <li>Text Tool allows you to create, edit and move text on the canvas.</li>
    *	  <li>Add a bitmap or vector image under and/or over the drawing area of the Canvas.</li>
    *     <li>Built in zoom functionality including ability to drag an obscured canvas with the mouse.</li>
    *     <li>Keep and control a history of the drawing allowing undo and redo's</li>
    *     <li>Easily get a copy of your drawing to use with your favorite image encoder.</li>
    * </ul></p>
    * <p>It is up to the developer to implement a UI for these features.
    * </p>
    *
    * @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
    */
   public class GraffitiCanvas extends Sprite {
      
      // display assets		
      private var drawing_layer:Sprite;
      private var container:Sprite;
      private var canvas:Bitmap;
      private var overlay_do:DisplayObject;
      private var underlay_do:DisplayObject;
      
      // private properties
      private var _bmp:BitmapData;
      private var _canvasEnabled:Boolean = true;
      private var _currentBrush:IBrush;
      private var _canvasWidth:uint;
      private var _canvasHeight:uint;
      private var _interactionEventManager:IInteractionEventManager;
      
      /**
       * The <code>GraffitiCanvas</code> constructor.
       * 
       * @param canvasWidth Width of the canvas.
       * @param canvasHeight Height of the canvas.
       * @param numberHistoryLevels Max number of History items to keep, if 0 then no history is kept.
       * @param overlay An optional DisplayObject that can be used as an overlay to the Canvas.  DisplayObject should be partially transparent.
       * @param underlay An optional DisplayObject that can be used as an underlay to the Canvas.
       *
       * @example The following code creates a Graffiti Canvas instance. 
       * <listing version="3.0" >
       * package {
       *
       *		import flash.display.Sprite;
       *		import com.nocircleno.graffiti.GraffitiCanvas;
       *		import com.nocircleno.graffiti.tools.BrushTool;
       *		import com.nocircleno.graffiti.tools.BrushType;
       *		
       *		public class Main extends Sprite {
       *			
       *			public function Main() {
       *				
       *				// create new instance of graffiti canvas, with a width and height of 400 and 10 history levels.
       *				// by default a Brush instance is created inside the GraffitiCanvas Class and assigned as the active tool.
       *				var canvas:GraffitiCanvas = new GraffitiCanvas(400, 400, 10);
       *				addChild(canvas);
       *				
       *				// create a new BrushTool instance, brush size of 8, brush color is Red, fully opaque, no blur and Brush type is Backward line.
       *				var angledBrush:BrushTool = new BrushTool(8, 0xFF0000, 1, 0, BrushType.BACKWARD_LINE);
       *				
       *				// assign the Brush as the active tool used by the Canvas
       *				canvas.activeTool = angledBrush;
       *				
       *			}
       *			
       *		}
       * }
       * </listing>
       * 
       */
      public function GraffitiCanvas(canvasWidth:uint = 100, canvasHeight:uint = 100) {
         
         // set width and height
         _canvasWidth = canvasWidth;
         _canvasHeight = canvasHeight;
         
         init();
      }
      
      private function init():void {
         /////////////////////////////////////////////////
         // Create Default Tool, a Brush
         /////////////////////////////////////////////////
         _currentBrush = new RoundBrush(16, 0x000000, 1);
         
         /////////////////////////////////////////////////
         // Create Canvas Assets
         /////////////////////////////////////////////////
         drawing_layer = new Sprite();
         container = new Sprite();
         
         _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
         canvas = new Bitmap(_bmp, "auto", false);
         
         // add to display list
         addChild(container);
         container.addChild(canvas);
         container.addChild(drawing_layer);
         
         _interactionEventManager = new TouchInteractionEventManager(this);
         _interactionEventManager.setAllTouchesCompleteCallback(writeVectorToCanvas);
         _interactionEventManager.setDrawCallback(draw);
      }
      
      /**
       * Control the canvas width.
       *
       * Important:
       * <ul>
       *	  <li>The canvas is resized from the upper left hand corner.</li>
       *	  <li>If you make the canvas width smaller, the drawing will get cropped on the right side.</li>
       *     <li>Changing the width of the canvas is NOT stored in the history.</li>
       * </ul>
       */
      public function set canvasWidth(w:uint):void {
         // set width
         _canvasWidth = w;
         
         // rebuild the canvas with the new width
         resizeCanvas();
      }
      
      public function get canvasWidth():uint {
         return _canvasWidth;
      }
      
      /**
       * Control the canvas height.
       *
       * Important:
       * <ul>
       *	  <li>The canvas is resized from the upper left hand corner.</li>
       *	  <li>If you make the canvas height smaller, the drawing will get cropped on the bottom.</li>
       *     <li>Changing the height of the canvas is NOT stored in the history.</li>
       * </ul>
       */
      public function set canvasHeight(h:uint):void {
         // set height
         _canvasHeight = h;
         
         // rebuild the canvas with the new height
         resizeCanvas();
      }
      
      public function get canvasHeight():uint {
         return _canvasHeight;
      }
      
      /**
       * Control what Brush is used when the user interacts with the Canvas.
       */
      public function set brush(brush:IBrush):void {
         _currentBrush = brush;			
      }
      
      public function get brush():IBrush {
         return _currentBrush;
      }
      
      /**
       * Display Object displayed above the drawing.
       */
      public function set overlay(displayObject:DisplayObject):void {
         
         // if overlay already exists remove it before adding new overlay
         if(overlay_do != null) {
            container.removeChild(overlay_do);
         }
         
         // update overlay
         overlay_do = displayObject;
         
         // add overlay if exists
         if(overlay_do != null) {
            container.addChildAt(overlay_do, container.numChildren - 1);
         }
         
      }
      
      /**
       * Display Object displayed under the drawing.
       */
      public function set underlay(displayObject:DisplayObject):void {
         
         // if underlay already exists remove it before adding new underlay
         if(underlay_do != null) {
            container.removeChild(underlay_do);
         }
         
         // update underlay
         underlay_do = displayObject;
         
         // add underlay if exists
         if(underlay_do != null) {
            container.addChildAt(underlay_do, 0);
         }
         
      }
      
      /**
       * Control if Canvas is enabled.
       */
      public function set canvasEnabled(en:Boolean):void {
         _canvasEnabled = en;
         this.mouseEnabled = en;
         this.mouseChildren = en;
      }
      
      public function get canvasEnabled():Boolean {
         return _canvasEnabled;
      }
      
      /**
       * The <code>clearCanvas</code> method will clear the Canvas.
       */
      public function clearCanvas():void {
         
         // clear canvas
         _bmp.fillRect(new Rectangle(0, 0, _canvasWidth, _canvasHeight), 0x00FFFFFF);
         
      }
      
      /**
       * The <code>drawing</code> method will return the bitmapdata object that captures
       * the drawn canvas including any overlay or underlay assets.
       *
       * @param transparentBg Specify if you want the image to have a transparent background.
       * 
       * @return A BitmapData object containing the entire canvas.
       */
      public function drawing(transparentBg:Boolean = false):BitmapData {
         
         var canvasBmp:BitmapData;
         
         if(!transparentBg) {
            canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, false, 0xFFFFFFFF);
         } else {
            canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
         }
         
         canvasBmp.draw(container);
         
         return canvasBmp;
         
      }
      
      /**
       * The <code>drawToCanvas</code> method will draw a display object or bitmapdata object to the canvas.
       * This allows you to add an image that will be editable by the drawing engine.
       * 
       * @param asset Image to write to canvas. Object must IBitmapDrawable. This includes MovieClips, Sprites, Bitmaps, BitmapData.
       */
      public function drawToCanvas(asset:Object):void {
         
         if(asset is IBitmapDrawable) {
            _bmp.draw(IBitmapDrawable(asset));
         }
         
      }
      
      /**************************************************************************
       Method	: resizeCanvas()
       
       Purpose	: This method will resize the canvas assets.
       ***************************************************************************/
      private function resizeCanvas():void {
         
         /////////////////////////////////////////////////
         // Create Bitmap
         /////////////////////////////////////////////////
         if(_bmp != null) {
            
            // make a copy of the canvas
            var bmpCopy:BitmapData = _bmp.clone();
            
            // kill current bitmap
            _bmp.dispose();
            
            // create new bitmapdata object with new width and height
            _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
            
            // copy pixels back
            _bmp.copyPixels(bmpCopy, bmpCopy.rect, new Point(0, 0));
            
            // kill copy
            bmpCopy.dispose();
            
            // update canvas bitmapdata object
            canvas.bitmapData = _bmp;
            
         }
         
         // update scroll rect
         this.scrollRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
      }
      
      /**************************************************************************
       Method	: writeVectorToCanvas()
       
       Purpose	: This method will handle the mouse events used for drawing.
       
       Params	: e -- MouseEvent object.
       ***************************************************************************/
      private function writeVectorToCanvas():void
      {	
         // draw to bitmap
         _bmp.draw(drawing_layer, new Matrix(), null, Brush(_currentBrush).mode);
         
         // clear vectors from drawing space
         drawing_layer.graphics.clear();
      }
      
      /**************************************************************************
       Method	: draw()
       
       Purpose	: This method will take an interaction instance and draw the 
                 last two points to the drawing layer.
       
       Params	: interactionInstance -- Interaction instance from the user.
       ***************************************************************************/
      private function draw(interactionInstance:InteractionInstance):void
      {   
         var brushRef:IBrush = IBrush(_currentBrush);
         
         // apply tool
         if(interactionInstance.getPreviousPoint() == null) {
            brushRef.apply(drawing_layer, interactionInstance.getNextPoint());
         } else {
            brushRef.apply(drawing_layer, interactionInstance.getPreviousPoint(), interactionInstance.getNextPoint());
         }
         
         // if render type is continuous then write image to 
         if(Brush(brushRef).mode == ToolMode.ERASE) {
            writeVectorToCanvas();				
         }
      }
   }
}
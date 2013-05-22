/*
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

package com.nocircleno.graffiti
{
   
   import com.nocircleno.graffiti.interaction.IInteractionEventManager;
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   import com.nocircleno.graffiti.interaction.TouchInteractionEventManager;
   import com.nocircleno.graffiti.tools.BitmapCacheRenderMode;
   import com.nocircleno.graffiti.tools.brushes.Brush;
   import com.nocircleno.graffiti.tools.brushes.IBrush;
   import com.nocircleno.graffiti.tools.brushes.RoundBrush;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BitmapFilterType;
   import flash.filters.GradientGlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   /**
    * The GraffitiCanvas Class provides an area on stage to draw in.  It extends
    * the Sprite Class, so you can add it as a child anywhere in the display list.
    * Once you've created an instance of the GraffitiCanvas Class you can assign
    * different tools to the canvas.
    *
    * <p>0.1.0 Features:
    * <ul>
    *	  <li>Create a drawing area</li>
    *	  <li>Multi Touch Support</li>
    *	  <li>Brush Tool providing 7 different Brush shapes with transparency.</li>
    *   <li>Easily get a copy of your drawing to use with your favorite image encoder.</li>
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
       * @param overlay An optional DisplayObject that can be used as an overlay to the Canvas.  DisplayObject should be partially transparent.
       * @param underlay An optional DisplayObject that can be used as an underlay to the Canvas.
       *
       * @example The following code creates a Graffiti Canvas instance. 
       * <listing version="3.0" >
       * package {
       *
       *		import flash.display.Sprite;
       *		import com.nocircleno.graffiti.GraffitiCanvas;
       *		import com.nocircleno.graffiti.tools.brushes.RoundBrush;
       *		
       *		public class Main extends Sprite {
       *			
       *			public function Main() {
       *				
       *				// create new instance of graffiti canvas, with a width and height of 400.
       *				// by default a Brush instance is created inside the GraffitiCanvas Class and assigned as the active tool.
       *				var canvas:GraffitiCanvas = new GraffitiCanvas(400, 400);
       *				addChild(canvas);
       *				
       *				// create a new Round Brush instance, brush size of 8, brush color is Red, fully opaque.
       *				var brush:RoundBrush = new RoundBrush(8, 0xFF0000, 1);
       *				
       *				// assign the Brush as the active tool used by the Canvas
       *				canvas.brush = brush;
       *				
       *			}
       *			
       *		}
       * }
       * </listing>
       * 
       */
      public function GraffitiCanvas(canvasWidth:uint = 100, canvasHeight:uint = 100)
      {   
         _canvasWidth = canvasWidth;
         _canvasHeight = canvasHeight;
         
         init();
      }
      
      private function init():void
      { 
         /////////////////////////////////////////////////
         // Create Canvas Assets
         /////////////////////////////////////////////////
         drawing_layer = new Sprite();
         drawing_layer.mouseEnabled = false;
         drawing_layer.mouseChildren = false;
         container = new Sprite();
         
         _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
         canvas = new Bitmap(_bmp, "auto", false);
         addChild(container);
         container.addChild(canvas);
         container.addChild(drawing_layer);
         
         _interactionEventManager = new TouchInteractionEventManager(this);
         _interactionEventManager.setInteractionCompleteCallback(finalizeInteraction);
         _interactionEventManager.setInteractionUpdateCallback(drawInteraction);
         
         /////////////////////////////////////////////////
         // Create Default Tool, a Brush
         /////////////////////////////////////////////////
         var defaultBrush:RoundBrush = new RoundBrush(16, 0x000000, 1); 
         this.brush = defaultBrush;
      }
      
      /**
       * Control the canvas width.
       *
       * Important:
       * <ul>
       *	  <li>The canvas is resized from the upper left hand corner.</li>
       *	  <li>If you make the canvas width smaller, the drawing will get cropped on the right side.</li>
       * </ul>
       */
      public function set canvasWidth(w:uint):void
      {
         // set width
         _canvasWidth = w;
         
         // rebuild the canvas with the new width
         resizeCanvas();
      }
      
      public function get canvasWidth():uint
      {
         return _canvasWidth;
      }
      
      /**
       * Control the canvas height.
       *
       * Important:
       * <ul>
       *	  <li>The canvas is resized from the upper left hand corner.</li>
       *	  <li>If you make the canvas height smaller, the drawing will get cropped on the bottom.</li>
       * </ul>
       */
      public function set canvasHeight(h:uint):void
      {
         // set height
         _canvasHeight = h;
         
         // rebuild the canvas with the new height
         resizeCanvas();
      }
      
      public function get canvasHeight():uint
      {
         return _canvasHeight;
      }
      
      /**
       * Control what Brush is used when the user interacts with the Canvas.
       */
      public function set brush(brush:IBrush):void
      {
         _currentBrush = brush;
         _currentBrush.applyGraphicsStyle(drawing_layer);
      }
      
      public function get brush():IBrush
      {
         return _currentBrush;
      }
      
      /**
       * Display Object displayed above the drawing.
       */
      public function set overlay(displayObject:DisplayObject):void
      {
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
      public function set underlay(displayObject:DisplayObject):void
      {
         // if underlay already exists remove it before adding new underlay
         if(underlay_do != null)
         {
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
      public function set canvasEnabled(en:Boolean):void
      {
         _canvasEnabled = en;
         this.mouseEnabled = en;
         this.mouseChildren = en;
      }
      
      public function get canvasEnabled():Boolean
      {
         return _canvasEnabled;
      }
      
      /**
       * The <code>clearCanvas</code> method will clear the Canvas.
       */
      public function clearCanvas():void
      {
         _bmp.fillRect(new Rectangle(0, 0, _canvasWidth, _canvasHeight), 0x00FFFFFF);  
      }
      
      /**
       * The <code>fill</code> method will flood fill an area of the drawing with the supplied color.
       *
       * @param point Point at which to flood fill with color.
       * @param color Color to fill with.
       * @param useEntireCanvas Set to true to use an overlaid or underlaid display object when filling.
       * @param useAdvancedFill Set to smooth out the fill.
       * @param smoothStrength The strength of the smoothing when using the advanced fill setting.
       */
      public function fill(point:Point, color:uint, useEntireCanvas:Boolean = false, useAdvancedFill:Boolean = true, smoothStrength:int = 8):void
      {
         // make sure point is within bitmap size
         if (_bmp.rect.containsPoint(point))
         {
            
            // if a color is passed with no alpha component, then add it.
            if((color>>24) == 0)
            {
               // add alpha value to color value.
               color = 0xFF << 24 | color;  
            }
            
            var snapshot1:BitmapData;
            var snapshot2:BitmapData;
    
            if (useEntireCanvas)
            {
               snapshot1 = getComposition(true);
            }
            else
            {
               snapshot1 = _bmp.clone();
            }
           
            snapshot2 = BitmapData(snapshot1.clone());
            snapshot1.floodFill(point.x, point.y, color);
            
            var compareResult:Object = snapshot1.compare(snapshot2);
            
            // check to make sure compare result exists (snapshots are not the same).
            if (compareResult != 0)
            {
               
               var comp:BitmapData = BitmapData(compareResult);
               var compAlpha:BitmapData = comp.clone();
               
               // get alpha value from color
               var alphaValue:uint = color >> 24 & 0x000000FF;
               var alphaNormalized:Number = alphaValue * 0.003921568627450980392156862745098;
               
               // only apply filter if advanced fill is set
               if (useAdvancedFill)
               {   
                  // apply glow to smoothout and expand the fill a little
                  comp.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, alphaNormalized], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL, true));
                  
                  // we do not want to apply any alpha settings to this copy that will be used as an alpha mask with copy pixels
                  compAlpha.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, 0], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL));    
               } 
               else
               {       
                  // change color of fill difference to desired color
                  var cTransform:ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, alphaValue);
                  cTransform.color = color;
                  comp.colorTransform(comp.rect, cTransform);     
               }
               
               // copy fill back into bitmap
               _bmp.copyPixels(comp, comp.rect, new Point(0, 0), compAlpha, new Point(0, 0), true);
               
               // kill compare bitmapdata objects
               comp.dispose();
               compAlpha.dispose();  
            }
            
            // kill snapshot bitmapdata objects
            snapshot1.dispose();
            snapshot2.dispose();   
         }
      }

      
      /**
       * The <code>getComposition</code> method will return the bitmapdata object that captures
       * the drawn canvas including any overlay or underlay assets.
       *
       * @param transparentBg Specify if you want the image to have a transparent background.
       * 
       * @return A BitmapData object containing the entire canvas.
       */
      public function getComposition(transparentBg:Boolean = false):BitmapData
      {   
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
       * The <code>getDrawingLayer</code> method will return a direct reference to the drawing layer.
       * This is meant to give developers an outside way to use the drawing layer directly.
       * 
       * @return A BitmapData object for the drawing layer.
       */
      public function getDrawingLayer():BitmapData
      {    
         return _bmp;
      }
      
      /**
       * The <code>drawToCanvas</code> method will draw a display object or bitmapdata object to the canvas.
       * This allows you to add an image that will be editable by the drawing engine.
       * 
       * @param asset Image to write to canvas. Object must IBitmapDrawable. This includes MovieClips, Sprites, Bitmaps, BitmapData.
       */
      public function drawToCanvas(asset:Object):void
      {   
         if(asset is IBitmapDrawable)
         {
            _bmp.draw(IBitmapDrawable(asset));
         }  
      }
      
      /**************************************************************************
       Method	: resizeCanvas()
       
       Purpose	: This method will resize the canvas assets.
       ***************************************************************************/
      private function resizeCanvas():void
      {
         if(_bmp != null)
         {   
            // make a copy of the canvas
            var bmpCopy:BitmapData = _bmp.clone();
            _bmp.dispose();
            _bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
            
            // copy pixels back
            _bmp.copyPixels(bmpCopy, bmpCopy.rect, new Point(0, 0));
            
            bmpCopy.dispose();
            
            // update canvas bitmapdata object
            canvas.bitmapData = _bmp;
         }
      }
      
      /**************************************************************************
       Method	: finalizeInteraction()
       
       Purpose	: This method will write the vector draw layer to the bitmap
                 canvas.  This will also clear the drawing layer.
       ***************************************************************************/
      private function finalizeInteraction():void
      {	
         _currentBrush.cacheToBitmap(_bmp, drawing_layer);
      }
      
      /**************************************************************************
       Method	: drawInteraction()
       
       Purpose	: This method will take an interaction instance and draw the 
                 last two points to the drawing layer.
       
       Params	: interactionInstances -- An vector of Interaction instance from
                                         the user.
       ***************************************************************************/
      private function drawInteraction(interactionInstances:Vector.<InteractionInstance>):void
      {   
         _currentBrush.apply(drawing_layer, interactionInstances);
         
         if(Brush(_currentBrush).bitmapCacheRenderMode == BitmapCacheRenderMode.ERASE) {
            finalizeInteraction();				
         }
      }
   }
}
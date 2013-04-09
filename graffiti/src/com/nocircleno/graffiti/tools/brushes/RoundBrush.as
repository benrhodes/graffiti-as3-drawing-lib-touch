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
package com.nocircleno.graffiti.tools.brushes
{
   
   import com.nocircleno.graffiti.interaction.InteractionInstance;
   
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsPathWinding;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class RoundBrush extends Brush implements IBrush
   {
      
      private var _previousPointRef:Point;
      private var _nextPointRef:Point;
      
      /**
       * The <code>RoundBrush</code> constructor.
       * 
       * @param brushSize Size of the brush.
       * @param brushColor Color of the brush.
       * @param brushAlpha Alpha value of the brush.
       * @param bitmapCacheRenderMode Render mode used when caching brush content to canvas bitmap.
       */
      public function RoundBrush(brushSize:Number = 4, brushColor:uint = 0x000000, brushAlpha:Number = 1, bitmapCacheRenderMode:String = null)
      {
         super(brushSize, brushColor, brushAlpha, bitmapCacheRenderMode);
      }
      
      /**
       * The <code>cacheToBitmap</code> method will write the drawing layer to the cavnas bitmap.
       *
       * @param bitmap Bitmap to draw.
       * @param drawingLayer Drawing layer.
       */
      public function cacheToBitmap(bitmap:BitmapData, drawingLayer:Sprite):void
      {
         bitmap.draw(drawingLayer, new Matrix(), null, bitmapCacheRenderMode);
         clearLastPath();
         applyGraphicsStyle(drawingLayer);
      }
      
      /**
       * The <code>applyGraphicsStyle</code> method will apply the graphics draw style to display object.
       *
       * @param drawingLayer Sprite apply graphics style to.
       */
      public function applyGraphicsStyle(drawingLayer:Sprite):void
      {
         drawingLayer.graphics.clear();
         drawingLayer.graphics.lineStyle(_size, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
      }
      
      /**
       * The <code>apply</code> method will draw the interactions to the drawing layer.
       *
       * @param drawingLayer Display object to draw interaction in.
       * @param interactionInstances List of Interaction Instances.
       */
      public function apply(drawingLayer:Sprite, interactionInstances:Vector.<InteractionInstance>):void
      {
         if(_alpha == 1)
         {
            commands.length = 0;
            drawingData.length = 0;
         }
         
         _numberInteractions = interactionInstances.length;
         
         for(var i:int=0; i<_numberInteractions; i++)
         {
            _previousPointRef = interactionInstances[i].getPathNextToEndPoint();
            _nextPointRef = interactionInstances[i].getPathEndPoint();
            
            // if we only have one point then draw a single shape of the 
            if(_previousPointRef == null)
            {
               _previousPointRef = _nextPointRef.clone();
               _previousPointRef.x -= 1;
               _previousPointRef.y -= 1;
            } 
            
            commands.push(GraphicsPathCommand.MOVE_TO);
            drawingData.push(_previousPointRef.x);
            drawingData.push(_previousPointRef.y);
            
            commands.push(GraphicsPathCommand.LINE_TO);
            drawingData.push(_nextPointRef.x);
            drawingData.push(_nextPointRef.y);
         }
         
         // draw brush session
         if(_alpha < 1)
         {
            applyGraphicsStyle(drawingLayer);
         }
         
         drawingLayer.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
      }
   }
}
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
   
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsPathWinding;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class RoundBrush extends Brush implements IBrush
   {
      public function RoundBrush(brushSize:Number = 4, brushColor:uint = 0x000000, brushAlpha:Number = 1, toolMode:String = null)
      {
         super(brushSize, brushColor, brushAlpha, toolMode);
      }
      
      public function apply(drawingTarget:DisplayObject, point1:Point, point2:Point = null):void
      {
         // cast target as a Sprite
         var targetCast:Sprite = Sprite(drawingTarget);
         
         // if we only have one point then draw a single shape of the 
         if(point2 == null) {
            commands.push(GraphicsPathCommand.MOVE_TO);
            drawingData.push(point1.x);
            drawingData.push(point1.y);
            
            commands.push(GraphicsPathCommand.LINE_TO);
            drawingData.push(point1.x + 1);
            drawingData.push(point1.y + 1);  
         } 
         else
         {
            commands.push(GraphicsPathCommand.MOVE_TO);
            drawingData.push(point1.x);
            drawingData.push(point1.y);
            
            commands.push(GraphicsPathCommand.LINE_TO);
            drawingData.push(point2.x);
            drawingData.push(point2.y);  
         }
         
         // draw brush session
         targetCast.graphics.clear();
         targetCast.graphics.lineStyle(_size, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
         targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
      }
   }
}
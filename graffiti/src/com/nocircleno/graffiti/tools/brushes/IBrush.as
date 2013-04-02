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
   import flash.display.DisplayObject;
   import flash.display.Sprite;

   public interface IBrush
   {
      function cacheToBitmap(bitmap:BitmapData, drawingLayer:Sprite):void;
      function applyGraphicsStyle(drawingTarget:DisplayObject):void;
      function apply(drawingTarget:DisplayObject, interactionInstance:Vector.<InteractionInstance>):void;
   }
}
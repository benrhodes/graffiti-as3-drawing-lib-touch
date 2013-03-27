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

package com.nocircleno.graffiti.tools.brushes {
   import com.nocircleno.graffiti.tools.ToolMode;
	
	/**
	* BrushTool Class allows the user to paint anti-alias shapes to the Canvas.
	*
	* @langversion 3.0
   * @playerversion Flash 10 AIR 1.5 
	*/
	public class Brush {
		
		// store local references for performance reasons
		private const sin:Function = Math.sin;
		private const cos:Function = Math.cos;
		private const atan2:Function = Math.atan2;
		private const abs:Function = Math.abs;
      
      protected var _size:Number;
      protected var _halfSize:Number;
      protected var _fourthSize:Number;
      protected var _eighthSize:Number;
      protected var _sixteenthSize:Number;
      protected var _color:uint;
      protected var _alpha:Number;
      protected var _mode:String;
      protected var commands:Vector.<int> = new Vector.<int>();
      protected var drawingData:Vector.<Number> = new Vector.<Number>();
		
		/**
		* The <code>BrushTool</code> constructor.
		* 
		* @param brushSize Size of the brush.
		* @param brushColor Color of the brush.
		* @param brushAlpha Alpha value of the brush.
		* @param brushBlur Blur value of the brush.
		* @param brushType Type of Brush
		* @param toolMode Tool mode the Brush will be drawing with.
		*
		* @example The following code creates a Brush instance.
		* <listing version="3.0" >
		* // create a diamond brush
		* var diamondBrush:BrushTool = new BrushTool(8, 0xFF0000, 1, 0, BrushType.DIAMOND);
		* </listing>
		* 
		*/
		public function Brush(brushSize:Number = 4, brushColor:uint = 0x000000, brushAlpha:Number = 1, toolMode:String = null) {
			
			// store size
			size = brushSize;
			
			// store color
			color = brushColor;
			
			// store alpha
			alpha = brushAlpha;
			
			// store mode
			mode = toolMode;
		}
      
      /**
       * Drawing Mode
       */
      public function set mode(toolMode:String):void {
         
         // store mode
         if(toolMode != null && ToolMode.validMode(toolMode)) {
            _mode = toolMode;
         } else {
            _mode = ToolMode.NORMAL;
         }
         
      }
      
      public function get mode():String {
         return _mode;
      }
      
      /**
       * The <code>clearLastPath</code> method will reset the drawing data held by the brush.
       */
      public function clearLastPath():void {
         commands.length = 0;
         drawingData.length = 0;  
      }
   	
		/**
		* Size of the Brush
		*/
		public function set size(brushSize:Number):void {
			
			if(brushSize > 0) {
			
				// set brush size
				_size = brushSize;
				
				// calcuate divisions
				_halfSize = _size * .5;
				_fourthSize = _size * .25;
				_eighthSize = _size * .125;
				_sixteenthSize = _size * 0.0625;
				
			}
			
		}
		
		public function get size():Number {
			return _size;
		}
		
		/**
		* Color of the Brush
		*/
		public function set color(brushColor:uint):void {
			_color = brushColor;
		}

		public function get color():uint {
			return _color;
		}
		
		/**
		* Alpha of the Brush
		*/
		public function set alpha(brushAlpha:Number):void {
			
			if(brushAlpha < 0) {
				brushAlpha = 0;
			} else if(brushAlpha > 1) {
				brushAlpha = 1;
			}
			
			_alpha = brushAlpha;
		}

		public function get alpha():Number {
			return _alpha;
		}
		
	}
		
}
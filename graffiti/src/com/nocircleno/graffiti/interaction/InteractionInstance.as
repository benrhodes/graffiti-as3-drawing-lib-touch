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
package com.nocircleno.graffiti.interaction
{
	import flash.geom.Point;

	public class InteractionInstance
	{
		
		private var _interactionId:int;
		private var _path:Vector.<Point>;
      private var _dirty:Boolean = false;
		
		public function InteractionInstance() {}
		
		public function get interactionId():int
      {
			return _interactionId;
		}
		
		public function init(instanceId):void
      {
			_interactionId = instanceId;
			_path = new Vector.<Point>();
		}
		
		public function addPointToPath(point:Point):void
      {
			_path.push(point);
         _dirty = true;
		}
      
      public function get dirty():Boolean
      {
         return _dirty;
      }
      
      public function set dirty(isDirty):void
      {
         _dirty = isDirty;
      }
		
      public function getInstancePath():Vector.<Point>
      {
         return _path;
      }
      
      public function getPathNextToEndPoint():Point
      {
         if(_path.length - 1 > 0) {
            return _path[_path.length - 2];
         }
         return null;
      }
      
		public function getPathEndPoint():Point
      {
			if(_path.length > 0) {
				return _path[_path.length - 1];
			}
			return null;
		}
	}
}
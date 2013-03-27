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
      private var _pendingPointDirty:Boolean = false;
      private var _pendingPoint:Point;
		
		public function InteractionInstance()
      {
         _pendingPoint = new Point();
         _path = new Vector.<Point>();
      }
		
		public function get interactionId():int
      {
			return _interactionId;
		}
		
		public function init(instanceId):void
      {
			_interactionId = instanceId;
         _path.length = 0;
		}
      
      public function setPendingPointToPath(point:Point):void {
         _pendingPoint.x = point.x;
         _pendingPoint.y = point.y;
         _pendingPointDirty = true;
      }
      
      public function writePendingPointToPath():Boolean {
         if(_pendingPointDirty) {
            _pendingPointDirty = false;
            _path.push(_pendingPoint.clone());
            return true;
         }
         return false;
      }
		
		public function addPointToPath(point:Point):void
      {
			_path.push(point);
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
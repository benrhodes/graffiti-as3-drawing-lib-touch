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
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TouchEvent;
   import flash.geom.Point;
   import flash.ui.Multitouch;
   import flash.ui.MultitouchInputMode;
   
   public class TouchInteractionEventManager extends EventDispatcher implements IInteractionEventManager
   {
      
      private var _target:IEventDispatcher;
      private var _interactionInstanceObjectPool:InteractiveInstanceObjectPool;
      private var _currentTouches:Vector.<InteractionInstance>;
      private var _changedInteractions:Vector.<InteractionInstance>;
      private var _currentNumberTouches:int = 0;
      private var _drawCallback:Function;
      private var _touchesCompleteCallback:Function;
      
      public function TouchInteractionEventManager(target:IEventDispatcher=null)
      {
         super(target);
         _changedInteractions = new Vector.<InteractionInstance>();
         _target = target;
         init();
      }
     
      public function setDrawCallback(draw:Function):void {
         _drawCallback = draw;
      }
      
      public function setAllTouchesCompleteCallback(completeCallback:Function):void {
         _touchesCompleteCallback = completeCallback;
      }
      
      private function init():void
      {	
         Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
         
         _interactionInstanceObjectPool = new InteractiveInstanceObjectPool();
         _currentTouches = new Vector.<InteractionInstance>();
         _target.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);	
         _target.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
         _target.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
      }
      
      private function onTouchBegin(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         var instance:InteractionInstance = _interactionInstanceObjectPool.getInstance();
         instance.init(e.touchPointID);
         instance.addPointToPath(new Point(e.localX, e.localY));
         _currentTouches.push(instance);   
         _currentNumberTouches++;
         
         if(_currentNumberTouches == 1) {
            _target.addEventListener(Event.ENTER_FRAME, drawToFrame);
         }
      }
      
      private function onTouchMove(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         var instance:InteractionInstance =  getInteractiveInstanceByTouchId(e.touchPointID);
         if(instance == null) {
            return;  
         }
         
         instance.setPendingPointToPath(new Point(e.localX, e.localY));
      }
      
      private function onTouchEnd(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         var instance:InteractionInstance = getInteractiveInstanceByTouchId(e.touchPointID);
         if(instance == null) {
            return;  
         }
         
         if(instance.writePendingPointToPath())
         {
            _drawCallback.call(_target, _currentTouches);     
         }   
         
         removeInteractionInstanceByTouchId(e.touchPointID);
         _currentNumberTouches--;
         
         if(_currentNumberTouches == 0)
         {
            _target.removeEventListener(Event.ENTER_FRAME, drawToFrame);
            
            if(_touchesCompleteCallback)
            {
               _touchesCompleteCallback.call(_target);
            }
            
            _interactionInstanceObjectPool.resetCount();
         }   
      }
      
      private function drawToFrame(e:Event):void
      {
         _changedInteractions.length = 0;
         for(var i:int=0; i<_currentNumberTouches; i++)
         {
            if(_currentTouches[i].writePendingPointToPath())
            {
               _changedInteractions.push(_currentTouches[i]);
            }   
         }
         
         if(_changedInteractions.length > 0)
         {
            _drawCallback.call(_target, _changedInteractions);    
         }
      }
      
      private function getInteractiveInstanceByTouchId(touchId:int):InteractionInstance
      {
         for(var i:int=0; i<_currentNumberTouches; i++) {
            if(_currentTouches[i].interactionId == touchId) {
               return _currentTouches[i];
            }
         }
         return null;
      }
      
      private function removeInteractionInstanceByTouchId(touchId:int):void {
         for(var i:int=0; i<_currentNumberTouches; i++) {
            if(_currentTouches[i].interactionId == touchId) {
               _currentTouches.splice(i, 1);
               return;
            }
         }
      }
   }
}
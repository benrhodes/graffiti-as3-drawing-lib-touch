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
      private var _currentTouches:Object;
      private var _changedInteractions:Vector.<InteractionInstance>;
      private var _interactionInstanceReference:InteractionInstance;
      private var _currentNumberTouches:int = 0;
      private var _interactionUpdateCallback:Function;
      private var _interactionCompleteCallback:Function;
      
      public function TouchInteractionEventManager(target:IEventDispatcher=null)
      {
         super(target);
         _changedInteractions = new Vector.<InteractionInstance>();
         _target = target;
         init();
      }
     
      /**
       * The <code>setInteractionUpdateCallback</code> method assigns a function that be called
       * when an interaction has changed.
       *
       * @param interactionUpdateCallback Callback function.
       */
      public function setInteractionUpdateCallback(interactionUpdateCallback:Function):void {
         _interactionUpdateCallback = interactionUpdateCallback;
      }
      
      /**
       * The <code>setInteractionCompleteCallback</code> method assigns a function that be called
       * when all interactions are complete.
       *
       * @param interactionCompleteCallback Callback function.
       */
      public function setInteractionCompleteCallback(interactionCompleteCallback:Function):void {
         _interactionCompleteCallback = interactionCompleteCallback;
      }
      
      private function init():void
      {	
         Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
         
         _interactionInstanceObjectPool = new InteractiveInstanceObjectPool();
         _currentTouches = new Object();
         _target.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);	
         _target.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
         _target.addEventListener(TouchEvent.TOUCH_OUT, onTouchEnd);
      }
      
      private function onTouchBegin(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         _interactionInstanceReference = _interactionInstanceObjectPool.getInstance();
         _interactionInstanceReference.init(e.touchPointID);
         _interactionInstanceReference.setPendingPointToPath(new Point(e.localX, e.localY));
         _currentTouches[e.touchPointID] = _interactionInstanceReference; 
         _currentNumberTouches++;
         
         if(_currentNumberTouches == 1) {
            _target.addEventListener(Event.ENTER_FRAME, drawToFrame);
         }
      }
      
      private function onTouchMove(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         _interactionInstanceReference = _currentTouches[e.touchPointID];
         if(_interactionInstanceReference == null) {
            return;  
         }
         
         _interactionInstanceReference.setPendingPointToPath(new Point(e.localX, e.localY));
      }
      
      private function onTouchEnd(e:TouchEvent):void
      {
         e.stopPropagation();
         e.preventDefault();
         
         _interactionInstanceReference = InteractionInstance(_currentTouches[e.touchPointID]);
         if(_interactionInstanceReference == null) {
            return;  
         }
         
         if(_interactionInstanceReference.writePendingPointToPath())
         {
            drawToFrame(null);    
         }   
         
         delete _currentTouches[e.touchPointID];
         _currentNumberTouches--;
         
         if(_currentNumberTouches == 0)
         {
            _target.removeEventListener(Event.ENTER_FRAME, drawToFrame);
            
            if(_interactionCompleteCallback)
            {
               _interactionCompleteCallback.call(_target);
            }
            
            _interactionInstanceObjectPool.resetCount();
         } 
      }
      
      private function drawToFrame(e:Event):void
      {
         _changedInteractions.length = 0;
         for each(var interaction:InteractionInstance in _currentTouches)
         {
            if(interaction.writePendingPointToPath())
            {
               _changedInteractions.push(interaction);
            }   
         }
                  
         if(_changedInteractions.length > 0)
         {
            _interactionUpdateCallback.call(_target, _changedInteractions);    
         }
      }
   }
}
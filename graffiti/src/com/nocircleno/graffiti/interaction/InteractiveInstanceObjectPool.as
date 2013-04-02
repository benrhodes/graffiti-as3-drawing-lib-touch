package com.nocircleno.graffiti.interaction
{
	public class InteractiveInstanceObjectPool
	{
		
		private var _interactiveInstancePool:Vector.<InteractionInstance>;
		private var _instanceCount:int = 0;
		
		public function InteractiveInstanceObjectPool()
		{
         init();
		}
		
      /**
       * The <code>resetCount</code> method resets the object count.
       */
		public function resetCount():void
		{
			_instanceCount = 0;
		}
		
      /**
       * The <code>getInstance</code> method returns an interaction instance from the pool.
       * 
       * @return An Interaction Instance
       */
		public function getInstance():InteractionInstance
		{
			if(_instanceCount >= _interactiveInstancePool.length)
			{
				_interactiveInstancePool.push(new InteractionInstance());
			}
         
         _instanceCount++;
			
			return _interactiveInstancePool[_instanceCount - 1];
		}
      
      private function init():void
      {
         _interactiveInstancePool = new Vector.<InteractionInstance>();
      }
	}
}
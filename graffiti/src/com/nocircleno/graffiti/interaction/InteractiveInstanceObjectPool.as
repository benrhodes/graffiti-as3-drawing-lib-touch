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
		
		private function init():void
		{
			_interactiveInstancePool = new Vector.<InteractionInstance>();
		}
		
		public function resetCount():void
		{
			_instanceCount = 0;
		}
		
		public function getInstance():InteractionInstance
		{
			if(_instanceCount >= _interactiveInstancePool.length)
			{
				_interactiveInstancePool.push(new InteractionInstance());
			}
         
         _instanceCount++;
			
			return _interactiveInstancePool[_interactiveInstancePool.length - 1];
		}
	}
}
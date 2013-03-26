package com.nocircleno.graffiti.interaction
{
	import flash.geom.Point;

	public class InteractionInstance
	{
		
		private var _interactionId:int;
		private var _history:Vector.<Point>;
		
		public function InteractionInstance() {}
		
		public function get interactionId():int
      {
			return _interactionId;
		}
		
		public function init(instanceId):void
      {
			_interactionId = instanceId;
			_history = new Vector.<Point>();
		}
		
		public function addPoint(point:Point):void
      {
			_history.push(point);
		}
		
      public function getPreviousPoint():Point
      {
         if(_history.length - 1 > 0) {
            return _history[_history.length - 2];
         }
         return null;
      }
      
		public function getNextPoint():Point {
			if(_history.length > 0) {
				return _history[_history.length - 1];
			}
			return null;
		}
	}
}
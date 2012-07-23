package org.gloplayer.events
{
	import flash.events.Event;
	
	import org.gloplayer.data.ComponentInstanceVO;

	public class PageComponentEvent extends Event
	{
		
		public static const ADDED:String = "PageComponentEvent.Added";
		public static const REMOVED:String = "PageComponentEvent.Removed";
		public static const LOADED:String = "PageComponentEvent.Loaded";
		public static const FAILED:String = "PageComponentEvent.Failed";

		public var componentInstance:ComponentInstanceVO;
		
		public function PageComponentEvent(type:String, instance:ComponentInstanceVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			componentInstance = instance;
		}
		
		override public function clone():Event
		{
			return new PageComponentEvent(type, componentInstance, bubbles, cancelable);
		}
		
	}
}
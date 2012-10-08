package org.glomaker.plugin.dragdrop.events
{
	import flash.events.Event;
	
	public class HotspotSizeChangeEvent extends Event
	{
		public static const CHANGE:String = "org.glomaker.plugin.dragdrop.events.HotspotSizeChangeEvent";
		
		public var w:Number;
		public var h:Number;
		
		public function HotspotSizeChangeEvent(w:Number, h:Number, type:String = CHANGE, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.w = w;
			this.h = h;
		}
		
		override public function clone():Event
		{
			return new HotspotSizeChangeEvent( w, h, type, bubbles, cancelable);
		}
	}
}
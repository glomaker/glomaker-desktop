package org.glomaker.plugin.dragdrop.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class HotspotPositionChangeEvent extends Event
	{
		public static const CHANGE:String = "org.glomaker.plugin.dragdrop.events.HotspotPositionChangeEvent.CHANGE";
		

		public var x:Number;
		public var y:Number;
		
		public function HotspotPositionChangeEvent(x:Number, y:Number,type:String = CHANGE, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.x = x;
			this.y = y;
		}
		
		override public function clone():Event
		{
			return new HotspotPositionChangeEvent( x, y, type, bubbles, cancelable );
		}
	}
}
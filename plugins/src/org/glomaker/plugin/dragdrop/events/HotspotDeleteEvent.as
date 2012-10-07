package org.glomaker.plugin.dragdrop.events
{
	import flash.events.Event;
	
	import org.glomaker.plugin.dragdrop.Hotspot;
	
	
	/**
	 * Event to indicate that the user has deleted a particular hotspot display object. 
	 * @author Nils
	 */	
	public class HotspotDeleteEvent extends Event
	{
		
		public static const DELETE:String = "org.glomaker.plugin.dragdrop.events.HotspotDeleteEvent.Delete";
		
		/**
		 * The visual hotspot instance that the user has deleted. 
		 */		
		public var hotspot:Hotspot;
		
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function HotspotDeleteEvent(hotspot:Hotspot, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(DELETE, bubbles, cancelable);
			this.hotspot = hotspot;
		}
		
		override public function clone():Event
		{
			return new HotspotDeleteEvent( hotspot, bubbles, cancelable );
		}
	}
}
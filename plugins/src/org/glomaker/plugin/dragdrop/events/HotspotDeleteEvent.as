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
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function HotspotDeleteEvent(type:String = DELETE, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new HotspotDeleteEvent( type, bubbles, cancelable );
		}
	}
}
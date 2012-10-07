package org.glomaker.plugin.dragdrop.events
{
	import flash.events.Event;
	
	/**
	 * Event to indicate that the text inside a particular hotspot has changed. 
	 * @author Nils
	 * 
	 */	
	public class HotspotTextChangeEvent extends Event
	{
		public static const CHANGE:String = "org.glomaker.plugin.dragdrop.events.HotspotTextChangeEvent.Change";
		
		public var newText:String;
		
		public function HotspotTextChangeEvent(newText:String, type:String = HotspotTextChangeEvent.CHANGE, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new HotspotTextChangeEvent( newText );
		}
	}
}
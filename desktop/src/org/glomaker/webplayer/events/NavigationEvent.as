/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.events
{
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		public static const PREVIOUS:String = "NavigationEvent.Previous";
		public static const NEXT:String = "NavigationEvent.Next";
		public static const GOTO:String = "NavigationEvent.Goto";


		/**
		 * Page to navigate to.
		 * Usually only set on GOTO event types, -1 otherwise.
		**/
		public var pageIndex:int = -1;
		
		
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function NavigationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * Clone. 
		 * @return 
		 */		
		override public function clone():Event
		{
			var navEvent:NavigationEvent = new NavigationEvent(type, bubbles, cancelable);
			navEvent.pageIndex = pageIndex;
			return navEvent;
		}
		
	}
}
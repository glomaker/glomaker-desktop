/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.events
{
	import flash.events.Event;
	
	import org.glomaker.common.vo.ComponentInstanceVO;
	
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
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	
	[Event(name="change",type="flash.events.Event")]
	/**
	 * A simple class that wraps an array and provides a CHANGE event when the array content has changed. 
	 * @author Nils
	 */
	public class MutableArray extends EventDispatcher
	{
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var _array:Array;
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor
		 * @param source
		 */		
		public function MutableArray(source:Array = null)
		{
			if(source)
				_array = source;
			else
				_array = [];
		}


		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Specifies the source array that the MutableArray instance acts as a wrapper for.
		 * @param source
		 * @param suppressChangeEvent
		 */		
		public function wrap(source:Array, suppressChangeEvent:Boolean = false):void
		{
			_array = source;
			
			if(!suppressChangeEvent)
				dispatchChangeEvent();
		}
		
		/**
		 * Triggers an update event to be dispatched. 
		 */		
		public function triggerUpdate():void
		{
			dispatchChangeEvent();
		}

		/**
		 * Retrieves the actual Array managed by the MutableArray instance. 
		 * @return 
		 */		
		public function get source():Array
		{
			return _array;
		}


		// ------------------------------------------------------------------
		// PROTECTED INSTANCE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Dispatches an Event.CHANGE event. 
		 */		
		protected function dispatchChangeEvent():void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}
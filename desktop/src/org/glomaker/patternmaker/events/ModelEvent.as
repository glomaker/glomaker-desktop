/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.events
{
	import flash.events.Event;

	/**
	 * This custom Event class adds a message property to a basic Event.
	 */
	public class ModelEvent extends Event {
		/**
		 * The name of the new MODEL_EVENT type.
		 */
		public static  const MODEL_EVENT:String = "modelEvent";

		/**
		 * A text message that can be passed to an event handler
		 * with this event object.
		 */
		public var message:String;

		/**
		 *  Constructor.
		 *  @param message The text to display when the file is loaded.
		 */
		public function ModelEvent(message:String = "modelEvent") {
			super(MODEL_EVENT);

			this.message = message;
		}
		/**
		 * Creates and returns a copy of the current instance.
		 * @returnA copy of the current instance.
		 */
		public override function clone():Event {
			return new ModelEvent(message);
		}
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String {
			return formatToString("ModelEvent","type","bubbles","cancelable","eventPhase","message");
		}
	}
}
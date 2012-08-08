/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-12 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.events
{
	import flash.events.Event;
	
	import org.glomaker.interfaces.pattern.IPatternNode;
	
	/**
	 * Event class for notifying about node duplications.
	 * 
	 * @author haykel
	 * 
	 */
	public class NodeDuplicatedEvent extends Event
	{
		public static const NODE_DUPLICATED:String = "nodeDuplicated";
		
		/**
		 * Reference node (the one that was duplicated).
		 */
		public var refNode:IPatternNode;
		
		/**
		 * New node (the duplicate).
		 */
		public var newNode:IPatternNode;
		
		/**
		 * @private
		 */
		public function NodeDuplicatedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, refNode:IPatternNode=null, newNode:IPatternNode=null)
		{
			super(type, bubbles, cancelable);
			
			this.refNode = refNode;
			this.newNode = newNode;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new NodeDuplicatedEvent(type, bubbles, cancelable, refNode, newNode);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return formatToString("NodeDuplicatedEvent", "type", "bubbles", "cancelable", "eventPhase", "refNode", "newNode");
		}
	}
}
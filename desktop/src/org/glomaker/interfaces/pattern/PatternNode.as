/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	import org.glomaker.patternmaker.data.GlobalPoint;

	/**
	 * Defines a single node in a PatternMaker pedagogical sequence. 
	 * @author Nils
	 */
	public class PatternNode implements IPatternNode
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		private var _id:String;
		private var _func:IPatternFunction;
		private var _title:String;
		private var _description:String;
		private var _loc:GlobalPoint;
		private var _parentId:String;
		private var _childId:String;
		private var _layoutId:String;
		private var _isRoot:Boolean;
		private var _isReceiver:Boolean;
		private var _isActive:Boolean;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * Constructor 
		 * @param id
		 * @param func
		 * @param title
		 * @param description
		 */
		public function PatternNode(id:String = null, func:IPatternFunction = null, title:String = null, description:String = null)
		{
			this.id = id;
			this.func = func;
			this.title = title;
			this.description = description;
			
			// default values
			_loc = new GlobalPoint(0, 0);
			_isRoot = false;
			_isReceiver = false;
			_isActive = false;
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS (implement IPatternNode)
		// ------------------------------------------------------------------

		/**
		 * The node's ID value. 
		 */
		public function set id(value:String):void
		{
			_id = value;
		}
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * The pedagogical function the node represents. 
		 */
		public function set func(value:IPatternFunction):void
		{
			_func = value;
		}
		public function get func():IPatternFunction
		{
			return _func;
		}
		
		/**
		 * The node's title. 
		 */		
		public function set title(value:String):void
		{
			_title = value;
		}
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * The node's description. 
		 */		
		public function set description(value:String):void
		{
			_description = value;
		}
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * The node's current location in PatternMaker. 
		 */		
		public function set loc(value:GlobalPoint):void
		{
			_loc = value;
		}
		public function get loc():GlobalPoint
		{
			return _loc;
		}
		
		/**
		 * The node ID of the node's parent (if any). 
		 */		
		public function set parentId(value:String):void
		{
			_parentId = value;
		}
		public function get parentId():String
		{
			return _parentId;
		}
		
		/**
		 * The node ID of the node's child (if any). 
		 */		
		public function set childId(value:String):void
		{
			_childId = value;
		}
		public function get childId():String
		{
			return _childId;
		}

		/**
		 * The ID of the page layout being used to implement this node. 
		 */		
		public function set layoutId(value:String):void
		{
			_layoutId = value;
		}
		public function get layoutId():String
		{
			return _layoutId;
		}
		
		/**
		 * Is the node the root node in the pedagogical sequence? 
		 */		
		public function set isRoot(value:Boolean):void
		{
			_isRoot = value;
		}
		public function get isRoot():Boolean
		{
			return _isRoot;
		}
		
		/**
		 * Is the node active in the pedagogical sequence? 
		 */		
		public function set isActive(value:Boolean):void
		{
			_isActive = value;
		}
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		/**
		 * Is the node a receiver in PatternMaker? 
		 */		
		public function set isReceiver(value:Boolean):void
		{
			_isReceiver = value;
		}
		public function get isReceiver():Boolean
		{
			return _isReceiver;
		}		
		
	}
}
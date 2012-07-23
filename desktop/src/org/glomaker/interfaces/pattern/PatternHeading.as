/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	
	/**
	 * Defines a heading and it's associated functions in a PatternMaker pattern definition. 
	 * @author Nils
	 */	
	public class PatternHeading implements IPatternHeading
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		private var _id:String;
		private var _title:String;
		private var _colour:uint;
		private var _functions:Array;
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * Constructor 
		 * @param id
		 * @param title
		 */
		public function PatternHeading(id:String = null, title:String = null, colour:uint = 0)
		{
			this.id = id;
			this.title = title;
			this.colour = colour;
			this.functions = [];
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS (implement IPatternHeading)
		// ------------------------------------------------------------------


		/**
		 * The header's id. 
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
		 * The header's title. 
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
		 * Icon colour for functions / nodes from this header. 
		 */		
		public function set colour(value:uint):void
		{
			_colour = value;
		}
		public function get colour():uint
		{
			return _colour;
		}		

		/**
		 * A list of IPatternFunction instances belonging to this header. 
		 * @param value
		 */
		public function set functions(value:Array):void
		{
			_functions = value;
		}
		public function get functions():Array
		{
			return _functions;
		}
		
	}
}
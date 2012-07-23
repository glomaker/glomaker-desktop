/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	
	/**
	 * Defines a function in a PatternMaker pattern definition. 
	 * @author Nils
	 */	
	public class PatternFunction implements IPatternFunction
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		private var _id:String;
		private var _heading:IPatternHeading;
		private var _title:String;
		private var _description:String;
		private var _defaultLayoutId:String;
		private var _guidance:Array;


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		
		/**
		 * Constructor 
		 * @param id
		 * @param heading
		 * @param title
		 * @param description
		 */		
		public function PatternFunction(id:String = null, heading:IPatternHeading = null, title:String = null, description:String = null)
		{
			this.id = id;
			this.heading = heading;
			this.title = title;
			this.description = description;
			this.guidance = [];
		}


		// ------------------------------------------------------------------
		// GETTER / SETTERS (implement IPatternFunction)
		// ------------------------------------------------------------------

		/**
		 * The functions ID. 
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
		 * The heading the function belongs to. 
		 */
		public function set heading(value:IPatternHeading):void
		{
			_heading = value;
		}
		
		public function get heading():IPatternHeading
		{
			return _heading;
		}
		
		/**
		 * The function's title. 
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
		 * The function's description. 
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
		 * The id of the default page layout to use when creating nodes for this function.
		 */		
		public function set defaultLayoutId(value:String):void
		{
			_defaultLayoutId = value;
		}
		public function get defaultLayoutId():String
		{
			return _defaultLayoutId;
		}

		/**
		 * The guidance pages used to provide help for this function.
		 * Stores IPatternGuidancePage instances.  
		 */		
		public function set guidance(value:Array):void
		{
			_guidance = value;
		}
		public function get guidance():Array
		{
			return _guidance;
		}
		
	}
}
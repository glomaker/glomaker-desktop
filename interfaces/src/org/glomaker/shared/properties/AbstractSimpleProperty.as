/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{

	/**
	 * Provides an abstract base-class for simple properties.
	 * Extend this class for properties that store simple values.
	 * Permitted values stored are: primitive data types, Objects or Arrays of permitted values.
	 * 
	 * If you need to store more complex datatypes, consider extending AbstractCustomProperty instead.
	 *  
	 * @author Nils
	 */
	public class AbstractSimpleProperty implements IComponentProperty
	{

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES 
		// ------------------------------------------------------------------
		
		private var _propValue:*;
		private var _propName:String = "";
		private var _editLabel:String = "";
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR 
		// ------------------------------------------------------------------
		
		/**
		 * Constructor 
		 * @param name
		 * @param label
		 * @param value
		 */		
		public function AbstractSimpleProperty(name:String, label:String = null, value:* = null)
		{
			propName = name;
			editLabel = label;
			propValue = value;
		}


		// ------------------------------------------------------------------
		// PUBLIC METHODS (implement the IComponentProperty interface)
		// ------------------------------------------------------------------

		public function set propValue(value:*):void
		{
			_propValue = value;
		}
		
		public function get propValue():*
		{
			return _propValue;
		}
		
		public function set propName(value:String):void
		{
			_propName = value;
		}
		
		public function get propName():String
		{
			return _propName;
		}
		
		public function set editLabel(value:String):void
		{
			_editLabel = value;
		}
		
		public function get editLabel():String
		{
			return _editLabel;
		}
		
		public function isFilePath():Boolean
		{
			// returns false by default to indicate that this property doesn't store a filePath
			// override in subclass for changed behaviour
			return false;
		}
		
		public function hasOwnSerialiser():Boolean
		{
			// no AbstractSimpleProperty class should provide its own serialiser
			// use the AbstractCustomProperty class if you want to provide your own data serialisation
			return false;
		}
		
		public function serialiseToXML(parentNode:XML):void
		{
			// this method is not used by AbstractSimpleProperty
			// use the AbstractCustomProperty class if you want to provide your own data serialisation
			throw new Error("Method not implemented by this class.");
			return null;
		}
		
		public function deserialiseFromXML(value:XML):void
		{
			// this method is not used by AbstractSimpleProperty
			// use the AbstractCustomProperty class if you want to provide your own data serialisation
			throw new Error("Method not implemented by this class.");
		}
		
		public function destroy():void
		{
		}
		
	}
}
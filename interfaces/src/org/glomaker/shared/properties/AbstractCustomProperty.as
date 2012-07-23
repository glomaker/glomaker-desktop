/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	import com.adobe.serialization.json.JSON;
	

	/**
	 * Provides an abstract base-class for more complex custom properties.
	 * When extending this class, you will need to override serialiseToXML() and deserialiseFromXML().
	 * 
	 * If you have no desire or no need to provide your own data serialisation, consider extending AbstractSimpleProperty instead.
	 * 
	 * @author Nils
	 */
	public class AbstractCustomProperty implements IComponentProperty
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
		public function AbstractCustomProperty(name:String, label:String = null, value:* = null)
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
			// all subclasses must provide their own serialisation code
			// extend the AbstractSimpleProperty class if you don't require custom serialisation
			return true;
		}
		
		public function serialiseToXML(parentNode:XML):void
		{
			// extend the AbstractSimpleProperty class if you don't require custom serialisation
			throw new Error("Abstract method - implement in subclass.");
			return null;
		}
		
		public function deserialiseFromXML(value:XML):void
		{
			// extend the AbstractSimpleProperty class if you don't require custom serialisation
			throw new Error("Abstract method - implement in subclass.");
		}
		
		public function destroy():void
		{
		}
		
		
		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		
		/**
		 * Utility method - serialises a single file path value into the correct output format expected by GLOMaker. 
		 * @param path The filepath value.
		 * @param tagName The name that should be used for the enclosing XML tag.
		 * @return An XML node in the format expected by GLOMaker.
		 * @see deserialiseFilePath() 
		 */		
		protected function serialiseFilePath( path:String, tagName:String ):XML
		{
			return <{tagName} isPath="true">{JSON.encode(path)}</{tagName}>;
		}
		
		
		/**
		 * Utility method - serialises an array storing file paths into the correct output format expected by GLOMaker.
		 * @param paths Array of paths - must be a one-dimensional array of strings
		 * @param tagName The name that should be used fo rthe enclosing XML tag.
		 * @return An XML node in the format expected by GLOMaker.
		 * @throws An Error if paths argument is null, an Error if the paths argument is not a one-dimensional array of strings.
		 * @see deserialiseFilePathArray()
		 */		
		protected function serialiseFilePathArray( paths:Array, tagName:String ):XML
		{
			// integrity check
			if(paths == null)
				throw new Error("Invalid argument - paths must be non-null.");

			for each(var o:Object in paths)
			{
				if(!(o is String))
					throw new Error("Invalid argument - paths must be a one-dimensional array of Strings.");
			}
			
			// encode
			return <{tagName} isPath="true">{JSON.encode(paths)}</{tagName}>;
		}
		
		
		/**
		 * Deserialises a file path XML node into the file path value itself. 
		 * @param pathNode The XML node - should be in the same format as supplied by serialiseFilePath()
		 * @return The file path value.
		 * @see serialiseFilePath();
		 */		
		protected function deserialiseFilePath( pathNode:XML ):String
		{
			return JSON.decode( pathNode.text() ) as String;
		}
		
		
		/**
		 * Deserialises a file path array XML node into the array of file path values itself. 
		 * @param pathNode The XML node - should be in the same format as supplied by serialiseFilePathArray()
		 * @return An array of file path value string instances.
		 * @see serialiseFilePathArray();
		 */
		protected function deserialiseFilePathArray( pathNode:XML ):Array
		{
			return JSON.decode( pathNode.text() ) as Array; 
		}
		
		
	}
}
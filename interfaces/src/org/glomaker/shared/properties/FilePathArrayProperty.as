/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	public class FilePathArrayProperty extends AbstractSimpleProperty
	{

		/**
		 * Default URL value.
		 * Used instead of null or "" to trigger missing image formatting. 
		 */		
		public static const NO_URL_VALUE:String = "FilePathProperty::NoUrlSet";
				
		
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function FilePathArrayProperty(propName:String, editLabel:String = null, propValue:Array = null)
		{
			super(propName, editLabel, propValue);
			
			// initialise to useful value
			if(!propValue)
				propValue = [];
		}
		
		
		/**
		 * Shows that this property stores a path to a file on the user's computer. 
		 * @return 
		 */
		override public function isFilePath():Boolean
		{
			return true;
		}
		
		
		/**
		 * Set the value stored by this property.
		 * Null values, "", " " are all overridden to be stored as FilePathProperty.NO_URL_VALUE.
		 * 
		 * The value must be an array.
		 * Each entry in the array must be a string.
		 * 
		 * @param val
		 */		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is Array))
				throw new Error("propValue for FilePathArrayProperty must be an Array.");
			
			// check type of each entry
			// and convert empty / null strings to NO_URL_VALUE (this is used to trigger broken image skins)
			var list:Array = value as Array;
			
			for each(var o:* in list)
			{
				if(o && !(o is String))
					throw new Error("All elements of propValue must be Strings");
					
				if(!o || o == " ")
					o = NO_URL_VALUE;
			}
			
			// save				
			super.propValue = list;
		}
		
	}
}
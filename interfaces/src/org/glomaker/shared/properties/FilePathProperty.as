/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	public class FilePathProperty extends AbstractSimpleProperty
	{

		/**
		 * Default URL value.
		 * Used instead of null or "" to trigger missing image formatting. 
		 */		
		public static const NO_URL_VALUE:String = "FilePathProperty::NoUrlSet";
				
		
		protected var _fileTypeLabel:String;
		protected var _fileExtensions:String;
		
		
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function FilePathProperty(propName:String, editLabel:String = null, propValue:String = NO_URL_VALUE)
		{
			super(propName, editLabel, propValue);
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
		 * Must be a string.
		 * Null values, "", " " are all overridden to be stored as FilePathProperty.NO_URL_VALUE.
		 * @param val
		 */		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is String))
				throw new Error("propValue of FilePathProperty must be a string");
			
			// default value
			if(!value || value == " ")
				value = NO_URL_VALUE;
			
			// assign
			super.propValue = value;
		}
		
		override public function get propValue():*
		{
			return super.propValue;
		}
		
		
		/**
		 * File type text label to show when browsing for this kind of file.
		 * eg: "Documents" or "Images" 
		 * @param value
		 */		
		public function set fileTypeLabel(value:String):void
		{
			_fileTypeLabel = value;
		}
		public function get fileTypeLabel():String
		{
			return _fileTypeLabel;
		}
		
		/**
		 * Extensions to filter the file selector by when browsing for this kind of file.
		 * eg: "*.pdf;*.doc;*.txt"
		 * @param value
		 * 
		 */
		public function set fileExtensions(value:String):void
		{
			_fileExtensions = value;
		}
		public function get fileExtensions():String
		{
			return _fileExtensions;
		}
	}
}
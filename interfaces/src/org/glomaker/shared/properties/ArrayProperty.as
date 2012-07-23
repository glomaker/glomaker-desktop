/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	
	/**
	 * Stores an Array (and nested Array) of primitive data types or objects.
	 * Can't be used to store file path values.
	 * 
	 * @author Nils
	 * @see FilePathArrayProperty
	 */	
	public class ArrayProperty extends AbstractSimpleProperty
	{
		public function ArrayProperty(propName:String, editLabel:String=null, propValue:Array = null)
		{
			super(propName, editLabel, propValue);
			
			// initialise to useful value
			if(!propValue)
				propValue = []; 
		}
		
		public function get valueArray():Array
		{
			return propValue as Array;
		}
		
		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is Array))
				throw new Error("propValue for ArrayProperty must be Array");
				
			super.propValue = value;
		}
		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	public class StringProperty extends AbstractSimpleProperty
	{
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function StringProperty(propName:String, editLabel:String = null, propValue:String = null)
		{
			super(propName, editLabel, propValue);
		}
		
		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is String))
				throw new Error("propValue of StringProperty must be a String");
				
			super.propValue = value;
		}		
		
	}
}
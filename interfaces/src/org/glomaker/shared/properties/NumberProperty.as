/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	public class NumberProperty extends AbstractSimpleProperty
	{
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function NumberProperty(propName:String, editLabel:String = null, propValue:Number = NaN)
		{
			super(propName, editLabel, propValue);
		}
		
		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is uint || value is int || value is Number))
				throw new Error("propValue of IntegerProperty must be a numeric value");
				
			super.propValue = value;
		}
		
	}
}
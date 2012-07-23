/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{

	/**
	 * Stores a (uint) colour value. 
	 * @author Nils
	 */
	public class ColourProperty extends AbstractSimpleProperty
	{
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function ColourProperty(propName:String, editLabel:String = null, propValue:int = -1)
		{
			super(propName, editLabel, propValue);
		}
		
		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is uint || value is int || value is Number))
				throw new Error("propValue of ColourProperty must be a numeric value");
				
			super.propValue = uint(value);
		}		
		
	}
}
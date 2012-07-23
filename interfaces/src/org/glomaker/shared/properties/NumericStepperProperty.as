/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	public class NumericStepperProperty extends IntegerProperty
	{
		
		public var minimum:Number = 0;
		public var maximum:Number = 100;
		

		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function NumericStepperProperty(propName:String, editLabel:String = null, propValue:int = -1)
		{
			super(propName, editLabel, propValue);
		}		
		
		
		// no additional code, IntegerProperty sorts out the rest
		
	}
}
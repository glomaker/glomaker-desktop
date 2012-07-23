/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	/**
	 * Stores a true/false Boolean value. 
	 * @author Nils
	 * 
	 */
	public class BooleanProperty extends AbstractSimpleProperty
	{
		/**
		 * Constructor 
		 * @param propName
		 * @param editLabel
		 * @param propValue
		 * 
		 */		
		public function BooleanProperty(propName:String, editLabel:String=null, propValue:Boolean = false)
		{
			super(propName, editLabel, propValue);
		}
		
		override public function set propValue(value:*):void
		{
			// type checking
			if(value && !(value is Boolean))
				throw new Error("propValue of BooleanProperty must be a Boolean");
				
			super.propValue = value;
		}
		
		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	import mx.controls.TextArea;
	
	public class RichTextProperty extends StringProperty
	{
		
		public var textArea:TextArea;
		
		/**
		 * Constructor 
		 * @param propName
		 * @param label
		 * @param value
		 */
		public function RichTextProperty(propName:String, editLabel:String = null, propValue:String = null)
		{
			super(propName, editLabel, propValue);
		}		
		
		override public function destroy():void
		{
			textArea = null;
		}
		
		// no additional code, StringProperty sorts out the rest
		
	}
}
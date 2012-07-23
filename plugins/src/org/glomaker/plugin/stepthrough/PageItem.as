/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.stepthrough
{
	/**
	 * Simple value-object class to store information about a page.
	 * This is used to make sure that we can use data in a list without creating duplicate items. 
	 * @author Nils
	 */
	public class PageItem
	{
		
		public var textValue:String = "";
		
		public function PageItem(textValue:String)
		{
			this.textValue = textValue;
		}

	}
}
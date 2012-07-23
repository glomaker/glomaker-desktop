/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	public class Size
	{
		
		public var width:Number;
		public var height:Number;
		
		public function Size(w:Number=10,h:Number=10)
		{
			width = w;
			height = h;
		}
		
		public function get asString():String
		{
			return width + "x" + height;
		}
		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	
	public class DescriptionNode01 extends DescriptionNode
	{
		public function DescriptionNode01(sqr:uint, c:uint)
		{
			super(sqr, c);
			
		}
		
		public function setType(type:String):void{
			
			var attachment:*;
			
			switch(type){
				// Multiple resides in the Flash Library
				case "multiple":
					// attachment = new Multiple();
					
					break;
			}
			
			this.addChild(attachment);
			this.setChildIndex(attachment, 0);
		}
	}
}
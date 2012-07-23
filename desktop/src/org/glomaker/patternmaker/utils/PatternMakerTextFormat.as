/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.utils
{
	import flash.text.TextFormat;
	import flash.text.engine.FontWeight;

	public class PatternMakerTextFormat extends TextFormat
	{
		public function PatternMakerTextFormat()
		{
			super();
			
			font = "Verdana";
			color = 0x000000;
			size = 12; 
			leading = 3;
		}
		
	}
}
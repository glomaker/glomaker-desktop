/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	public interface IPatternHeading
	{
		function set id(value:String):void;
		function get id():String;
		
		function set title(value:String):void;
		function get title():String;
		
		function set colour(value:uint):void;
		function get colour():uint;
		
		function set functions(value:Array):void;
		function get functions():Array;
	}
}
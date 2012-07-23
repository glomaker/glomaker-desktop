/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	public interface IPatternFunction
	{
		function set id(value:String):void;
		function get id():String;
		
		function set heading(value:IPatternHeading):void;
		function get heading():IPatternHeading;
		
		function set title(value:String):void;
		function get title():String;

		function set description(value:String):void;
		function get description():String;
		
		function set defaultLayoutId(value:String):void;
		function get defaultLayoutId():String;
		
		function set guidance(value:Array):void;
		function get guidance():Array;
	}
}
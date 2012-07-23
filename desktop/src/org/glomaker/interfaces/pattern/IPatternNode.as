/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.interfaces.pattern
{
	import org.glomaker.patternmaker.data.GlobalPoint;
	
	public interface IPatternNode
	{
		function set id(value:String):void;
		function get id():String;
		
		function set func(value:IPatternFunction):void;
		function get func():IPatternFunction;
		
		function set title(value:String):void;
		function get title():String;
		
		function set description(value:String):void;
		function get description():String;
		
		function set loc(value:GlobalPoint):void;
		function get loc():GlobalPoint;
		
		function set parentId(value:String):void;
		function get parentId():String;
		
		function set childId(value:String):void;
		function get childId():String;
		
		function set layoutId(value:String):void;
		function get layoutId():String;
		
		function set isRoot(value:Boolean):void;
		function get isRoot():Boolean;
		
		function set isActive(value:Boolean):void;
		function get isActive():Boolean;
		
		function set isReceiver(value:Boolean):void;
		function get isReceiver():Boolean;		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.properties
{
	
	/**
	 * Defines the interface for a data property used by an GLOMaker component plugin. 
	 * @author Nils
	 * 
	 */	
	public interface IComponentProperty
	{
		function set propValue(value:*):void;
		function get propValue():*;
		
		function set propName(value:String):void;
		function get propName():String;
		
		function set editLabel(value:String):void;
		function get editLabel():String;
		
		function isFilePath():Boolean;
		
		function hasOwnSerialiser():Boolean;
		function serialiseToXML(parentNode:XML):void;
		function deserialiseFromXML(value:XML):void;
		
		function destroy():void;
	}
}
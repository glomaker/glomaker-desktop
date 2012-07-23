		//############################################################
//
// EventObject.js : 
//
// CLASS:  EventObject
//
// The root class from which all event state objects shall be derived.
// All Events are constructed with a reference to the object, the "source",
// that is logically deemed to be the object upon which the Event in question
// initially occurred upon.
//
// Date : 5th January 2005 
//
//        By: Musbah Sagar : mus_sh@hotmail.com
// 
// (C) Oxford Brookes University 
//
//##################################################

package com.hotdraw.java.util {

	public class EventObject{
		
		public var source:* = null;
		
		public function EventObject(s:*){
			source = s;
		}
		
//*************
// The object on which the Event initially occurred.
//*************
public function getSource():*{
return source;
}
//*************
// Returns a String representation of this EventObject.
//*************
public function toString():String{
return  " EventObject [source=" + source + "]";
}



	}
}
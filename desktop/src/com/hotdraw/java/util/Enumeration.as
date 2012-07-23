//############################################################
//
// CLASS:  Enumeration {interface}
//
// An object that implements the Enumeration interface generates a
// series of elements, one at a time. Successive calls to the
// nextElement method return successive elements of the series.
//
//##################################################

// A tagging interface that all event listener interfaces must extend.


package com.hotdraw.java.util
{
	public interface Enumeration	{
		
     function hasMoreElements():Boolean ;
     function nextElement():* ;
		
	}
}
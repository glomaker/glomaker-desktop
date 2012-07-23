//############################################################
//
// Insets.js : 
//
// CLASS:  Insets
//
// An Insets object is a representation of the borders of a container.
// It specifies the space that a container must leave at each of its edges.
// The space can be a border, a blank space, or a title. 
//
// Date : 5th January 2005 
//
//        By: Musbah Sagar : mus_sh@hotmail.com
// 
// (C) Oxford Brookes University 
//
//##################################################

package com.hotdraw.java.awt {
	public class Insets{
		
		private var top:int;
		private var left:int;
		private var bottom:int;
		private var right:int;

		public function Insets(t:int, l:int, b:int, r:int){
			top = t;
			left = l;
			bottom = b;
			right = r;
		}

//*************
// Checks whether two insets objects are equal.
//*************
public function equals(insets:Insets):Boolean{
	    return ((top == insets.top) && (left == insets.left) &&
			        (bottom == insets.bottom) && (right == insets.right));
return false;
}
//*************
// Returns the hash code for this Insets.
//*************
public function hashCode():int{
 var sum1:int = left + bottom;
 var sum2:int = right + top;
 var val1:int = sum1 * (sum1 + 1)/2 + left;
 var val2:int = sum2 * (sum2 + 1)/2 + top;
 var sum3:int = val1 + val2;
 return sum3 * (sum3 + 1)/2 + val2;
}
//*************
// 
//*************
public function toString():String{
return " Insets [top="  + top + ",left=" + left + ",bottom=" + bottom + ",right=" + right + "]";
}
//*************
// Create a copy of this object.
//*************
public function clone():*{
//Not Implemented 
}





	}
}
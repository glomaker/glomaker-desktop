package com.hotdraw.java.util
{
	public class Enumerator implements Enumeration	{
		
		private var fEnumeration:Enumeration=null;;
		
		public function Enumerator(v:_Vector = null){
		 if(v!=null)
			fEnumeration = v.elements();
		}
		
//*************
// Returns true if the enumeration contains more elements; false if its empty.
//*************
public function hasMoreElements():Boolean{
return fEnumeration.hasMoreElements();
}
//*************
// Returns the next element of the enumeration. Calls to this method will enumerate successive elements.
//*************
public function nextElement = function():*{
return fEnumeration.nextElement();
}

	}
}
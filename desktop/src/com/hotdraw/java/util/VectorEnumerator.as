package com.hotdraw.java.util
{
	public class VectorEnumerator implements Enumeration{
		
		private var vector:_Vector = null;
		private var count:int=0;
		
		public function VectorEnumerator(v:_Vector){
			vector = v;
		}
		
//*************
// Returns true if the enumeration contains more elements; false if its empty.
//*************
public function hasMoreElements():Boolean{
return   (count < vector.size());
}
//*************
// Returns the next element of the enumeration. Calls to this method will enumerate successive elements.
//*************
public function nextElement():*{
      if(hasMoreElements()) 
		return (vector.elementAt(count++));
	  else
	    return null;										                      
}

	}
}
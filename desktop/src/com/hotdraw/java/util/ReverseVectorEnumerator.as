package com.hotdraw.java.util
{
	public class ReverseVectorEnumerator implements Enumeration	{
		
		private var vector:_Vector;
		private var count:int = 0;
		
		public function ReverseVectorEnumerator(v:_Vector){
			vector = v;
			count = vector.size() - 1;
		}


    


//*************
// Returns true if the Renumeration contains more elements; false if its empty.
//*************
public function hasMoreElements():Boolean{
return count >= 0;
}
//*************
// Returns the next element of the Renumeration.
//*************
public function nextElement():*{
if (count >= 0) {
  return vector.elementAt(this.count--);
  }
}





	}
}
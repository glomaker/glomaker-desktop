package com.hotdraw.java.util {
	public class _Vector	{
				
	private var elementData:Array;
	private var elementCount:int;
	private var initialCapacity:int;

		public function _Vector(){
			elementData=new Array(); // Virtually unlimited capacity
			elementCount=0;
			initialCapacity=10;
		}
		

//***************
// Returns the number of components in this vector.
//***************
public function size():int {
return elementCount;
}
//***************
// Returns the current capacity of this vector.
//***************
public function capacity():int {
return elementData.length;
}
//***************
// isEmpty
//***************
public function isEmpty():Boolean {
return elementCount == 0;
}
//***************
// elements : 
//
// This method create an implementation of Enumeration interface specially for Vecotr class,..
//***************
 public function elements():Enumeration {
 	
 	return new VectorEnumerator(clone());
 	
}
//***************
// Tests if the specified object is a component in this vector.
//***************
public function contains(elem:*):Boolean {
return indexOf(elem) >= 0;
}
//***************
// Searches for the first occurence of the given argument beginning the search at index
// Forms:
//======
// (1) indexOf(Object elem)
// (2) indexOf(Object elem,int index)
//***************
public function indexOf(elem:* = null, index:int = -1):int {

if(index == -1) index=0;

if (elem == null) {
	    for (var i:int = index ; i < size() ; i++)
		if (elementData[i]==null)
		    return i;
	} else {
	    for (i = index ; i <  size() ; i++){
		if (elem==elementData[i]) return i; // Original => if (elem.equals(elementData[i]))
		}
	}
	return -1;
}
//***************
// Returns the component at the specified index.
//***************
public function elementAt(i:int):*{
if (i >= elementCount) return null;
return elementData[i];
}
//***************
// Deletes the component at the specified index. Each component in this vector with an index greater or 
// equal to the specified index is shifted downward to have an index one smaller than the value it had previously. 
//***************
public function removeElementAt(i:int):void{
	if (i >= elementCount || i < 0) return;

	var temp:Array=new Array();
	var cnt:int=0;

	for(var j:int=0;j < elementCount ;j++){
	 if(j!=i){
	  temp[cnt]=elementData[j];
	  cnt++;
	 }
 }
/* delete elementData; */
 elementCount--;
 elementData=temp;
}
//***************
// Add Element
//***************
public function addElement(obj:*):* {
 elementData[elementCount++] = obj;	
return obj;
}
//***************
// Remove Element
//***************
public function removeElement(obj:*):Boolean {
	var i:int = indexOf(obj);
	if (i >= 0) {
	    removeElementAt(i);
	    return true;
	}
	return false;
}
//***************
// Removes all components from this vector and sets its size to zero.
//***************
public function removeAllElements():void {
clear();
}
//***************
// setElementAt
//***************
public function insertElementAt(obj:*,i:int):*{

if (i >= elementCount) return null;
	
	elementCount++;
	var temp:Array=new Array();
	var cnt:int=0;

	for(var j:int=0;j < elementCount ;j++){
	 if(j!=i){
	  temp[j]=elementData[cnt];
	  cnt++;
	 } else { temp[j]=obj; }
 }
/* delete elementData;*/
elementData=temp;
return obj;
}
//***************
// Sets the component at the specified index of this vector to be the specified object.
//***************
public function setElementAt(obj:*,i:int):void{
	if (i >= elementCount) return;
 elementData[i] = obj;
}
//***************
// clear
//***************
public function clear():void{
/*  delete elementData; */ 
elementData=new Array();
 elementCount=0;
}
//*************
// clone
//*************
public function clone():_Vector{
var cloneVector:_Vector = new _Vector();
 for (var i:* in elementData) 
     cloneVector.elementData[i]=elementData[i];
     cloneVector.elementCount=elementCount;
return cloneVector;
}


//***************
// toString
//***************
public function toString():String {
var ret:String=" _Vector (noe = "+size()+") [ ";

 for(var i:int=0;i<size() -1 ;i++)
  ret+=elementData[i]+", ";
 
 ret+=elementData[i]+" ]";
  
return ret;
}


	}
}
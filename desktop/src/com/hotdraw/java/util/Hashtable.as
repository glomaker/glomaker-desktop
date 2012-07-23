package com.hotdraw.java.util
{
	public class Hashtable
	{
		public var buffer:Array = null;
		
		public function Hashtable(deserializeString:String = null,chr1:String = null,chr2:String = null)
		{
			buffer = new Array();
			if(deserializeString!=null&&chr1!=null&&chr2!=null){
			 deserialize(deserializeString,chr1,chr2);
			}
		}

//*************
// 
//*************
public function clear():void{
 buffer = new Array();
}
//*************
// 
//*************
public function containsKey(key:*):Boolean{
  var exists:Boolean = false;
     for (var i:* in buffer) {
       if (i == key && buffer[i] != null) {
         exists = true;
         break;
       }
     }
return exists;
}
//*************
// 
//*************
public function containsValue(value:*):Boolean{
 var contains:Boolean = false;
   if (value != null) {
    for (var i:* in buffer) {
      if (buffer[i] == value) {
          contains = true;
          break;
      }
     }
    }
return contains;
}
//*************
// 
//*************
public function get(key:*):*{
return buffer[key];
}
//*************
// 
//*************
public function isEmpty():Boolean{
return (size() == 0) ? true : false;
}
//*************
// 
//*************
public function keys():Array{
 var keys:Array = new Array();
  for (var i:* in buffer) {
    if (buffer[i] != null) 
      keys.push(i);
    }
return keys;
}
//*************
// 
//*************
public function put(key:*,value:*):void{

  if(key == undefined || value == undefined) return;
	
  if (key == null || value == null) {
    throw Error("NullPointerException {" + key + "},{" + value + "}");
  }else{
  buffer[key] = value;
 }
}
//*************
// 
//*************
public function remove(key:*):void{
 buffer[key] = null;
// return rtn;
}
//*************
// 
//*************
public function size():int{
 var size:int = 0;
  for (var i:* in buffer) {
    if (buffer[i] != null) 
    size ++;
   }
return size;
}
//*************
// 
//*************
public function values():Array{
 var values:Array = new Array();
   for (var i:* in buffer) {
     if (buffer[i] != null) 
       values.push(buffer[i]);
     }
return values;
}
//*************
// clone
//*************
public function clone():Hashtable{
var ret:Hashtable=new Hashtable();
 for (var i:* in buffer) 
     ret.buffer[i]=buffer[i];
return ret;
}
//*************
// serialize
// Returns the content of the Hashtable as a string: ( key1:value1;key2:value2,..)
//*************
public function serialize(chr1:String=null,chr2:String=null):String{
  if(chr1==null)chr1= ":";
  if(chr2==null)chr2= ";";
  var result:String = "";
    for (var i:* in buffer)      
     if (buffer[i] != null) {
		  // Ensure that all instances of the char ":" is replaced by char "^" for the serialization to succeed
			var para1:String = (i+"").replace(/:/g, "^");
			var para2:String = (buffer[i]+"").replace(/:/g, "^");
      result += para1 + chr1 + para2 + chr2;   
     }
 return result;
}
//*************
// deserialize 
// Adds values to the Hastable from a string,..
//*************
public function deserialize(str:String=null,chr1:String=null,chr2:String=null):void{

if(chr1==null)chr1= ":";
if(chr2==null)chr2= ";";

if(str == null)return;

var s:Array = str.split(chr2); 

 for(var i:int=0;i<s.length;i++){
 var m:Array=s[i].split(chr1);
 // Ensure that all instances of the char "^" is replaced by char ":" for the deserialization to succeed
   if(m[0] != undefined && m[1] != undefined) {
    var para1:String = (m[0]+"").replace(/\^/g, ":");
    var para2:String = (m[1]+"").replace(/\^/g, ":");
    put(para1,para2);
	 }
 }
 
}
//*************
// toString
//*************
public function toString():String{
 var result:String = "Hashtable [";
   for (var i:* in buffer){      
    if (buffer[i] != null) 
     result += "{" + i + "},{" + buffer[i] + "}\n";   
    }
result+="]";
return result;
}
                  














	}
	
}
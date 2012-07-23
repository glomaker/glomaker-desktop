package com.hotdraw.java.awt.geom
{
	public class Dimension{
		
		public var width :int = 0;
		public var height:int = 0;
				
		
// Forms:
// (1) Dimension();
// (2) Dimension(width,height);
// (3) Dimension(Dimension d);
public function Dimension(w:* = null,h:* = null){  

if(!w&&!h){w=0;h=0;}

if(w is Dimension) {
	  var d:Dimension=w;
	      w=d.getWidth();
	      h=d.getHeight();
	}

   width=w;
   height=h;
}
//*************
// Returns the width   
//*************
public function getWidth():int { 
return width;
}
//*************
// Returns the height  
//*************
public function getHeight():int { 
return height;
}
//*************
// Sets the size to a specified width and height 
// (1) Dimension(width,height);
// (2) Dimension(Dimension d);
//*************
public function setSize(w:*,h:*):void { 
if(w is Dimension) {
	  var d:Dimension=w;
	      w=d.getWidth();
	      h=d.getHeight();
	}
 width = Math.ceil(w);
 height = Math.ceil(h);
}
//*************
// Gets the size of this Dimension object. 
//*************
public function getSize():Dimension { 
return new Dimension(this);
}
//*************
// Checks whether two dimension objects have equal values. 
//*************
public function equals(obj:Dimension):Boolean { 
	 if(obj.getWidth()==this.getWidth()&&obj.getHeight()==this.getHeight())return true;
return false;
}
//*************
// Returns the hash code for this <code>Dimension</code>. 
//*************
public function hashCode():int { 
  var sum:int = width + height;
  return sum * (sum + 1)/2 + width;
}
//*************
// Returns a string representation 
//*************
 public function toString():String { 
return " Dimension [width=" + width + ",height=" + height + "]";
} 


	}
}
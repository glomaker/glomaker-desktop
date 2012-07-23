

package com.hotdraw.java.awt.geom {
	
	public class _Point extends Point2D{  

	   // Forms:
       // (1) Point();
       // (2) Point(x,y);
       // (3) Point(Point pt);

		public function _Point(xx:* = null,yy:* = null){
			
		  if(!xx&&!yy){xx=0;yy=0;}
		  
          if(xx is _Point) {
	        var pt:_Point=xx;
	        xx=pt.getX();
	        yy=pt.getY();
	  }
    x=xx;
    y=yy;
}
	
//*************
// Returns the location of this point.  
//*************
public function getLocation():_Point { 
return new _Point(this.x,this.y);
}
//*************
// Sets the location  
//
// Forms:
//=======
// (1) setLocation(x,y)
// (2) setLocation(Point pt)
//*************
override public function setLocation(x:*,y:*):void {
if(x is _Point) {
	  var pt:_Point=x;
	      x=pt.getX();
	      y=pt.getY();
	} 
this.move(x,y);
}
//*************
// Moves this point to the specified location 
//*************
public function move(x:int,y:int):void{ 
 x=Math.floor(x+0.5);
 y=Math.floor(y+0.5);
}
//*************
// Translates this point, at location x,y, by dx and dy 
//*************
public function translate(dx:int,dy:int):void { 
 x += dx;
 y += dy;
}
//*************
// Determines whether or not two points are equal.  
//
// Two instances of Point are equal if the values of their x and y member fields,
// representing their position in the coordinate space, are the same.
//*************
override public function equals(obj:*):Boolean { 
	if(obj is _Point)
	 if(obj.getX()==this.getX()&&obj.getY()==this.getY())return true;
return false;
}

//*************
// Returns a string representation 
//*************
 override public function toString():String { 
return " Point [x=" + x + ",y=" + y + "]";
} 



	}
}









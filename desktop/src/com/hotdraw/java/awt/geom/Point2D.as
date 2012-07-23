package com.hotdraw.java.awt.geom
{
	public class Point2D	{
		
	  public var x:int;
	  public var y:int;


		public function Point2D(xx:int = 0,yy:int = 0){
			x=xx;
			y=yy;
		}


//*************
// Returns the X coordinate  
//*************
public function getX():int { 
 return x; 
}
//*************
// Returns the Y coordinate  
//*************
public function getY():int { 
 return y; 
}
//*************
// Sets the location  
//*************
public function setLocation(xx:*,yy:*):void { 
x=xx;
y=yy;
}
//*************
// Sets the location  
//*************
public function toString():String{ 
 return " Point2D ["+x+", "+y+"]";
}
//*************
// Returns the square of the distance between two points.  
// OR 
// Returns the square of the distance between this point and another point.
//
// Forms:
// ======
// (1) distanceSq(Point2D pt)
// (2) distanceSq(x1,y1)
// (3) distanceSq(x1,y1,x2,y2)
//*************
public function distanceSq(x1:*=null,y1:*=null,x2:*=null,y2:*=null):int { 
 /* (1) */
	if(x1 is Point2D) {
	  var pt:Point2D=x1;
	      x1=pt.getX();
	      y1=pt.getY();
	}
	/* (2) */
  if(!x2&&!y2){
	  x2=getX();
	  y2=getY();
	}
	x1 -= x2;
	y1 -= y2;
	return (x1 * x1 + y1 * y1);
}
//*************
// Returns the distance between two points.  
// OR 
// Returns the distance between this point and another point.
// 
// Forms:
// ======
// (1) distance(Point2D pt)
// (2) distance(x1,y1)
// (3) distance(x1,y1,x2,y2)
//*************
public function distance(x1:*=null,y1:*=null,x2:*=null,y2:*=null):int { 
  /* (1) */
	if(x1 is Point2D) {
	  var pt:Point2D=x1;
	      x1=pt.getX();
	      y1=pt.getY();
	}
	/* (2) */
  if(!x2&&!y2){
	  x2=getX();
	  y2=getY();
	}
  x1 -= x2;
  y1 -= y2;
	return Math.sqrt(x1 * x1 + y1 * y1);
}
//*************
// Creates a new object of the same class and with the same contents as this object.  
//*************
public function clone():Point2D { 
return this;
}
//*************
// Determines whether or not two points are equal.  
//
// Two instances of Point2D are equal if the values of their x and y member fields,
// representing their position in the coordinate space, are the same.
//*************
public function equals(obj:*):Boolean { 
	if(obj is Point2D)
	 if(obj.getX()==getX()&&obj.getY()==getY())return true;
return false;
}







	}
}
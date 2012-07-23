package com.hotdraw.java.awt.geom
{
	public class _Rectangle extends Rectangle2D{
		
// Forms:
// =====
// (1) Rectangle();
// (2) Rectangle(Rectangle r);
// (3) Rectangle(x,y,width,height);
// (4) Rectangle(width,height);
// (5) Rectangle(Point p, Dimension d) 
// (6) Rectangle(Point p) 
// (7) Rectangle(Dimension d) 

public function _Rectangle(_x:*=null,_y:*=null,w:*=null,h:*=null){
		var p:_Point;
		var d:Dimension;
		
/* No parameters */
if(!_x&&!_y&&!w&&!h){_x=0;_y=0;w=0;h=0;}

// Two parameters */
if(_x&&_y&&!w&&!h){
  if(_x is _Point && _y is Dimension) {
    p=_x;
	d=_y;
	    _x=p.getX();
		_y=p.getY();
		w=d.getWidth();
		h=d.getHeight();
	    } 
	else {
    w=_x;h=_y;_x=0;_y=0;
       }
}
/* One parameter */
if(_x is _Rectangle) {
	  var r:_Rectangle=_x;
	      _x=r.getX();
	      _y=r.getY();
		  w=r.getWidth();
		  h=r.getHeight();
	}
else	
if(_x is _Point) {
	  p=_x;
	      _x=p.getX();
	      _y=p.getY();
		  w=0;
		  h=0;
	}
else
if(_x is Dimension) {
	  d=_x;
	      _x=0;
	      _y=0;
		  w=d.getWidth();
		  h=d.getHeight();
	}

/* Four parameters or one of the above */
reshape(_x,_y,w,h);
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
// Gets the bounding Rectangle of this Rectangle.  
//*************
public function getBounds():_Rectangle { 
return new _Rectangle(x,y,width,height);
}
//*************
// Return the high precision bounding box of this rectangle.  
//*************
public function getBounds2D():* { 
return new _Rectangle(x, y, width, height);
}
//*************
// Sets the bounding Rectangle of this Rectangle  
// 
// Forms:
// ======
// (1) setBounds(Rectangle r);
// (2) setBounds(x,y,width,height);
//*************
public function setBounds(_x:*=null,_y:*=null,w:*=null,h:*=null):void { 

if(_x is _Rectangle) {
	  var r:_Rectangle=_x;
		setBounds(r.getX(),r.getY(),r.getWidth(),r.getHeight());
		return;
	}
reshape(_x, _y, w, h);
}
//*************
// Sets the bounds of this Rectangle to the specified x, y, width,and height.  
//*************
public function setRect(_x:Number,_y:Number,w:Number,h:Number):void { 
	var  x0:int =  Math.floor(_x);
	var  y0:int =  Math.floor(_y);
	var  x1:int =  Math.ceil(_x+w);
	var  y1:int =  Math.ceil(_y+h);
	setBounds(x0, y0, x1-x0, y1-y0);
} 
//*************
// Sets the bounding Rectangle of this Rectangle to the specified x, y, width, and height.  
//*************
public function reshape(_x:int,_y:int,w:int,h:int):void { 
	x = _x;
	y = _y;
	width = w;
	height = h;
} 
//*************
// Returns the location of this Rectangle.  
//*************
public function getLocation():_Point { 
return new _Point(x,y);
} 
//*************
// Moves this Rectangle to the specified location.  
//
// Forms:
// ======
// (1) setLocation(x,y)
// (2) setLocation(Point p)
//*************
public function setLocation(_x:*=null,_y:*=null):void { 
if(_x is _Point) {
	  var p:_Point=_x;
	  setLocation(p.getX(),p.getY());
		return;
	}
move(_x,_y);
} 
//*************
// Moves this Rectangle to the specified location.  
//*************
public function move(_x:int,_y:int):void{ 
	x = _x;
	y = _y;
} 
//*************
// Translates this point, at location x,y, by dx and dy 
//*************
public function translate(dx:int,dy:int):void { 
x += dx;
y += dy;
}
//*************
// Gets the size of this Rectangle, represented by the returned Dimension. 
//*************
public function getSize():Dimension { 
return new Dimension(width,height);
}
//*************
// Sets the size of this Rectangle  
//
// Forms:
// ======
// (1) setSize(width,height)
// (2) setSize(Dimension d)
//*************
public function setSize(w:*=null,h:*=null):void { 
if(w is Dimension) {
	  var d:Dimension=w;
		setSize(d.getWidth(),d.getHeight());
		return;
	}
resize(w, h);
}
//*************
// Sets the size of this Rectangle to the specified width and height. 
//*************
public function resize(w:int,h:int):void{ 
width = w;
height = h;
}
//*************
// Checks whether or not this Rectangle contains the specified Point.
//
// Forms:
// ======
// (1) contains(x,y)
// (2) contains(Point p) 
// (3) contains(x,y,width,height) 
// (3) contains(Rectangle r) 
//*************
public function contains(_x:*=null,_y:*=null,w:*=null,h:*=null):Boolean { 
// One parameters 
if(_x is _Point) {
	 var p:_Point=_x;
   return contains(p.getX(),p.getY());
	}
if(_x is _Rectangle) {
	 var r:_Rectangle=_x;
   return contains(r.getX(),r.getY(),r.getWidth(),r.getHeight());
 	 }
// Two parameters 
if(_x&&_y&&!w&&!h) return inside(_x,_y);
// Four parameters 
// Checs whether this Rectangle entirely contains the Rectangle at the specified location
    var X:int = _x;
	var Y:int = _y;
	var W:int = w;
	var H:int = h;
	
    w = width;
	h = height;
	
	if ((w | h | W | H) < 0) {return false;}    // At least one of the dimensions is negative...

	if (X < x || Y < y) {return false;} // Note: if any dimension is zero, tests below must return false...
	w += x;
	W += X;
	if (W <= X) {
	    // X+W overflowed or W was zero, return false if...
	    // either original w or W was zero or
	    // x+w did not overflow or
	    // the overflowed x+w is smaller than the overflowed X+W
	    if (w >= x || W > w) {return false;}
	} else {
	    // X+W did not overflow and W was not zero, return false if...
	    // original w was zero or
	    // x+w did not overflow and x+w is smaller than X+W
	    if (w >= x && W > w) {return false;}
	}
	h += y;
	H += Y;
	if (H <= Y) {
	    if (h >= y || H > h) {return false;}
	} else {
	    if (h >= y && H > h) {return false;}
	}
	return true;
}
//*************
// Checks whether or not this Rectangle contains the point at the specified location 
//*************
public function inside(X:int,Y:int):Boolean{ 

	var w:int = width;
	var h:int = height;
	if ((w | h) < 0) {return false;}   // At least one of the dimensions is negative...
	if (X < x || Y < y) { return false;}// Note: if either dimension is zero, tests below must return false...
	w += x;
	h += y;
	//    overflow || intersect
	return ((w < x || w > X) &&	(h < y || h > Y));
}
//*************
// Determines whether or not this Rectangle and the specified Rectangle intersect.
//
// Two rectangles intersect if their intersection is nonempty.
//*************
public function intersects(r:_Rectangle):Boolean{  
    var tw:int = width;
	var th:int = height;
	var rw:int = r.width;
	var rh:int = r.height;
	if (rw <= 0 || rh <= 0 || tw <= 0 || th <= 0) {
	    return false;
	}
	var tx:int = x;
	var ty:int = y;
	var rx:int = r.x;
	var ry:int = r.y;
	rw += rx;
	rh += ry;
	tw += tx;
	th += ty;
	//      overflow || intersect
	return ((rw < rx || rw > tx) &&	(rh < ry || rh > ty) &&	(tw < tx || tw > rx) &&	(th < ty || th > ry));
}
//*************
// Computes the intersection of this Rectangle with the specified Rectangle.
//
//Returns a new Rectangle that represents the intersection of the two rectangles.
//If the two rectangles do not intersect, the result will be an empty rectangle.
//*************
public function intersection(r:_Rectangle):_Rectangle {   
    var tx1:int = x;
	var ty1:int = y;
	var rx1:int = r.x;
	var ry1:int = r.y;
	var tx2:int = tx1; tx2 += width;
	var ty2:int = ty1; ty2 += height;
	var rx2:int = rx1; rx2 += r.width;
	var ry2:int = ry1; ry2 += r.height;
	if (tx1 < rx1) tx1 = rx1;
	if (ty1 < ry1) ty1 = ry1;
	if (tx2 > rx2) tx2 = rx2;
	if (ty2 > ry2) ty2 = ry2;
	tx2 -= tx1;
	ty2 -= ty1;
	// tx2,ty2 will never overflow (they will never be
	// larger than the smallest of the two source w,h)
	// they might underflow, though...
	if (tx2 < MIN_VALUE) tx2 = MIN_VALUE;
	if (ty2 < MIN_VALUE) ty2 = MIN_VALUE;
	return new _Rectangle(tx1, ty1, tx2, ty2);
}
//*************
// Computes the union of this Rectangle with the specified Rectangle.
//
// Returns a new Rectangle that represents the union of the two rectangles
//*************
public function union(r:_Rectangle):_Rectangle { 
    var x1:int = Math.min(x, r.x);
	var x2:int = Math.max(x + width, r.x + r.width);
	var y1:int = Math.min(y, r.y);
	var y2:int = Math.max(y + height, r.y + r.height);
	return new _Rectangle(x1, y1, x2 - x1, y2 - y1);
}   
//*************
// Adds a point, specified by the integer arguments newx and newy, to this Rectangle. 
// OR
// Adds a Rectangle to this Rectangle.
//
// The resulting Rectangle is the smallest Rectangle that contains both the original 
// Rectangle and the specified point OR The resulting Rectangle is the union of the two rectangles.
//
// After adding a point/rectangle, a call to contains with the added point as an argument does 
// not necessarily return true. 
// The contains method does not return true for points on the right or bottom edges of a Rectangle. 
// Therefore, if the added point falls on the right or bottom edge of the enlarged Rectangle, 
// contains returns false for that point.
//
// Forms:
// ======
// (1) add(point pt)
// (2) add(newx, newy)
// (3) add(Rectangle r)
//*************
public function add(newx:*=null,newy:*=null,newwidth:*=null,newheight:*=null):void { 

  if(newx is _Point) {
	 var pt:_Point=newx;
     add(pt.getX(),pt.getY(),0,0);
	 return;
	} 
  if(newx is _Rectangle) {
	 var r:_Rectangle=newx;
     add(r.getX(),r.getY(),r.getWidth(),r.getHeight());
	 return;
	} 
	
	var x1:int = Math.min(x, newx);
	var x2:int = Math.max(x + width, newx+newwidth);
	var y1:int = Math.min(y, newy);
	var y2:int = Math.max(y + height, newy+newheight);
	x = x1;
	y = y1;
	width = x2 - x1;
	height = y2 - y1;  
}   
//*************
// Resizes the Rectangle both horizontally and vertically.
//
// This method modifies the Rectangle so that it is h units larger on both the left and right side,
// and v units larger at both the top and bottom. 
//*************
public function grow(h:int,v:int):void { 
    this.x -= h;
	this.y -= v;
	this.width += h * 2;
	this.height += v * 2;
}   
//*************
// Determines whether or not this Rectangle is empty. 
//
// A Rectangle is empty if its width or its height is less than or equal to zero.
//*************
public function isEmpty():Boolean { 
return (width <= 0) || (height <= 0);
}   
//*************
// Determines where the specified coordinates lie with respect to this Rectangle. 
//
// This method computes a binary OR of the appropriate mask values indicating, for each side of this 
// Rectangle, whether or not the specified coordinates are on the same side of the edge as the rest of this Rectangle.
//*************
public function outcode(_x:int,_y:int):int { 
   /*
	 * Note on casts to double below.  If the arithmetic of
	 * x+w or y+h is done in int, then we may get integer
	 * overflow. By converting to double before the addition
	 * we force the addition to be carried out in double to
	 * avoid overflow in the comparison.
	 */
	 
	
  var out:int = 0;
	if (width <= 0) {
	    out |= OUT_LEFT | OUT_RIGHT;
	} else if (_x < x) {
	    out |= OUT_LEFT;
	} else if (_x > x + width) {
	    out |= OUT_RIGHT;
	}
	if (height <= 0) {
	    out |= OUT_TOP | OUT_BOTTOM;
	} else if (_y < y) {
	    out |= OUT_TOP;
	} else if (_y > y + height) {
	    out |= OUT_BOTTOM;
	}
	return out;
}   
//*************
// Returns a new Rectangle2D object representing the intersection of this Rectangle with the specified Rectangle2D. 
//
// A Rectangle is empty if its width or its height is less than or equal to zero.
//*************
public function createIntersection(r:_Rectangle):_Rectangle { 
	if (r is _Rectangle) {
	    return intersection(r);
	}
/*
  NOT IMPLEMENTED 
	Rectangle2D  var dest = new Rectangle2D.Double();
	Rectangle2D.intersect(this, r, dest);
	return dest;
*/
return null;
}      
//*************
// Returns a new Rectangle2D object representing the union of this Rectangle with the specified Rectangle2D. 
//*************
public function createUnion(r:_Rectangle):_Rectangle { 
	if (r is _Rectangle) {
	    return union(r);
	}
/*
  NOT IMPLEMENTED 
  Rectangle2D dest = new Rectangle2D.Double();
	Rectangle2D.union(this, r, dest);
	return dest;
 */
return null;  // [Remove]
}      
//*************
// Checks whether two rectangles are equal. 
//
// The result is true if and only if the argument is not null and is a Rectangle 
// object that has the same top-left corner, width, and height as this Rectangle. 
// 
// Forms:
// ======
// (1) equals(Rectangle r)
// (2) equals(Rectangle2D r)
//*************
public function equals(obj:_Rectangle):Boolean { 
if (obj is _Rectangle) {
	    var r:_Rectangle = obj;
	    return ((x == r.x) && (y == r.y) &&  (width == r.width) &&   (height == r.height));
	}
/*
 NOT IMPLEMENTED 
 return super.equals(obj);	
*/
return false;		// [Remove]
}     

//*************
// Checks whether two rectangles are equal. 
//*************
override public function toString():String {
return " _Rectangle [x=" + x + ",y=" + y + ",width=" +  width + ",height=" +  height + "]";
}



	}
}
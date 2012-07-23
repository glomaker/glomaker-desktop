/*
 * @(#)Rectangle2D.java	1.28 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */

package com.hotdraw.java.awt.geom {
/**
 * The <code>Rectangle2D</code> class describes a rectangle
 * defined by a location (x,&nbsp;y) and dimension 
 * (w&nbsp;x&nbsp;h).
 * <p>
 * This class is only the abstract superclass for all objects that
 * store a 2D rectangle.
 * The actual storage representation of the coordinates is left to
 * the subclass.
 *
 * @version 	1.28, 01/23/03
 * @author	Jim Graham
 */
public class Rectangle2D {
    /**
     * The bitmask that indicates that a point lies to the left of
     * this <code>Rectangle2D</code>.
     * @since 1.2
     */
    public static var OUT_LEFT:int= 1;

    /**
     * The bitmask that indicates that a point lies above
     * this <code>Rectangle2D</code>.
     * @since 1.2
     */
    public static var OUT_TOP:int= 2;

    /**
     * The bitmask that indicates that a point lies to the right of
     * this <code>Rectangle2D</code>.
     * @since 1.2
     */
    public static var OUT_RIGHT:int= 4;

    /**
     * The bitmask that indicates that a point lies below
     * this <code>Rectangle2D</code>.
     * @since 1.2
     */
    public static var OUT_BOTTOM:int= 8;
    
    public static var MIN_VALUE:Number  = -2147483648;
    public static var MAX_VALUE:Number  = 2147483647;

    public var x:int=0;
    public var y:int=0;
    public var width:int=0;
    public var height:int=0;
    

//*************
// Checks whether two rectangles are equal. 
//*************
public function toString():String {
return " Rectangle2D [x=" + x + ",y=" + y + ",width=" +  width + ",height=" +  height + "]";
}
}
}
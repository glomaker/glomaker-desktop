/*
 * @(#)Handle.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;

/**
 * Handles are used to change a figure by direct manipulation.
 * Handles know their owning figure and they provide methods to
 * locate the handle on the figure and to track changes.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld004.htm>Adapter</a></b><br>
 * Handles adapt the operations to manipulate a figure to a common interface.
 *
 * @see Figure
 */
public interface Handle {

    // public static const HANDLESIZE:int= 8;

    /**
     * Locates the handle on the figure. The handle is drawn
     * centered around the returned point.
     */
    function locate():_Point ;

    /**
     * @deprecated As of version 4.1,
     * use invokeStart(x, y, drawingView)
     * Tracks the start of the interaction. The default implementation
     * does nothing.
     * @param x the x position where the interaction started
     * @param y the y position where the interaction started
     */
    function invokeStart(x:int, y:int, m:*):void;

    /**
     * @deprecated As of version 4.1,
     * use invokeStart(x, y, drawingView)
     * Tracks the start of the interaction. The default implementation
     * does nothing.
     * @param x the x position where the interaction started
     * @param y the y position where the interaction started
     * @param view the handles container
     * 
     * OR
     * 
     * @deprecated As of version 4.1,
     * use invokeStep(x, y, anchorX, anchorY, drawingView)
     *
     * Tracks a step of the interaction.
     * @param dx x delta of this step
     * @param dy y delta of this step
     * 
     * OR
     * 
     *  /**
     * Tracks a step of the interaction.
     * @param x the current x position
     * @param y the current y position
     * @param anchorX the x position where the interaction started
     * @param anchorY the y position where the interaction started
     * 
     * Forms:
     * (1)invokeStart(x:int, y:int, view:DrawingView):void ;
     * (2)invokeStep(dx:int, dy:int, drawing:Drawing):void ;
     * (3)invokeStep(x:int, y:int, anchorX:int, anchorY:int, view:DrawingView):void ;
     * 
     */
     
     
    function invokeStep(m:int, n:int, o:*, p:*=null, q:*=null):void ;

    /**
     * Tracks the end of the interaction.
     * @param x the current x position
     * @param y the current y position
     * @param anchorX the x position where the interaction started
     * @param anchorY the y position where the interaction started
     * 
     * OR
     * 
     * @deprecated As of version 4.1,
     * use invokeEnd(x, y, anchorX, anchorY, drawingView).
     *
     * Tracks the end of the interaction.
     * 
     * Forms:
     * 
     * (1)function invokeEnd(dx:int, dy:int, drawing:Drawing):void ;
     * (2)function invokeEnd(x:int, y:int, anchorX:int, anchorY:int, view:DrawingView):void ;
     * 
     */
     
    function invokeEnd(m:int, n:int, o:*, p:*=null, q:*=null):void ;

    /**
     * Gets the handle's owner.
     */
    function ownerFigure():Figure ;

    /**
     * Gets the display box of the handle.
     */
    function displayBox():_Rectangle ;

    /**
     * Tests if a point is contained in the handle.
     */
    function containsPoint(x:int, y:int):Boolean ;
    
    /**
     * Draws this handle.
     */
    function draw(g:Graphics):void ;
  
}
}
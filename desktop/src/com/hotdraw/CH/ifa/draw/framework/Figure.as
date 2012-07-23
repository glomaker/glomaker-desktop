/*
 * @(#)Figure.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.Insets;
import com.hotdraw.java.awt.geom.Dimension;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util._Vector;

/**
 * The interface of a graphical figure. A figure knows
 * its display box and can draw itself. A figure can be
 * composed of several figures. To interact and manipulate
 * with a figure it can provide Handles and Connectors.<p>
 * A figure has a set of handles to manipulate its shape or attributes.
 * A figure has one or more connectors that define how
 * to locate a connection point.<p>
 * Figures can have an open ended set of attributes.
 * An attribute is identified by a string.<p>
 * Default implementations for the Figure interface are provided
 * by AbstractFigure.
 *
 * @see Handle
 * @see Connector
 * @see AbstractFigure
 */

public interface Figure /* extends Storable, Cloneable, Serializable */ {

    /**
     * Moves the Figure to a new location.
     * @param x the x delta
     * @param y the y delta
     */
    function moveBy(dx:int, dy:int):void ;

    /**
     * Changes the display box of a figure. This method is
     * always implemented in figure subclasses.
     * It only changes
     * the displaybox and does not announce any changes. It
     * is usually not called by the client. Clients typically call
     * displayBox to change the display box.
     * @param origin the new origin
     * @param corner the new corner
     * @see #displayBox
     */
    function basicDisplayBox(origin:_Point, corner:_Point):void ;

    /**
     * Changes the display box of a figure. Clients usually
     * invoke this method. It changes the display box
     * and announces the corresponding changes.
     * @param origin the new origin
     * @param corner the new corner
     * @see #displayBox
     * 
     * OR
     * 
     * Gets the display box of a figure
     * @see #basicDisplayBox
     */
    function displayBox(origin:*=null, corner:*=null):_Rectangle;


    /**
     * Draws the figure.
     * @param g the Graphics to draw into
     */
    function draw(g:Graphics):void ;

    /**
     * Returns the handles used to manipulate
     * the figure. Handles is a Factory Method for
     * creating handle objects.
     *
     * @return a Vector of handles
     * @see Handle
     */
    function handles():_Vector;

    /**
     * Gets the size of the figure
     */
    function size():Dimension;

    /**
     * Gets the figure's center
     */
    function center():_Point ;

    /**
     * Checks if the Figure should be considered as empty.
     */
    function isEmpty():Boolean ;

    /**
     * Returns an Enumeration of the figures contained in this figure
     */
    function figures():FigureEnumeration ;

    /**
     * Returns the figure that contains the given point.
     */
    function findFigureInside(x:int, y:int):Figure ;

    /**
     * Checks if a point is inside the figure.
     */
    function containsPoint(x:int, y:int):Boolean ;

    /**
     * Returns a Clone of this figure
     */
    function clone():Object ;

    /**
     * Checks whether the given figure is contained in this figure.
     */
    function includes(figure:Figure):Boolean ;

    /**
     * Decomposes a figure into its parts. A figure is considered
     * as a part of itself.
     */
    function decompose():FigureEnumeration ;

    /**
     * Sets the Figure's container and registers the container
     * as a figure change listener. A figure's container can be
     * any kind of FigureChangeListener. A figure is not restricted
     * to have a single container.
     */
    function addToContainer(c:FigureChangeListener):void ;

    /**
     * Removes a figure from the given container and unregisters
     * it as a change listener.
     */
    function removeFromContainer(c:FigureChangeListener):void ;

    /**
     * Gets the Figure's listeners.
     */
    function listener():FigureChangeListener ;

    /**
     * Adds a listener for this figure.
     */
    function addFigureChangeListener(l:FigureChangeListener):void ;

    /**
     * Removes a listener for this figure.
     */
    function removeFigureChangeListener(l:FigureChangeListener):void ;

    /**
     * Releases a figure's resources. Release is called when
     * a figure is removed from a drawing. Informs the listeners that
     * the figure is removed by calling figureRemoved.
     */
    function release():void ;

    /**
     * Invalidates the figure. This method informs its listeners
     * that its current display box is invalid and should be
     * refreshed.
     */
    function invalidate():void ;

    /**
     * Informes that a figure is about to change such that its
     * display box is affected.
     * Here is an example of how it is used together with changed()
     * <pre>
     * public void move(int x, int y) {
     *      willChange();
     *      // change the figure's location
     *      changed();
     *  }
     * </pre>
     * @see #invalidate
     * @see #changed
     */
    function willChange():void ;

    /**
     * Informes that a figure has changed its display box.
     * This method also triggers an update call for its
     * registered observers.
     * @see #invalidate
     * @see #willChange
     *
     */
    function changed():void ;

    /**
     * Checks if this figure can be connected
     */
    function canConnect():Boolean ;

    /**
     * Gets a connector for this figure at the given location.
     * A figure can have different connectors at different locations.
     */
/*     function connectorAt(x:int, y:int):Connector ;
 */
    /**
     * Sets whether the connectors should be visible.
     * Connectors can be optionally visible. Implement
     * this method and react on isVisible to turn the
     * connectors on or off.
     */
    function connectorVisibility(isVisible:Boolean):void ;

    /**
     * Returns the connection inset. This is only a hint that
     * connectors can use to determine the connection location.
     * The inset defines the area where the display box of a
     * figure should not be connected.
     *
     */
    function connectionInsets():Insets;

    /**
     * Returns the locator used to located connected text.
     */
/*     function connectedTextLocator(text:Figure):Locator ;
 */
    /**
     * Returns the named attribute or null if a
     * a figure doesn't have an attribute.
     * All figures support the attribute names
     * FillColor and FrameColor
     */
    function getAttribute(name:String):Object ;

    /**
     * Sets the named attribute to the new value
     */
    function setAttribute(name:String, value:Object):void ;
}
}
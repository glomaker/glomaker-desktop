/*
 * @(#)Drawing.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.util.*;

/**
 * Drawing is a container for figures.
 * <p>
 * Drawing sends out DrawingChanged events to DrawingChangeListeners
 * whenever a part of its area was invalidated.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld026.htm>Observer</a></b><br>
 * The Observer pattern is used to decouple the Drawing from its views and
 * to enable multiple views.<hr>
 *
 * @see Figure
 * @see DrawingView
 * @see FigureChangeListener
 */

public interface Drawing extends FigureChangeListener {

    /**
     * Releases the drawing and its contained figures.
     */
    function release():void ;

    /**
     * Returns an enumeration to iterate in
     * Z-order back to front over the figures.
     */
    function figures():FigureEnumeration ;

    /**
     * Returns an enumeration to iterate in
     * Z-order front to back over the figures.
     */
    function figuresReverse():FigureEnumeration ;

    /**
     * Finds a top level Figure. Use this call for hit detection that
     * should not descend into the figure's children.
     * 
     * Or, Finds a top level Figure that intersects the given rectangle.
     * 
     * Or
     * 
     * Finds a top level Figure that intersects the given rectangle.
     * It supresses the passed
     * in figure. Use this method to ignore a figure
     * that is temporarily inserted into the drawing.
     * 
     * Forms:
     * (1) findFigure(x:int, y:int):Figure ;  o => x, p=> y
     * (2) findFigure(r:_Rectangle):Figure ;    o => r
     * (3) findFigure(r:_Rectangle, without:Figure):Figure ;   o=>r, p=>without
     */
    function findFigure(o:* = null, p:* = null):Figure ;

    /**
     * Finds a top level Figure, but supresses the passed
     * in figure. Use this method to ignore a figure
     * that is temporarily inserted into the drawing.
     * @param x the x coordinate
     * @param y the y coordinate
     * @param without the figure to be ignored during
     * the find.
     */
    function findFigureWithout(x:int, y:int, without:Figure):Figure ;

    /**
     * Finds a figure but descends into a figure's
     * children. Use this method to implement <i>click-through</i>
     * hit detection, that is, you want to detect the inner most
     * figure containing the given point.
     */
    function findFigureInside(x:int, y:int):Figure ;

    /**
     * Finds a figure but descends into a figure's
     * children. It supresses the passed
     * in figure. Use this method to ignore a figure
     * that is temporarily inserted into the drawing.
     * @param x the x coordinate
     * @param y the y coordinate
     * @param without the figure to be ignored during
     * the find.
     */
    function findFigureInsideWithout(x:int, y:int, without:Figure):Figure ;

    /**
     * Adds a listener for this drawing.
     */
    function addDrawingChangeListener(listener:DrawingChangeListener):void ;

    /**
     * Removes a listener from this drawing.
     */
    function removeDrawingChangeListener(listener:DrawingChangeListener):void ;

    /**
     * Gets the listeners of a drawing.
     */
    function drawingChangeListeners():Enumeration ;

    /**
     * Adds a figure and sets its container to refer
     * to this drawing.
     * @return the figure that was inserted.
     */
    function add(figure:Figure):Figure ;

    /**
     * Adds a vector of figures.
     */
    function addAll(newFigures:_Vector):void ;

    /**
     * Removes the figure from the drawing and releases it.
     */
    function remove(figure:Figure):Figure ;

    /**
     * Removes a figure from the figure list, but
     * doesn't release it. Use this method to temporarily
     * manipulate a figure outside of the drawing.
     */
    function orphan(figure:Figure):Figure ;

    /**
     * Removes a vector of figures from the figure's list
     * without releasing the figures.
     * @see orphan
     */
    function orphanAll(newFigures:_Vector):void ;

    /**
     * Removes a vector of figures .
     * @see remove
     */
    function removeAll(figs:_Vector=null):void ;

    /**
     * Replaces a figure in the drawing without
     * removing it from the drawing.
     */
    function replace(figure:Figure, replacement:Figure):void ;

    /**
     * Sends a figure to the back of the drawing.
     */
    function sendToBack(figure:Figure):void ;

    /**
     * Brings a figure to the front.
     */
    function bringToFront(figure:Figure):void ;

    /**
     * Draws all the figures back to front.
     */
    function draw(g:Graphics):void ;

    /**
     * Invalidates a rectangle and merges it with the
     * existing damaged area.
     */
/*     override function figureInvalidated(e:FigureChangeEvent):void ;
 */
    /**
     * Forces an update of the drawing change listeners.
     */
/*     override function figureRequestUpdate(e:FigureChangeEvent):void ;
 */
    /**
     * Handles a removeFrfigureRequestRemove request that
     * is passed up the figure container hierarchy.
     * @see FigureChangeListener
     */
/*     override function figureRequestRemove(e:FigureChangeEvent):void ;
 */
    /**
     * Acquires the drawing lock.
     */
    function lock():void ;

    /**
     * Releases the drawing lock.
     */
    function unlock():void ;

}
}
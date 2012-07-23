/*
 * @(#)DrawingView.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom.Dimension;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.util.*;

import mx.managers.CursorManager;

/**
 * DrawingView renders a Drawing and listens to its changes.
 * It receives user input and delegates it to the current tool.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld026.htm>Observer</a></b><br>
 * DrawingView observes drawing for changes via the DrawingListener interface.<br>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld032.htm>State</a></b><br>
 * DrawingView plays the role of the StateContext in
 * the State pattern. Tool is the State.<br>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld034.htm>Strategy</a></b><br>
 * DrawingView is the StrategyContext in the Strategy pattern
 * with regard to the UpdateStrategy. <br>
 * DrawingView is the StrategyContext for the PointConstrainer.
 *
 * @see Drawing
 * @see Painter
 * @see Tool
 */


public interface DrawingView extends DrawingChangeListener /* ImageObserver,   */{

    /**
     * Sets the view's editor.
     */
    function setEditor(editor:DrawingEditor):void ;

    /**
     * Gets the current tool.
     */
    function tool():Tool ;

    /**
     * Gets the drawing.
     */
    function drawing():Drawing ;

    /**
     * Sets and installs another drawing in the view.
     */
    function setDrawing(d:Drawing):void ;

    /**
     * Gets the editor.
     */
    function editor():DrawingEditor ;

    /**
     * Adds a figure to the drawing.
     * @return the added figure.
     */
    function add(figure:Figure):Figure ;

    /**
     * Removes a figure from the drawing.
     * @return the removed figure
     */
    function remove(figure:Figure):Figure ;

    /**
     * Adds a vector of figures to the drawing.
     */
    function addAll(figures:_Vector):void ;

    /**
     * Gets the size of the drawing.
     */
    function getSize():Dimension ;

    /**
     * Gets the minimum dimension of the drawing.
     */
    function getMinimumSize():Dimension ;

    /**
     * Gets the preferred dimension of the drawing..
     */
    function getPreferredSize():Dimension ;

    /**
     * Gets the currently selected figures.
     * @return a vector with the selected figures. The vector
     * is a copy of the current selection.
     */
    function selection():_Vector ;

    /**
     * Gets an enumeration over the currently selected figures.
     */
    function selectionElements():FigureEnumeration ;

    /**
     * Gets the currently selected figures in Z order.
     * @see #selection
     * @return a vector with the selected figures. The vector
     * is a copy of the current selection.
     */
    function selectionZOrdered():_Vector ;

    /**
     * Gets the number of selected figures.
     */
    function selectionCount():int ;

    /**
     * Adds a figure to the current selection.
     */
    function addToSelection(figure:Figure):void ;

    /**
     * Adds a vector of figures to the current selection.
     */
    function addToSelectionAll(figures:_Vector):void ;

    /**
     * Removes a figure from the selection.
     */
    function removeFromSelection(figure:Figure):void ;

    /**
     * If a figure isn't selected it is added to the selection.
     * Otherwise it is removed from the selection.
     */
    function toggleSelection(figure:Figure):void ;

    /**
     * Clears the current selection.
     */
    function clearSelection():void ;

    /**
     * Gets the current selection as a FigureSelection. A FigureSelection
     * can be cut, copied, pasted.
     */
    //function getFigureSelection():FigureSelection ;

    /**
     * Finds a handle at the given coordinates.
     * @return the hit handle, null if no handle is found.
     */
    function findHandle(x:int, y:int):Handle ;

    /**
     * Gets the position of the last click inside the view.
     */
    function lastClick():_Point ;

    /**
     * Creates an image with the given dimensions
     */
    //function createImage(width:int, height:int):Image ;

    /**
     * Gets a graphic to draw into
     */
    function getGraphics():Graphics ;

    /**
     * Gets a graphic to draw the handles into
     */
    function getHandlesGraphics():Graphics ;

    /**
     * Gets a graphic to draw the select rectangle into
     */
    function getSelectAreaGraphics():Graphics ;


    /**
     * Checks whether the drawing has some accumulated damage
     */
    function checkDamage():void ;
    
    }
}
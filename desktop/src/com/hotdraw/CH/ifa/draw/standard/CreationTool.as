/*
 * @(#)CreationTool.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.cursor.MouseTheme;
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;

import flash.events.MouseEvent;

import mx.managers.CursorManager;

/**
 * A tool to create new figures. The figure to be
 * created is specified by a prototype.
 *
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld029.htm>Prototype</a></b><br>
 * CreationTool creates new figures by cloning a prototype.
 * <hr>
 * @see Figure
 * @see Object#clone
 */


public class CreationTool extends AbstractTool {

    /**
     * the anchor point of the interaction
     */
    private var fAnchorPoint:_Point;

    /**
     * the currently created figure
     */
    public var fCreatedFigure:Figure;

    /**
     * the prototypical figure that is used to create new figures.
     */
    public var fPrototype:Figure;


    /**
     * Initializes a CreationTool with the given prototype.
     * 
     * OR
     * Constructs a CreationTool without a prototype.
     * This is for subclassers overriding createFigure.
     */
    public function CreationTool(view:DrawingView, prototype:Figure = null) {
        super(view);
        fPrototype = prototype;
    }


    /**
     * Sets the cross hair cursor.
     */
    override public function activate():void {
    	CursorManager.setCursor(MouseTheme.cross,2,-MouseTheme.w/2-5,-MouseTheme.h/2-4);
    }

    /**
     * Creates a new figure by cloning the prototype.
     */
    override public function mouseDown(e:MouseEvent, x:int, y:int):void {
        fAnchorPoint = new _Point(x,y);
        fCreatedFigure = createFigure();
        fCreatedFigure.displayBox(fAnchorPoint, fAnchorPoint);
        view().add(fCreatedFigure);
    }

    /**
     * Creates a new figure by cloning the prototype.
     */
    protected function createFigure():Figure {
         if (fPrototype == null)
		    throw new Error("No protoype defined");
        return fPrototype.clone() as Figure;
    }

    /**
     * Adjusts the extent of the created figure
     */
    override public function mouseDrag(e:MouseEvent, x:int, y:int):void {
        fCreatedFigure.displayBox(fAnchorPoint, new _Point(x,y));
    }

    /**
     * Checks if the created figure is empty. If it is, the figure
     * is removed from the drawing.
     * @see Figure#isEmpty
     */
    override public function mouseUp(e:MouseEvent, x:int, y:int):void {
        if (fCreatedFigure.isEmpty())
            drawing().remove(fCreatedFigure);
        fCreatedFigure = null;
        editor().toolDone();
        CursorManager.removeAllCursors();         
    }

    /**
     * Gets the currently created figure
     */
    protected function createdFigure():Figure {
        return fCreatedFigure;
    }
}
}
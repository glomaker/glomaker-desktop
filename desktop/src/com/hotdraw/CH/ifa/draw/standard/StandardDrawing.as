/*
 * @(#)StandardDrawing.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.*;

/**
 * The standard implementation of the Drawing interface.
 *
 * @see Drawing
 */

public class StandardDrawing extends CompositeFigure implements Drawing {


    /**
     * the registered listeners
     */
    private var fListeners:_Vector;

    /**
     * boolean that serves as a condition variable
     * to lock the access to the drawing.
     * The lock is recursive and we keep track of the current
     * lock holder.
     */
/*     private var fDrawingLockHolder:Thread= null;
 */
    /*
     * Serialization support
     */
    private static  const serialVersionUID:Number= -2602151437447962046;
    private var drawingSerializedDataVersion:int= 1;

    /**
     * Constructs the Drawing.
     */
    public function StandardDrawing() {
        super();
        fListeners = new _Vector();
    }


    /**
     * Adds a listener for this drawing.
     */
    public function addDrawingChangeListener(listener:DrawingChangeListener):void {
        fListeners.addElement(listener);
    }

    /**
     * Removes a listener from this drawing.
     */
    public function removeDrawingChangeListener(listener:DrawingChangeListener):void {
        fListeners.removeElement(listener);
    }

    /**
     * Adds a listener for this drawing.
     */
    public function drawingChangeListeners():Enumeration {
        return fListeners.elements();
    }

    /**
     * Removes the figure from the drawing and releases it.
     */

    override public function remove(figure:Figure):Figure {
        // ensure that we remove the top level figure in a drawing
        if (figure.listener() != null) {
            figure.listener().figureRequestRemove(new FigureChangeEvent(figure, null));
            return figure;
        }
        return null;
    }


    /**
     * Handles a removeFromDrawing request that
     * is passed up the figure container hierarchy.
     * @see FigureChangeListener
     */
    override public function figureRequestRemove(e:FigureChangeEvent):void {
        var figure:Figure= e.getFigure();
        if (fFigures.contains(figure)) {
            fFigures.removeElement(figure);
            figure.removeFromContainer(this);   // will invalidate figure
            figure.release();
        } /* else
            System.out.println("Attempt to remove non-existing figure"); */
    }

    /**
     * Invalidates a rectangle and merges it with the
     * existing damaged area.
     * @see FigureChangeListener
     */
/*     override public function figureInvalidated(e:FigureChangeEvent):void {
        if (fListeners != null) {
            for (var i:int= 0; i < fListeners.size(); i++) {
                var l:DrawingChangeListener= DrawingChangeListener(fListeners.elementAt(i));
                l.drawingInvalidated(new DrawingChangeEvent(this, e.getInvalidatedRectangle()));
            }
        }
    } */

    /**
     * Forces an update
     */
/*     override public function figureRequestUpdate(e:FigureChangeEvent):void {
        if (fListeners != null) {
            for (var i:int= 0; i < fListeners.size(); i++) {
                var l:DrawingChangeListener= DrawingChangeListener(fListeners.elementAt(i));
                l.drawingRequestUpdate(new DrawingChangeEvent(this, null));
            }
        }
    } */

    /**
     * Return's the figure's handles. This is only used when a drawing
     * is nested inside another drawing.
     */
    override public function handles():_Vector {
        var handles:_Vector= new _Vector();
/*         handles.addElement(new NullHandle(this, RelativeLocator.northWest()));
        handles.addElement(new NullHandle(this, RelativeLocator.northEast()));
        handles.addElement(new NullHandle(this, RelativeLocator.southWest()));
        handles.addElement(new NullHandle(this, RelativeLocator.southEast()));
 */        return handles;
    }

    /**
     * Gets the display box. This is the union of all figures.
     */
    override public function getDisplayBox():_Rectangle {
        if (fFigures.size() > 0) {
            var k:FigureEnumeration= figures();

            var r:_Rectangle= k.nextFigure().displayBox();

            while (k.hasMoreElements())
                r.add(k.nextFigure().displayBox());
            return r;
        }
        return new _Rectangle(0, 0, 0, 0);
    }

    override public function basicDisplayBox(p1:_Point, p2:_Point):void {
    }

    /**
     * Acquires the drawing lock.
     */
    public function lock():void {
/*         // recursive lock
        var current:Thread= Thread.currentThread();
        if (fDrawingLockHolder == current)
            return;
        while (fDrawingLockHolder != null) {
            try { wait(); } catch (var ex:InterruptedException) { }
        }
        fDrawingLockHolder = current;
 */    }

    /**
     * Releases the drawing lock.
     */
    public function unlock():void {
/*         if (fDrawingLockHolder != null) {
            fDrawingLockHolder = null;
            notifyAll();
        }
  */   }

/*     private function readObject(s:ObjectInputStream):void throws ClassNotFoundException, IOException {

        s.defaultReadObject();

        fListeners = new _Vector(2);
    } */
}
}
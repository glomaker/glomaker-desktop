/*
 * @(#)CompositeFigure.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.*;

/**
 * A Figure that is composed of several figures. A CompositeFigure
 * doesn't define any layout behavior. It is up to subclassers to
 * arrange the contained figures.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld012.htm>Composite</a></b><br>
 * CompositeFigure enables to treat a composition of figures like
 * a single figure.<br>
 * @see Figure
 */

public class CompositeFigure extends AbstractFigure  implements FigureChangeListener {

    /**
     * The figures that this figure is composed of
     * @see #add
     * @see #remove
     */
    protected var fFigures:_Vector;

    /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= 7408153435700021866;
    private var compositeFigureSerializedDataVersion:int= 1;

    public function CompositeFigure() {
        fFigures = new _Vector();
    }

    /**
     * Adds a figure to the list of figures. Initializes the
     * the figure's container.
     */
    public function add(figure:Figure):Figure {
        if (!fFigures.contains(figure)) {
            fFigures.addElement(figure);
            figure.addToContainer(this);
        }
        return figure;
    }

    /**
     * Adds a vector of figures.
     * @see #add
     */
    public function addAll(newFigures:_Vector):void {
        var k:Enumeration= newFigures.elements();
        while (k.hasMoreElements())
            add(Figure(k.nextElement()));
    }

    /**
     * Removes a figure from the composite.
     * @see #removeAll
     */
    public function remove(figure:Figure):Figure {
        if (fFigures.contains(figure)) {
            figure.removeFromContainer(this);
            fFigures.removeElement(figure);
        }
        return figure;
    }
    
        /**
     * Returns an Enumeration for accessing the contained figures.
     * The figures are returned in the drawing order.
     */
    override public function figures():FigureEnumeration {
        return new FigureEnumerator(fFigures) as FigureEnumeration;
    }

    /**
     * Removes a vector of figures.
     * 
     * Or, 
     * @see #remove Removes all children.
     * 
     * Forms:
     * 
     * (1) removeAll(figures:_Vector)
     * (2) removeAll()
     */
    public function removeAll(figs:_Vector=null):void {
        if(figs == null){
         var k:FigureEnumeration= figures();
         while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            figure.removeFromContainer(this);
        }
        fFigures.removeAllElements();
        } else {
        var c:Enumeration= figs.elements();
        while (c.hasMoreElements())
            remove(Figure(c.nextElement()));
        }
    }

   
    /**
     * Removes a figure from the figure list, but
     * doesn't release it. Use this method to temporarily
     * manipulate a figure outside of the drawing.
     */
    public function orphan(figure:Figure):Figure {
        fFigures.removeElement(figure);
        return figure;
    }

    /**
     * Removes a vector of figures from the figure's list
     * without releasing the figures.
     * @see orphan
     */
    public function orphanAll(newFigures:_Vector):void {
        var k:Enumeration= newFigures.elements();
        while (k.hasMoreElements())
            orphan(Figure(k.nextElement()));
    }

    /**
     * Replaces a figure in the drawing without
     * removing it from the drawing.
     */
    public function replace(figure:Figure, replacement:Figure):void {
        var index:int= fFigures.indexOf(figure);
        if (index != -1) {
            replacement.addToContainer(this);   // will invalidate figure
            figure.changed();
            fFigures.setElementAt(replacement, index);
        }
    }

    /**
     * Sends a figure to the back of the drawing.
     */
    public function sendToBack(figure:Figure):void {
        if (fFigures.contains(figure)) {
            fFigures.removeElement(figure);
            fFigures.insertElementAt(figure,0);
            figure.changed();
        }
    }

    /**
     * Brings a figure to the front.
     */
    public function bringToFront(figure:Figure):void {
        if (fFigures.contains(figure)) {
            fFigures.removeElement(figure);
            fFigures.addElement(figure);
            figure.changed();
        }
    }

    /**
     * Draws all the contained figures
     * @see Figure#draw
     */
    override public function draw(g:Graphics):void {
        var k:FigureEnumeration= figures();
        while (k.hasMoreElements())
            k.nextFigure().draw(g);
    }

    /**
     * Gets a figure at the given index.
     */
    public function figureAt(i:int):Figure {
        return fFigures.elementAt(i) as Figure;
    }


    /**
     * Gets number of child figures.
     */
    public function figureCount():int {
        return fFigures.size();
    }

    /**
     * Returns an Enumeration for accessing the contained figures
     * in the reverse drawing order.
     */
    public final function figuresReverse():FigureEnumeration {
        return new ReverseFigureEnumerator(fFigures);
    }


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
     * (1) findFigure(x:int, y:int)
     * (2) findFigure(r:_Rectangle):Figure ;    x => r
     * (3) findFigure(r:_Rectangle, without:Figure):Figure ;   x=>r, y=>without
     */
    public function findFigure(o:* = null, p:* = null):Figure {
    	var k:FigureEnumeration= figuresReverse();
    	var figure:Figure=null;
    	var fr:_Rectangle=null;
    	var r:_Rectangle=null;
    	
    	if(o is int && p is int){
    		var x:int = o as int;
    		var y:int = p as int;
    		
    		while (k.hasMoreElements()) {
            figure= k.nextFigure();
            if (figure.containsPoint(x, y))
                return figure;
            }
    	} else if(o is _Rectangle && p == null){
    		r = o as _Rectangle;
    		
    	   while (k.hasMoreElements()) {
            figure= k.nextFigure();
            fr = figure.displayBox();
            if (r.intersects(fr))
                return figure;
           }
    	} else if(o is _Rectangle && p is Figure){
    		r = o as _Rectangle;
    		var without:Figure = p as Figure;
  
         while (k.hasMoreElements()) {
            figure= k.nextFigure();
            fr = figure.displayBox();
            if (r.intersects(fr) && !figure.includes(without))
                return figure;
         }
    	}
    	return null;
     }
    
     /**
     * Finds a top level Figure, but supresses the passed
     * in figure. Use this method to ignore a figure
     * that is temporarily inserted into the drawing.
     * @param x the x coordinate
     * @param y the y coordinate
     * @param without the figure to be ignored during
     * the find.
     */
    public function findFigureWithout(x:int, y:int, without:Figure):Figure {
        if (without == null)
            return findFigure(x, y);
        var k:FigureEnumeration= figuresReverse();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            if (figure.containsPoint(x, y) && !figure.includes(without))
                return figure;
        }
        return null;
    }

    /**
     * Finds a figure but descends into a figure's
     * children. Use this method to implement <i>click-through</i>
     * hit detection, that is, you want to detect the inner most
     * figure containing the given point.
     */
    override public function findFigureInside(x:int, y:int):Figure {
        var k:FigureEnumeration= figuresReverse();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure().findFigureInside(x, y);
            if (figure != null)
                return figure;
        }
        return null;
    }

    /**
     * Finds a figure but descends into a figure's
     * children. It supresses the passed
     * in figure. Use this method to ignore a figure
     * that is temporarily inserted into the drawing.
     */
    public function findFigureInsideWithout(x:int, y:int, without:Figure):Figure {
        var k:FigureEnumeration= figuresReverse();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            if (figure != without) {
                var found:Figure= figure.findFigureInside(x, y);
                if (found != null)
                    return found;
            }
        }
        return null;
    }

    /**
     * Checks if the composite figure has the argument as one of
     * its children.
     */
    override public function includes(figure:Figure):Boolean {
        if (super.includes(figure))
            return true;

        var k:FigureEnumeration= figures();
        while (k.hasMoreElements()) {
            var f:Figure= k.nextFigure();
            if (f.includes(figure))
                return true;
        }
        return false;
    }

    /**
     * Moves all the given figures by x and y. Doesn't announce
     * any changes. Subclassers override
     * basicMoveBy. Clients usually call moveBy.
     * @see moveBy
     */
    override public function basicMoveBy(x:int, y:int):void {
        var k:FigureEnumeration= figures();
        while (k.hasMoreElements())
            k.nextFigure().moveBy(x,y);
    }

    /**
     * Releases the figure and all its children.
     */
    override public function release():void {
        super.release();
        var k:FigureEnumeration= figures();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            figure.release();
        }
    }

    /**
     * Propagates the figureInvalidated event to my listener.
     * @see FigureChangeListener
     */
    public function figureInvalidated(e:FigureChangeEvent):void {
        if (listener() != null)
            listener().figureInvalidated(e);
    }

    /**
     * Propagates the removeFromDrawing request up to the container.
     * @see FigureChangeListener
     */
    public function figureRequestRemove(e:FigureChangeEvent):void {
        if (listener() != null)
            listener().figureRequestRemove(new FigureChangeEvent(this));
    }

    /**
     * Propagates the requestUpdate request up to the container.
     * @see FigureChangeListener
     */
    public function figureRequestUpdate(e:FigureChangeEvent):void {
        if (listener() != null)
            listener().figureRequestUpdate(e);
    }

    public function figureChanged(e:FigureChangeEvent):void {
    }

    public function figureRemoved(e:FigureChangeEvent):void {
    }

    /**
     * Writes the contained figures to the StorableOutput.
     */
 /*    public function write(dw:StorableOutput):void {
        super.write(dw);
        dw.writeInt(fFigures.size());
        var k:Enumeration= fFigures.elements();
        while (k.hasMoreElements())
            dw.writeStorable(Storable(k.nextElement()));
    }
 */
    /**
     * Reads the contained figures from StorableInput.
     */
 /*    PUBLIC FUNCTION READ(DR:STORABLEINPUT):VOID THROWS IOEXCEPTION {
        SUPER.READ(DR);
        VAR SIZE:INT= DR.READINT();
        FFIGURES = NEW VECTOR(SIZE);
        FOR (VAR I:INT=0; I<SIZE; I++)
            ADD(FIGURE(DR.READSTORABLE()));
    }
 */
/*     private function readObject(s:ObjectInputStream):void throws ClassNotFoundException, IOException {

        s.defaultReadObject();

        var k:FigureEnumeration= figures();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            figure.addToContainer(this);
        }
    } */
}
}
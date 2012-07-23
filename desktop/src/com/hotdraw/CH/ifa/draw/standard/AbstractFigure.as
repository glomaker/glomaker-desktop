/*
 * @(#)AbstractFigure.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom.Dimension;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util._Vector;

import mx.core.UIComponent;

/**
 * AbstractFigure provides default implementations for
 * the Figure interface.
 *
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld036.htm>Template Method</a></b><br>
 * Template Methods implement default and invariant behavior for
 * figure subclasses.
 * <hr>
 *
 * @see Figure
 * @see Handle
 */

public class AbstractFigure extends UIComponent implements Figure {

    /**
     * The listeners for a figure's changes.
     * @see #invalidate
     * @see #changed
     * @see #willChange
     */
    private var fListener:FigureChangeListener;

    /*
     * Serialization support.
     */
    private static var serialVersionUID:Number= -10857585979273442;
    
    private var abstractFigureSerializedDataVersion:int= 1;

    public function AbstractFigure() { }

    /**
     * Moves the figure by the given offset.
     */
     
    public function moveBy(dx:int, dy:int):void {
        willChange();
        basicMoveBy(dx, dy);
        changed();
    }

    /**
     * Moves the figure. This is the
     * method that subclassers override. Clients usually
     * call displayBox.
     * @see moveBy
     */
    public  function basicMoveBy(dx:int, dy:int):void {;}

    /**
     * Changes the display box of a figure. Clients usually
     * call this method. It changes the display box
     * and announces the corresponding change.
     * @param origin the new origin
     * @param corner the new corner
     * @see displayBox
     * 
     * Forms:
     * (1) Rectangle displayBox ();
     * Gets the display box of a figure.
     * (2) void displayBox (Point origin, Point corner);
     * (3) void displayBox (Rectangle r);
     * Changes the display box of a figure. This is a
     * convenience method. Implementors should only
     * have to override basicDisplayBox
     * @see displayBox

     */
    public function displayBox(origin:*=null, corner:*=null):_Rectangle {
    	
    	
    	if(!origin && !corner) return this.getDisplayBox();
    	if(origin is _Rectangle){
    		var r:_Rectangle=origin;
    		displayBox(new _Point(r.x, r.y), new _Point(r.x+r.width, r.y+r.height));
    		 return null;
    		 }
    	
        willChange();
        basicDisplayBox(origin, corner);
        changed();
        
        return null
    }

     /**
     * Gets the display box of a figure.
     */
    public function getDisplayBox():_Rectangle {return null;}


    /**
     * Sets the display box of a figure. This is the
     * method that subclassers override. Clients usually
     * call displayBox.
     * @see displayBox
     */
    public function basicDisplayBox(origin:_Point, corner:_Point):void {;}

  
    /**
     * Returns the handles of a Figure that can be used
     * to manipulate some of its attributes.
     * @return a Vector of handles
     * @see Handle
     */
    public function handles():_Vector {return null;}

    /**
     * Returns an Enumeration of the figures contained in this figure.
     * @see CompositeFigure
     */
  
     public function figures():FigureEnumeration {
        var figures:_Vector= new _Vector();
        figures.addElement(this);
        return new FigureEnumerator(figures);
        return null;
    } 
    

    /**
     * Gets the size of the figure. A convenience method.
     */
    public function size():Dimension {
        return new Dimension(displayBox().width, displayBox().height);
    }

    /**
     * Checks if the figure is empty. The default implementation returns
     * true if the width or height of its display box is < 3
     * @see Figure#isEmpty
     */
    public function isEmpty():Boolean {
        return (size().width < 3) || (size().height < 3);
    }

    /**
     * Returns the figure that contains the given point.
     * In contrast to containsPoint it returns its
     * innermost figure that contains the point.
     *
     * @see #containsPoint
     */
    public function findFigureInside(x:int, y:int):Figure {
        if (containsPoint(x, y))
            return this;
        return null;
    }

    /**
     * Checks if a point is inside the figure.
     */
    public function containsPoint(x:int, y:int):Boolean {
        return displayBox().contains(x, y);
    }

    /**
     * Checks whether the given figure is contained in this figure.
     */
    public function includes(figure:Figure):Boolean {
        return figure == this;
    }

    /**
     * Decomposes a figure into its parts. It returns a Vector
     * that contains itself.
     * @return an Enumeration for a Vector with itself as the
     * only element.
     */
    public function decompose():FigureEnumeration {
        var figures:_Vector= new _Vector();
        figures.addElement(this);
        return new FigureEnumerator(figures);
 return null;
 }

    /**
     * Sets the Figure's container and registers the container
     * as a figure change listener. A figure's container can be
     * any kind of FigureChangeListener. A figure is not restricted
     * to have a single container.
     */
    public function addToContainer(c:FigureChangeListener):void {
        addFigureChangeListener(c);
        invalidate();
     }

    /**
     * Removes a figure from the given container and unregisters
     * it as a change listener.
     */
    public function removeFromContainer(c:FigureChangeListener):void {
       invalidate();
        removeFigureChangeListener(c);
        changed();
     }

    /**
     * Adds a listener for this figure.
     */
    public function addFigureChangeListener(l:FigureChangeListener):void {
        fListener = FigureChangeEventMulticaster.add(fListener, l);
    }

    /**
     * Removes a listener for this figure.
     */
    public function removeFigureChangeListener(l:FigureChangeListener):void {
        fListener = FigureChangeEventMulticaster.remove(fListener, l);
    }

    /**
     * Gets the figure's listners.
     */
    public function listener():FigureChangeListener {
        return fListener;
    }

    /**
     * A figure is released from the drawing. You never call this
     * method directly. Release notifies its listeners.
     * @see Figure#release
     */
    public function release():void {
        if (fListener != null)
            fListener.figureRemoved(new FigureChangeEvent(this));
       
       // Remove the Figure from it's parent!
       parent.removeChild(this);
     }

    /**
     * Invalidates the figure. This method informs the listeners
     * that the figure's current display box is invalid and should be
     * refreshed.
     */
    public function invalidate():void {
         if (fListener != null) {
            var r:_Rectangle= displayBox();
            r.grow(AbstractHandle.HANDLESIZE, AbstractHandle.HANDLESIZE);
            fListener.figureInvalidated(new FigureChangeEvent(this, r));
        }
     }

    /**
     * Informes that a figure is about to change something that
     * affects the contents of its display box.
     *
     * @see Figure#willChange
     */
    public function willChange():void {
        invalidate();
    }

    /**
     * Informs that a figure changed the area of its display box.
     *
     * @see FigureChangeEvent
     * @see Figure#changed
     */
    public function changed():void {
        invalidate();
        if (fListener != null)
            fListener.figureChanged(new FigureChangeEvent(this));

    }

    /**
     * Gets the center of a figure. A convenice
     * method that is rarely overridden.
     */
     public function center():_Point {
        //return Geom.center(displayBox());
        return null
    }
 
    /**
     * Checks if this figure can be connected. By default
     * AbstractFigures can be connected.
     */
     public function canConnect():Boolean {
        return true;
    }
 
    /**
     * Returns the connection inset. The connection inset
     * defines the area where the display box of a
     * figure can't be connected. By default the entire
     * display box can be connected.
     *
     */
    public function connectionInsets():Insets {
        return new Insets(0, 0, 0, 0);
    }
 
    /**
     * Returns the Figures connector for the specified location.
     * By default a ChopBoxConnector is returned.
     * @see ChopBoxConnector
     */
    public function connectorAt(x:int, y:int):* { //Connector {
        //return new ChopBoxConnector(this);
        return null;
    }
 
    /**
     * Sets whether the connectors should be visible.
     * By default they are not visible and
     */
     public function connectorVisibility(isVisible:Boolean):void {
    }
 
    /**
     * Returns the locator used to located connected text.
     */
     public function connectedTextLocator(text:Figure):*{//Locator {
        //return RelativeLocator.center();
        return null;
     }

    /**
     * Returns the named attribute or null if a
     * a figure doesn't have an attribute.
     * By default
     * figures don't have any attributes getAttribute
     * returns null.
     */
    public function getAttribute(name:String):Object {
        return null;
    }

    /**
     * Sets the named attribute to the new value. By default
     * figures don't have any attributes and the request is ignored.
     */
    public function setAttribute(name:String, value:Object):void {
    }

         
    override protected function updateDisplayList(w:Number, h:Number):void { 
     super.updateDisplayList(w, h); 
   	  graphics.clear();
   	  draw(graphics);
   	  graphics.endFill();
    }
     
    /**
     * Draws the figure.
     * @param g the Graphics to draw into
     */
    public function draw(g:Graphics):void {
    
    }
    
    
        /**
     * Clones a figure. Creates a clone by using the storable
     * mechanism to flatten the Figure to stream followed by
     * resurrecting it from the same stream.
     *
     * @see Figure#clone
     */
    public function clone():Object {
        return null;
    }

  

}
}
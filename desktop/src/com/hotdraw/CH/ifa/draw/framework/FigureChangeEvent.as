/*
 * @(#)FigureChangeEvent.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.EventObject;

/**
 * FigureChange event passed to FigureChangeListeners.
 *
 */
public class FigureChangeEvent extends EventObject {

    private var fRectangle:_Rectangle;
    private static var fgEmptyRectangle:_Rectangle= new _Rectangle(0, 0, 0, 0);

   /**
    * Constructs an event for the given source Figure. The rectangle is the
    * area to be invalvidated.
    */
    public function FigureChangeEvent(source:Figure=null, r:_Rectangle=null):void {
        super(source);
        if(r)
         fRectangle = r;
        else
        fRectangle = fgEmptyRectangle;
    }

   
    /**
     *  Gets the changed figure
     */
    public function getFigure():Figure {
        return getSource();
    }

    /**
     *  Gets the changed rectangle
     */
    public function getInvalidatedRectangle():_Rectangle {
        return fRectangle;
    }
}
}
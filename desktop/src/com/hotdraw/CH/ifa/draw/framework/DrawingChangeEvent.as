/*
 * @(#)DrawingChangeEvent.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.EventObject;

/**
 * The event passed to DrawingChangeListeners.
 *
 */
public class DrawingChangeEvent extends EventObject {

    private var fRectangle:_Rectangle;

    /**
     *  Constructs a drawing change event.
     */
    public function DrawingChangeEvent(source:Drawing, r:_Rectangle) {
        super(source);
        fRectangle = r;
    }

    /**
     *  Gets the changed drawing
     */
    public function getDrawing():Drawing {
        return getSource() as Drawing;
    }

    /**
     *  Gets the changed rectangle
     */
    public function getInvalidatedRectangle():_Rectangle {
        return fRectangle;
    }
}
}
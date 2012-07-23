/*
 * @(#)FigureChangeListener.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
	import com.hotdraw.java.awt.EventListener;
	

/**
 * Listener interested in Figure changes.
 *
 */
public interface FigureChangeListener extends EventListener  {

    /**
     *  Sent when an area is invalid
     */
    function figureInvalidated(e:FigureChangeEvent):void ;

    /**
     * Sent when a figure changed
     */
    function figureChanged(e:FigureChangeEvent):void ;

    /**
     * Sent when a figure was removed
     */
    function figureRemoved(e:FigureChangeEvent):void ;

    /**
     * Sent when requesting to remove a figure.
     */
    function figureRequestRemove(e:FigureChangeEvent):void ;

    /**
     * Sent when an update should happen.
     *
     */
    function figureRequestUpdate(e:FigureChangeEvent):void ;

}
}
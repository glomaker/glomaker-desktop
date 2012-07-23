/*
 * @(#)DrawingChangeListener.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
	import com.hotdraw.java.awt.EventListener;
	

/**
 * Listener interested in Drawing changes.
 */
public interface DrawingChangeListener extends EventListener {

    /**
     *  Sent when the drawing wants to be refreshed
     */
    function drawingRequestUpdate(e:DrawingChangeEvent):void ;
}
}
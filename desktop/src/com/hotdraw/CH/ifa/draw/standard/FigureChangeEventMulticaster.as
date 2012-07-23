/*
 * @(#)FigureChangeEventMulticaster.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import com.hotdraw.java.awt.*;

/**
 * Manages a list of FigureChangeListeners to be notified of
 * specific FigureChangeEvents.
 */


public class FigureChangeEventMulticaster /* extends  AWTEventMulticaster  */implements FigureChangeListener {

   private var a:EventListener = null;
   private var b:EventListener = null;


    public function FigureChangeEventMulticaster(aa:EventListener, bb:EventListener) {
    	a = aa;
    	b = bb;
    }

    public function figureInvalidated(e:FigureChangeEvent):void {
        (FigureChangeListener(a)).figureInvalidated(e);
        (FigureChangeListener(b)).figureInvalidated(e);
    }

    public function figureRequestRemove(e:FigureChangeEvent):void {
        (FigureChangeListener(a)).figureRequestRemove(e);
        (FigureChangeListener(b)).figureRequestRemove(e);
    }

    public function figureRequestUpdate(e:FigureChangeEvent):void {
        (FigureChangeListener(a)).figureRequestUpdate(e);
        (FigureChangeListener(b)).figureRequestUpdate(e);
    }

    public function figureChanged(e:FigureChangeEvent):void {
        (FigureChangeListener(a)).figureChanged(e);
        (FigureChangeListener(b)).figureChanged(e);
    }

    public function figureRemoved(e:FigureChangeEvent):void {
        (FigureChangeListener(a)).figureRemoved(e);
        (FigureChangeListener(b)).figureRemoved(e);
    }

    public static function add(a:FigureChangeListener, b:FigureChangeListener):FigureChangeListener {
        return addInternal(a, b) as FigureChangeListener;
    }


    public static function remove(l:FigureChangeListener, oldl:FigureChangeListener):FigureChangeListener {
	    return removeInternal(l, oldl) as FigureChangeListener;
    }

    protected function remove(oldl:EventListener):EventListener {
        if (oldl == a)
            return b;
        if (oldl == b)
            return a;
        var a2:EventListener= removeInternal(FigureChangeListener(a), oldl);
        var b2:EventListener= removeInternal(FigureChangeListener(b), oldl);
        if (a2 == a && b2 == b)
            return this;
        else
            return addInternal(FigureChangeListener(a2), FigureChangeListener(b2));
    }

    protected static function addInternal(a:FigureChangeListener, b:FigureChangeListener):EventListener {
	    if (a == null)  return b;
	    if (b == null)  return a;
	    return new FigureChangeEventMulticaster(a, b);
    }

    protected static function removeInternal(l:EventListener, oldl:EventListener):EventListener {
    	if (l == oldl || l == null) {
    	    return null;
    	} else if (l is FigureChangeEventMulticaster) {
    	    return (FigureChangeEventMulticaster(l)).remove(oldl);
    	} else {
    	    return l;		// it's not here
    	}
    }

}
}
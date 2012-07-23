/*
 * @(#)LocatorHandle.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;

import com.hotdraw.java.awt.geom._Point;

/**
 * A LocatorHandle implements a Handle by delegating the location requests to
 * a Locator object.
 *
 * @see Locator
 */

public class LocatorHandle extends AbstractHandle {

    public var fLocator:Locator;

    /**
     * Initializes the LocatorHandle with the given Locator.
     */
    public function LocatorHandle(owner:Figure, l:Locator) {
        super(owner);
        fLocator = l;
    }

    /**
     * Locates the handle on the figure by forwarding the request
     * to its figure.
     */
    override public function locate():_Point {
    	var p:_Point = fLocator.locate(ownerFigure());
    	
    	 x = p.x - HANDLESIZE / 2;
         y = p.y - HANDLESIZE / 2;
    	
        return p;
    }
}
}
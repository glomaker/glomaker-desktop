/*
 * @(#)AbstractLocator.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.util.*;

/**
 * AbstractLocator provides default implementations for
 * the Locator interface.
 *
 * @see Locator
 * @see Handle
 */

public class AbstractLocator implements Locator /*  Locator, Storable, Cloneable  */{

    public function AbstractLocator() {
    }

    public function clone():Object {
     /*    try {
            return super.clone();
        } catch (var e:CloneNotSupportedException) {
	        throw new InternalError();
        } */
        return null;
    }

   /**
     * Locates a position on the passed figure.
     * @return a point on the figure.
     */
    public function locate(owner:Figure):_Point {return null;}
    
}
}
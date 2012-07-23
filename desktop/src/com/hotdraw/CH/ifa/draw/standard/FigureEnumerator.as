/*
 * @(#)FigureEnumerator.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;

import com.hotdraw.java.util.*;

/**
 * An Enumeration for a Vector of Figures.
 */
public final class FigureEnumerator implements FigureEnumeration {
	
    private var fEnumeration:Enumeration;

    public function FigureEnumerator(v:_Vector) {
	    fEnumeration = v.elements();
    }

    /**
     * Returns true if the enumeration contains more elements; false
     * if its empty.
     */
    public function hasMoreElements():Boolean {
	    return fEnumeration.hasMoreElements();
    }

    /**
     * Returns the next element of the enumeration. Calls to this
     * method will enumerate successive elements.
     * @exception NoSuchElementException If no more elements exist.
     */
    public function nextElement():* {
        return fEnumeration.nextElement();
    }

    /**
     * Returns the next element of the enumeration. Calls to this
     * method will enumerate successive elements.
     * @exception NoSuchElementException If no more elements exist.
     */
    public function nextFigure():Figure {
        return fEnumeration.nextElement() as Figure;
    }
}
}
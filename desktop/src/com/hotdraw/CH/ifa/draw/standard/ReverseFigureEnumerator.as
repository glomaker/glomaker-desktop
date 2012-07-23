/*
 * @(#)ReverseFigureEnumerator.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;

import com.hotdraw.java.util.*;

/**
 * An Enumeration that enumerates a vector of figures back (size-1) to front (0).
 */
public final class ReverseFigureEnumerator implements FigureEnumeration {
    private var fEnumeration:ReverseVectorEnumerator;

    public function ReverseFigureEnumerator(v:_Vector) {
	    fEnumeration = new ReverseVectorEnumerator(v);
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
     * Returns the next element casted as a figure of the enumeration. Calls to this
     * method will enumerate successive elements.
     * @exception NoSuchElementException If no more elements exist.
     */
    public function nextFigure():Figure {
        return fEnumeration.nextElement() as Figure;
    }
}
}
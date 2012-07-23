/*
 * @(#)FigureEnumeration.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
	import com.hotdraw.java.util.Enumeration;
	

/**
 * Interface for Enumerations that access Figures.
 * It provides a method nextFigure, that hides the down casting
 * from client code.
 */
public interface FigureEnumeration extends Enumeration {
    /**
     * Returns the next element of the enumeration. Calls to this
     * method will enumerate successive elements.
     * @exception NoSuchElementException If no more elements exist.
     */
     function nextFigure():Figure ;
}
}
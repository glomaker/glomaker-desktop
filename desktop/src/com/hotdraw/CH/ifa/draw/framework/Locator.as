/*
 * @(#)Locator.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;

/**
 * Locators can be used to locate a position on a figure.<p>
 *
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld034.htm>Strategy</a></b><br>
 * Locator encapsulates the strategy to locate a handle on a figure.
 */

public interface Locator /* extends Storable, Serializable, Cloneable */ {

    /**
     * Locates a position on the passed figure.
     * @return a point on the figure.
     */
    function locate(owner:Figure):_Point ;
}
}
/*
 * @(#)RelativeLocator.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;

/**
 * A locator that specfies a point that is relative to the bounds
 * of a figure.
 * @see Locator
 */
public class RelativeLocator extends AbstractLocator {
    /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= 2619148876087898602;
    private var relativeLocatorSerializedDataVersion:int= 1;

    private var fRelativeX:Number;
    private var fRelativeY:Number;

    public function RelativeLocator(relativeX:Number= 0.0, relativeY:Number= 0.0) {
         fRelativeX = relativeX;
        fRelativeY = relativeY;
    }

    override public function locate(owner:Figure):_Point {
        var r:_Rectangle= owner.displayBox();
        return new _Point(
            r.x + int((r.width*fRelativeX)),
            r.y + int((r.height*fRelativeY)
        ));
    }


    static public function east():Locator {
        return new RelativeLocator(1.0, 0.5);
    }

    /**
     * North.
     */
    static public function north():Locator {
        return new RelativeLocator(0.5, 0.0);
    }

    /**
     * West.
     */
    static public function west():Locator {
        return new RelativeLocator(0.0, 0.5);
    }

    /**
     * North east.
     */
    static public function northEast():Locator {
        return new RelativeLocator(1.0, 0.0);
    }

    /**
     * North west.
     */
    static public function northWest():Locator {
        return new RelativeLocator(0.0, 0.0);
    }

    /**
     * South.
     */
    static public function south():Locator {
        return new RelativeLocator(0.5, 1.0);
    }

    /**
     * South east.
     */
    static public function southEast():Locator {
        return new RelativeLocator(1.0, 1.0);
    }

    /**
     * South west.
     */
    static public function southWest():Locator {
        return new RelativeLocator(0.0, 1.0);
    }

    /**
     * Center.
     */
    static public function center():Locator {
        return new RelativeLocator(0.5, 0.5);
    }    
    
}
}
/*
 * @(#)BoxHandleKit.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
	
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.handles.*;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.util._Vector;

/**
 * A set of utility methods to create Handles for the common
 * locations on a figure's display box.
 * @see Handle
 */

 // TBD: use anonymous inner classes (had some problems with JDK 1.1)

public class BoxHandleKit {

    /**
     * Fills the given Vector with handles at each corner of a
     * figure.
     */
    static public function addCornerHandles(f:Figure, handles:_Vector):void {
        handles.addElement(southEast(f));
        handles.addElement(southWest(f));
        handles.addElement(northEast(f));
        handles.addElement(northWest(f));
    }

    /**
     * Fills the given Vector with handles at each corner
     * and the north, south, east, and west of the figure.
     */
    static public function addHandles(f:Figure, handles:_Vector):void {
        addCornerHandles(f, handles);
        handles.addElement(south(f));
        handles.addElement(north(f));
        handles.addElement(east(f));
        handles.addElement(west(f));
    }

    static public function south(owner:Figure):Handle {
        return new SouthHandle(owner);
    }

    static public function southEast(owner:Figure):Handle {
        return new SouthEastHandle(owner);
    }

    static public function southWest(owner:Figure):Handle {
        return new SouthWestHandle(owner);
    }

    static public function north(owner:Figure):Handle {
        return new NorthHandle(owner);
    }

    static public function northEast(owner:Figure):Handle {
        return new NorthEastHandle(owner);
    }

    static public function northWest(owner:Figure):Handle {
        return new NorthWestHandle(owner);
    }

    static public function east(owner:Figure):Handle {
        return new EastHandle(owner);
    }
    static public function west(owner:Figure):Handle {
        return new WestHandle(owner);
    }
}



}
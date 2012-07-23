/*
 * @(#)AttributeFigure.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.figures {
	
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.standard.*;
import com.hotdraw.CH.ifa.draw.util.*;

import flash.display.Graphics;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.util.*;

/**
 * A figure that can keep track of an open ended set of attributes.
 * The attributes are stored in a dictionary implemented by
 * FigureAttributes.
 *
 * @see Figure
 * @see Handle
 * @see FigureAttributes
 */
public class AttributeFigure extends AbstractFigure {

    /**
     * The attributes of a figure. Each figure can have
     * an open ended set of attributes. Attributes are
     * identified by name.
     * @see #getAttribute
     * @see #setAttribute
     */
    private var fAttributes:*; // FigureAttributes;

    /**
     * The default attributes associated with a figure.
     * If a figure doesn't have an attribute set, a default
     * value from this shared attribute set is returned.
     * @see #getAttribute
     * @see #setAttribute
     */
    private static var fgDefaultAttributes:FigureAttributes= null;

    /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= -10857585979273442;
    private var attributeFigureSerializedDataVersion:int= 1;

    public function AttributeFigure() { }

    /**
     * Gets the fill color of a figure. This is a convenience
     * method.
     @see getAttribute
     */
    public function getFillColor():Color {
        return getAttribute("FillColor") as Color;
    }

    /**
     * Gets the frame color of a figure. This is a convenience
     * method.
     @see getAttribute
     */
    public function getFrameColor():Color {
        return getAttribute("FrameColor")as Color;
    }

    //---- figure attributes ----------------------------------

    private static function initializeAttributes():void {
        fgDefaultAttributes = new FigureAttributes();
        fgDefaultAttributes.set("FrameColor", Color.black);
        //fgDefaultAttributes.set("FillColor",  new Color(0x70DB93));
        fgDefaultAttributes.set("TextColor",  Color.black);
        //fgDefaultAttributes.set("ArrowMode",  new Integer(0));
        //fgDefaultAttributes.set("FontName",  "Helvetica");
        //fgDefaultAttributes.set("FontSize",   new Integer(12));
        //fgDefaultAttributes.set("FontStyle",  new Integer(Font.PLAIN));
    }

    /**
     * Gets a the default value for a named attribute
     * @see getAttribute
     */
    public static function getDefaultAttribute(name:String):Object {
        if (fgDefaultAttributes == null)
            initializeAttributes();
        return fgDefaultAttributes.get(name);
    }

    /**
     * Returns the named attribute or null if a
     * a figure doesn't have an attribute.
     * All figures support the attribute names
     * FillColor and FrameColor
     */
    override public function getAttribute(name:String):Object {
        if (fAttributes != null) {
            if (fAttributes.hasDefined(name))
                return fAttributes.get(name);
        }
        return getDefaultAttribute(name);
    }

    /**
     * Sets the named attribute to the new value
     */
    override public function setAttribute(name:String, value:Object):void {
        if (fAttributes == null)
            fAttributes = new FigureAttributes();
        fAttributes.set(name, value);
        changed();
    }

}
}
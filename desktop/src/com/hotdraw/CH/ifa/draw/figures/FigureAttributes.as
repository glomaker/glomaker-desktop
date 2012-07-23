/*
 * @(#)FigureAttributes.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.figures {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import com.hotdraw.java.awt.Color;
import com.hotdraw.java.util.*;

/**
 * A container for a figure's attributes. The attributes are stored
 * as key/value pairs.
 *
 * @see Figure
 */

public  class   FigureAttributes  /* extends Object implements Cloneable, Serializable */ {

    private var fMap:Hashtable = null;

    /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= -6886355144423666716;
    private var figureAttributesSerializedDataVersion:int= 1;

    /**
     * Constructs the FigureAttributes.
     */
    public function FigureAttributes() {
        fMap = new Hashtable();
    }

    /**
     * Gets the attribute with the given name.
     * @returns attribute or null if the key is not defined
     */
    public function get(name:String):Object {
        return fMap.get(name);
    }

    /**
     * Sets the attribute with the given name and
     * overwrites its previous value.
     */
    public function set(name:String, value:Object):void {
        fMap.put(name, value);
    }

    /**
     * Tests if an attribute is defined.
     */
    public function hasDefined(name:String):Boolean {
        return fMap.containsKey(name);
    }

    /**
     * Clones the attributes.
     */
  /*  public function clone():Object {
        try {
            var a:FigureAttributes= FigureAttributes(super.clone());
            a.fMap = Hashtable(fMap.clone());
            return a;
        } catch (var e:CloneNotSupportedException) {
	        throw new InternalError();
        }
    } */

    /**
     * Reads the attributes from a StorableInput.
     * FigureAttributes store the following types directly:
     * Color, Boolean, String, Int. Other attribute types
     * have to implement the Storable interface or they
     * have to be wrapped by an object that implements Storable.
     * @see Storable
     * @see #write
     */
   /*  public function read(dr:StorableInput):void throws IOException {
        var s:String= dr.readString();
        if (!s.toLowerCase().equals("attributes"))
            throw new IOException("Attributes expected");

        fMap = new Hashtable();
        var size:int= dr.readInt();
        for (var i:int=0; i<size; i++) {
            var key:String= dr.readString();
            var valtype:String= dr.readString();
            var val:Object= null;
            if (valtype.equals("Color"))
                val = new Color(dr.readInt(), dr.readInt(), dr.readInt());
            else if (valtype.equals("Boolean"))
                val = new Boolean(dr.readString());
            else if (valtype.equals("String"))
                val = dr.readString();
            else if (valtype.equals("Int"))
                val = new Integer(dr.readInt());
            else if (valtype.equals("Storable"))
                val = dr.readStorable();
            else if (valtype.equals("UNKNOWN"))
                continue;

            fMap.put(key,val);
        }
    } */

    /**
     * Writes the attributes to a StorableInput.
     * FigureAttributes store the following types directly:
     * Color, Boolean, String, Int. Other attribute types
     * have to implement the Storable interface or they
     * have to be wrapped by an object that implements Storable.
     * @see Storable
     * @see #write
     */
   /*  public function write(dw:StorableOutput):void {
        dw.writeString("attributes");

        dw.writeInt(fMap.size());   // number of attributes
        var k:Enumeration= fMap.keys();
        while (k.hasMoreElements()) {
            var s:String= String(k.nextElement());
            dw.writeString(s);
            var v:Object= fMap.get(s);
            if (v instanceof String) {
                dw.writeString("String");
                dw.writeString(String(v));
            } else if (v instanceof Color) {
                dw.writeString("Color");
                dw.writeInt((Color(v)).getRed());
                dw.writeInt((Color(v)).getGreen());
                dw.writeInt((Color(v)).getBlue());
            } else if (v instanceof Boolean) {
                dw.writeString("Boolean");
                if ((Boolean(v)).booleanValue())
                    dw.writeString("TRUE");
                else
                    dw.writeString("FALSE");
            } else if (v instanceof Integer) {
                dw.writeString("Int");
                dw.writeInt((Integer(v)).intValue());
            } else if (v instanceof Storable) {
                dw.writeString("Storable");
                dw.writeStorable(Storable(v));
            } else {
                System.out.println(v);
                dw.writeString("UNKNOWN");
            }
        }
    } */
}
}
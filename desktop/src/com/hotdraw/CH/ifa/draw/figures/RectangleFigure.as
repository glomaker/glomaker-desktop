/*
 * @(#)RectangleFigure.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.figures {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.standard.*;
import com.hotdraw.CH.ifa.draw.util.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util._Vector;

import flash.display.Graphics;

import org.glomaker.hotdraw.controls.DeleteHandle;


/**
 * A rectangle figure.
 */
public class RectangleFigure extends AttributeFigure {

    private var fDisplayBox:_Rectangle;

    /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= 184722075881789163;
    private var rectangleFigureSerializedDataVersion:int= 1;

   public function RectangleFigure(origin:_Point= null, corner:_Point=null) {
        if (origin == null)origin=new _Point(0,0);
        if (corner == null)corner=new _Point(0,0);
        basicDisplayBox(origin,corner);
    }

    override public function basicDisplayBox(origin:_Point, corner:_Point):void {
        fDisplayBox = new _Rectangle(origin);
        fDisplayBox.add(corner);
        
        x =  fDisplayBox.x;
        y =  fDisplayBox.y;
        
        width = fDisplayBox.width;
        height = fDisplayBox.height;
        
    }

    override public function handles():_Vector {
       var handles:_Vector= new _Vector();
        BoxHandleKit.addHandles(this, handles);
        return handles;
 }

    override public function getDisplayBox():_Rectangle {
    	return new _Rectangle(
            fDisplayBox.x,
            fDisplayBox.y,
            fDisplayBox.width,
            fDisplayBox.height);
    }

    override public function basicMoveBy(x:int, y:int):void {
        fDisplayBox.translate(x,y);
        move(fDisplayBox.x,fDisplayBox.y);
      }

   
     /**
     * Draws this figure.
     */
     
    override public function draw(g:Graphics):void {
      g.lineStyle(1,0);
      g.beginFill(0xffff66);
      g.drawRect(0,0, width, height);
    }
    
    override public function clone():Object {
        return new RectangleFigure();
    }
    

}
}
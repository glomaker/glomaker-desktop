/*
 * @(#)AbstractHandle.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.cursor.MouseTheme;
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;

import flash.display.Graphics;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.managers.CursorManager;

/**
 * AbstractHandle provides defaulf implementation for the
 * Handle interface.
 *
 * @see Figure
 * @see Handle
 */
public class AbstractHandle extends UIComponent implements Handle {

    /**
     * The standard size of a handle.
     */
    public static const HANDLESIZE:int= 8;
    private var fOwner:Figure;

    /**
     * Initializes the owner of the figure.
     */
    public function AbstractHandle(owner:Figure) {
        fOwner = owner;
    }

     /**
     * Locates the handle on the figure. The handle is drawn
     * centered around the returned point.
     */
    public function locate():_Point {return null;}

    /**
     * @ deprecated As of version 4.1,
     * use invokeStart(x, y, drawingView)
     * Tracks the start of the interaction. The default implementation
     * does nothing.
     * @param x the x position where the interaction started
     * @param y the y position where the interaction started
     * 
     * OR
     * @ deprecated As of version 4.1,
     * use invokeStart(x, y, drawingView)
     * Tracks the start of the interaction. The default implementation
     * does nothing.
     * @param x the x position where the interaction started
     * @param y the y position where the interaction started
     * @param view the handles container
     * 
     * Forms:
     * (1) function invokeStart(x:int, y:int, drawing:Drawing):void 
     * (2) invokeStart(x:int, y:int, view:DrawingView):void
     * 
     * 
     */
    public function invokeStart(x:int, y:int, m:*):void { 
    
      if(m is DrawingView) {
    	var dv:DrawingView = m as DrawingView;
    	invokeStart(x, y, dv.drawing());
      } 
    }

  

    /**
     * @ deprecated As of version 4.1,
     * use invokeStep(x, y, anchorX, anchorY, drawingView)
     *
     * Tracks a step of the interaction.
     * @param dx x delta of this step
     * @param dy y delta of this step
     * 
     * OR
     * 
     * Tracks a step of the interaction.
     * @param x the current x position
     * @param y the current y position
     * @param anchorX the x position where the interaction started
     * @param anchorY the y position where the interaction started
     *
     * Forms:
     * (1)function invokeStep(dx:int, dy:int, drawing:Drawing):void
     * (2)function invokeStep(x:int, y:int, anchorX:int, anchorY:int, view:DrawingView):void
     * 
     */
     public function invokeStep(m:int, n:int, o:*, p:*=null, q:*=null):void {
      	var anchorX:int = o as int;
      	var anchorY:int = p as int;

      	if(q is DrawingView){
      		var view:DrawingView = q as DrawingView;
      		invokeStep(m-anchorX, n-anchorY, view.drawing());
      	}
      }
      

    /**
     * Tracks the end of the interaction.
     * @param x the current x position
     * @param y the current y position
     * @param anchorX the x position where the interaction started
     * @param anchorY the y position where the interaction started
     */
         
    public function invokeEnd(m:int, n:int, o:*, p:*=null, q:*=null):void {
    	
    	var anchorX:int = o as int;
      	var anchorY:int = p as int;

      	if(p is DrawingView){
      		var view:DrawingView = q as DrawingView;
      		invokeEnd(m-anchorX, n-anchorY, view.drawing());
      	}
    }
    

    /**
     * Gets the handle's owner.
     */
     public function ownerFigure():Figure {
        return fOwner;
    } 
    

    /**
     * Gets the display box of the handle.
     */
    public function displayBox():_Rectangle {
        var p:_Point= locate();
        return new _Rectangle(p.x - HANDLESIZE / 2,p.y - HANDLESIZE / 2,HANDLESIZE, HANDLESIZE);;
    }

    /**
     * Tests if a point is contained in the handle.
     */
    public function containsPoint(x:int, y:int):Boolean {
        return displayBox().contains(x, y);
    }

    /**
     * Draws this handle.
     */

    
    override protected function updateDisplayList(w:Number, h:Number):void { 
   
     super.updateDisplayList(w, h); 
       var fDisplayBox:_Rectangle =displayBox();
       
        // Update the coordinates and the size
        x =  fDisplayBox.x;
        y =  fDisplayBox.y;
        width = fDisplayBox.width;
        height = fDisplayBox.height;
        
      draw(graphics);   	
    }
    
     /**
     * Draws this handle.
     */
     
    public function draw(g:Graphics):void {
      g.clear();
      g.lineStyle(1,0);
      g.beginFill(0xffffff);
      g.drawEllipse(0,0, width, height);
   	  g.endFill();
      //g.beginFill(0xffff66);
      //g.drawRect(0,0, width, height);
    }
}
}
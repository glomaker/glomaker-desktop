/*
 * @(#)SelectionTool.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.cursor.MouseTheme;
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.java.awt.*;

import flash.events.MouseEvent;

import mx.managers.CursorManager;

/**
 * Tool to select and manipulate figures.
 * A selection tool is in one of three states, e.g., background
 * selection, figure selection, handle manipulation. The different
 * states are handled by different child tools.
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld032.htm>State</a></b><br>
 * SelectionTool is the StateContext and child is the State.
 * The SelectionTool delegates state specific
 * behavior to its current child tool.
 * <hr>
 */

public class SelectionTool extends AbstractTool {

    private var fChild:Tool= null;
    public var invoked:Boolean = false; // indicate when the handle child is in invoke state [help to handle mouse events]

    public function SelectionTool(view:DrawingView) {
        super(view);
    }

    /**
     * Handles mouse down events and starts the corresponding tracker.
     */
    override public function mouseDown(e:MouseEvent, x:int, y:int):void {
        // on Windows NT: AWT generates additional mouse down events
        // when the left button is down && right button is clicked.
        // To avoid dead locks we ignore such events
        if (fChild != null)
            return;
        
        var handle:Handle= view().findHandle(x,y);
        
        if (handle != null) {
            fChild = createHandleTracker(view(), handle);
            invoked = true;
        }
        else {
            var figure:Figure= drawing().findFigure(x,y);
            if (figure != null) {
                fChild = createDragTracker(view(), figure);
            }
            else {
                if (!e.shiftKey) {
                    view().clearSelection();
                }
                fChild = createAreaTracker(view());
            }
        }
        fChild.mouseDown(e, x, y);    
         
    }

    /**
     * Handles mouse drag events. The events are forwarded to the
     * current tracker.
     */
    override public function mouseDrag(e:MouseEvent, x:int, y:int):void {
        if (fChild != null) 
            fChild.mouseDrag(e, x, y);
    }

    /**
     * Handles mouse up events. The events are forwarded to the
     * current tracker.
     */
    override public function mouseUp(e:MouseEvent, x:int, y:int):void {
        if (fChild != null)
            fChild.mouseUp(e, x, y);
        fChild = null;
        invoked = false;
    }
    
    override public function mouseMove(e:MouseEvent, x:int, y:int):void {
    	var handle:Handle= view().findHandle(x,y);
   if(!invoked){
     if(handle != null)
      CursorManager.setCursor(MouseTheme.getHandleMouseCursor(handle),2,-MouseTheme.w/2,-MouseTheme.h/2);
      else 
       CursorManager.removeAllCursors();
     }
    }

    /**
     * Factory method to create a Handle tracker. It is used to track a handle.
     */
     
     protected function createHandleTracker(view:DrawingView, handle:Handle):Tool {
        return new HandleTracker(view, handle);
    } 

    /**
     * Factory method to create a Drag tracker. It is used to drag a figure.
     */
    protected function createDragTracker(view:DrawingView, f:Figure):Tool {
        return new DragTracker(view, f);
    }

    /**
     * Factory method to create an area tracker. It is used to select an
     * area.
     */
    protected function createAreaTracker(view:DrawingView):Tool {
        return new SelectAreaTracker(view);

    }
}
}
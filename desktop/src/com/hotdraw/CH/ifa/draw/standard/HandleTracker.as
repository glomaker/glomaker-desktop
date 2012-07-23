/*
 * @(#)HandleTracker.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.cursor.MouseTheme;
import com.hotdraw.CH.ifa.draw.framework.*;

import flash.events.MouseEvent;

import com.hotdraw.java.awt.*;

import mx.managers.CursorManager;

/**
 * HandleTracker implements interactions with the handles
 * of a Figure.
 *
 * @see SelectionTool
 */
public class HandleTracker extends AbstractTool {

    private var fAnchorHandle:Handle;

    public function HandleTracker(view:DrawingView, anchorHandle:Handle) {
        super(view);
        fAnchorHandle = anchorHandle;
    }

    override public function mouseDown(e:MouseEvent, x:int, y:int):void {
        super.mouseDown(e, x, y);
        CursorManager.setCursor(MouseTheme.getHandleMouseCursor(fAnchorHandle),2,-MouseTheme.w/2,-MouseTheme.h/2);
        fAnchorHandle.invokeStart(x, y, view());
    }

    override public function mouseDrag(e:MouseEvent, x:int, y:int):void {
        super.mouseDrag(e, x, y);
        fAnchorHandle.invokeStep(x, y, fAnchorX, fAnchorY, view());
    }

    override public function mouseUp(e:MouseEvent, x:int, y:int):void {
        super.mouseUp(e, x, y);
        CursorManager.removeAllCursors();
        fAnchorHandle.invokeEnd(x, y, fAnchorX, fAnchorY, view());
    }
    

}
}
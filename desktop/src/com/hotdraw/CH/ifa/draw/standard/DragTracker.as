/*
 * @(#)DragTracker.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;

import flash.events.MouseEvent;

import com.hotdraw.java.awt.*;
import com.hotdraw.java.util.*;

/**
 * DragTracker implements the dragging of the clicked
 * figure.
 *
 * @see SelectionTool
 */
public class DragTracker extends AbstractTool {

    private var fAnchorFigure:Figure;
    private var fLastX:int, fLastY:int;      // previous mouse position
    private var fMoved:Boolean= false;

    public function DragTracker(view:DrawingView, anchor:Figure) {
        super(view);
        fAnchorFigure = anchor;
    }

    override public function mouseDown(e:MouseEvent, x:int, y:int):void {
        super.mouseDown(e, x, y);
        fLastX = x;
        fLastY = y;

        if (e.shiftKey) {
           view().toggleSelection(fAnchorFigure);
           fAnchorFigure = null;
        } else if (!view().selection().contains(fAnchorFigure)) {
            view().clearSelection();
            view().addToSelection(fAnchorFigure);
        }
    }

    override public function mouseDrag(e:MouseEvent, x:int, y:int):void {
        super.mouseDrag(e, x, y);
        fMoved = (Math.abs(x - fAnchorX) > 4) || (Math.abs(y - fAnchorY) > 4);

        if (fMoved) {
            var figures:FigureEnumeration= view().selectionElements();
            while (figures.hasMoreElements())
                figures.nextFigure().moveBy(x - fLastX, y - fLastY);
        }
        fLastX = x;
        fLastY = y;
    }
}
}
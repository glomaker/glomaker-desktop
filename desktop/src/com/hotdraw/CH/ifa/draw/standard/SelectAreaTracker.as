/*
 * @(#)SelectAreaTracker.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.*;

import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * SelectAreaTracker implements a rubberband selection of an area.
 */
public class SelectAreaTracker extends AbstractTool {

    private var fSelectGroup:_Rectangle;

    public function SelectAreaTracker(view:DrawingView) {
        super(view);
    }

    override public function mouseDown(e:MouseEvent, x:int, y:int):void {
        // use event coordinates to supress any kind of
        // transformations like constraining points to a grid
        super.mouseDown(e, x,y);
        rubberBand(fAnchorX, fAnchorY, fAnchorX, fAnchorY);
    }

    override public function mouseDrag(e:MouseEvent, x:int, y:int):void {
        super.mouseDrag(e, x, y);
        rubberBand(fAnchorX, fAnchorY, x, y);
    }

    override public function mouseUp(e:MouseEvent, x:int, y:int):void {
        super.mouseUp(e, x, y);
        eraseRubberBand();
        selectGroup(e.shiftKey);
    }

    private function rubberBand(x1:int, y1:int, x2:int, y2:int):void {
        fSelectGroup = new _Rectangle(new _Point(x1, y1));
        fSelectGroup.add(new _Point(x2, y2));
        drawRect(fSelectGroup);
    }

    private function eraseRubberBand():void {
        view().getSelectAreaGraphics().clear();
    }


    private function drawRect(r:_Rectangle):void {
        var g:Graphics= view().getSelectAreaGraphics();
        g.clear();
        var t:Number = 0.4;
        g.lineStyle(1,0xddccbd);
        g.beginFill(0xc5cbf5,t);
        g.drawRect(r.x,r.y,r.width,r.height);
   	    g.endFill();
     }

    private function selectGroup(toggle:Boolean):void {
        var k:FigureEnumeration= drawing().figuresReverse();
        while (k.hasMoreElements()) {
            var figure:Figure= k.nextFigure();
            var r2:_Rectangle= figure.displayBox();
            if (fSelectGroup.contains(r2.x, r2.y) && fSelectGroup.contains(r2.x+r2.width, r2.y+r2.height)) {
                if (toggle)
                    view().toggleSelection(figure);
                else
                    view().addToSelection(figure);
            }
        }
    }
}
}
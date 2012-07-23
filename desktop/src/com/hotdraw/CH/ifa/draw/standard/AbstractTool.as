/*
 * @(#)AbstractTool.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;

import flash.events.MouseEvent;

import com.hotdraw.java.awt.*;

/**
 * Default implementation support for Tools.
 *
 * @see DrawingView
 * @see Tool
 */

public class AbstractTool implements Tool {

    protected var fView:DrawingView;

    /**
     * The position of the initial mouse down.
     */
    protected var fAnchorX:int, fAnchorY:int;

    /**
     * Constructs a tool for the given view.
     */
     
    public function AbstractTool(itsView:DrawingView) {
        fView = itsView;
    }

    /**
     * Activates the tool for the given view. This method is called
     * whenever the user switches to this tool. Use this method to
     * reinitialize a tool.
     */
    public function activate():void {
        fView.clearSelection();
    }

    /**
     * Deactivates the tool. This method is called whenever the user
     * switches to another tool. Use this method to do some clean-up
     * when the tool is switched. Subclassers should always call
     * super.deactivate.
     */
    public function deactivate():void {
        //fView.setCursor(Cursor.getDefaultCursor());
    }

    /**
     * Handles mouse down events in the drawing view.
     */
    public function mouseDown(e:MouseEvent, x:int, y:int):void {
        fAnchorX = x;
        fAnchorY = y;
    }

    /**
     * Handles mouse drag events in the drawing view.
     */
    public function mouseDrag(e:MouseEvent, x:int, y:int):void {
    }

    public function mouseStartDrag(e:MouseEvent, x:int, y:int):void {
    
     }
    public function mouseEndDrag(e:MouseEvent, x:int, y:int):void {
    	
    }

    /**
     * Handles mouse up in the drawing view.
     */
    public function mouseUp(e:MouseEvent, x:int, y:int):void {
    }
    
    /**
     * Handles mouse move 
     */
    public function mouseMove(evt:MouseEvent, x:int, y:int):void {
    	
    }

 
    /**
     * Handles key down events in the drawing view.
     */
/*     public function keyDown(evt:KeyEvent, key:int):void {
    } */
    




    /**
     * Gets the tool's drawing.
     */
    public function drawing():Drawing {
        return fView.drawing();
    }

    /**
     * Gets the tool's editor.
     */
    public function editor():DrawingEditor {
        return fView.editor();
    }

    /**
     * Gets the tool's view.
     */
    public function view():DrawingView {
        return fView;
    }
}
}
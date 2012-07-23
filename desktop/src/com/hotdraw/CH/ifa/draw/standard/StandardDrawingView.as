/*
 * @(#)StandardDrawingView.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom.Dimension;
import com.hotdraw.java.awt.geom._Point;
import com.hotdraw.java.awt.geom._Rectangle;
import com.hotdraw.java.util.*;
import com.hotdraw.mouse.MouseDrag;
import com.hotdraw.mouse.MouseDragListener;

import flash.display.Graphics;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import mx.containers.Canvas;
import mx.core.UIComponent;

/**
 * The standard implementation of DrawingView.
 * @see DrawingView
 * @see Painter
 * @see Tool
 */

public  class StandardDrawingView extends Canvas implements MouseDragListener, DrawingView /* KeyListener  */{
   /**
     * The DrawingEditor of the view.
     * @see #tool
     * @see #setStatus
     */
    private var fEditor:DrawingEditor = null;

    /**
     * The shown drawing.
     */
    private var fDrawing:Drawing = null;

    /**
     * the accumulated damaged area
     */
    private var fDamage:_Rectangle= null;

    /**
     * The list of currently selected figures.
     */
    private var fSelection:_Vector = null;

    /**
     * The shown selection handles.
     */
    private var fSelectionHandles:_Vector = null;

    /**
     * The preferred size of the view
     */
    private var fViewSize:Dimension = null;

    /**
     * The position of the last mouse click
     * inside the view.
     */
    private var fLastClick:_Point = null;

    /**
     * A vector of optional backgrounds. The vector maintains
     * a list a view painters that are drawn before the contents,
     * that is in the background.
     */
    private var fBackgrounds:_Vector= null;

    /**
     * A vector of optional foregrounds. The vector maintains
     * a list a view painters that are drawn after the contents,
     * that is in the foreground.
     */
    private var fForegrounds:_Vector= null;

    /**
     * Constructs the view.
     * dvCanvas is the parent Canvas
     */
    private var dvCanvasA:Canvas = null;
    private var handlesCanvas:Canvas = null;
    private var selectAreaCanvas:Canvas = null;
    
    /**
     * The grid used to constrain points for snap to
     * grid functionality.
     */
    private var fConstrainer:PointConstrainer;

        
    /*
     * Serialization support. In JavaDraw only the Drawing is serialized.
     * However, for beans support StandardDrawingView supports
     * serialization
     */
    private static const serialVersionUID:Number= -3878153366174603336;
    private var drawingViewSerializedDataVersion:int= 1;

    public function StandardDrawingView(editor:DrawingEditor, dvCanvas:Canvas) {

        fEditor = editor;
        dvCanvasA = dvCanvas;
        
        x=0;
        y=0;
        width=dvCanvas.width;
        height=dvCanvas.height;
        
        fViewSize = new Dimension(dvCanvas.width,dvCanvas.height);
        
        handlesCanvas = new Canvas();
        selectAreaCanvas = new Canvas();
                        
        fLastClick = new _Point(0, 0);
        fSelection = new _Vector();
        
        dvCanvas.addChild(this);			
        dvCanvas.addChild(handlesCanvas);			
        dvCanvas.addChild(selectAreaCanvas);  // < top layer			

        clipContent = false;
        handlesCanvas.clipContent = false;
        selectAreaCanvas.clipContent = false;
 
 
       verticalScrollPolicy = "off";
       horizontalScrollPolicy = "off";
       dvCanvas.verticalScrollPolicy = "off";
       dvCanvas.horizontalScrollPolicy = "off";
 
       MouseDrag.addMouseDragListener(dvCanvas,this);
         
    }
    
    public function registerEvents():void{
        
        dvCanvasA.addEventListener(MouseEvent.MOUSE_DOWN,mousePressed);    
        dvCanvasA.addEventListener(MouseEvent.MOUSE_UP,mouseReleased);    
        dvCanvasA.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
        
        stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed); 
   }

    public function unregisterEvents():void{
        
        dvCanvasA.removeEventListener(MouseEvent.MOUSE_DOWN,mousePressed);    
        dvCanvasA.removeEventListener(MouseEvent.MOUSE_UP,mouseReleased);    
        dvCanvasA.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
        
        stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyPressed); 
    }

    /**
     * Sets the view's editor.
     */
    public function setEditor(editor:DrawingEditor):void {
        fEditor = editor;
    }

    /**
     * Gets the current tool.
     */
    public function tool():Tool {
        return fEditor.tool();
    }

    /**
     * Gets the drawing.
     */
    public function drawing():Drawing {
        return fDrawing;
    }

    /**
     * Sets and installs another drawing in the view.
     */
    public function setDrawing(d:Drawing):void {
      
        clearSelection();

        if (fDrawing != null)
            fDrawing.removeDrawingChangeListener(this);

        fDrawing = d;
        
        if (fDrawing != null)
            fDrawing.addDrawingChangeListener(this);
            

    }

    /**
     * Gets the editor.
     */
    public function editor():DrawingEditor {
        return fEditor;
    }

    /**
     * Adds a figure to the drawing.
     * @return the added figure.
     */
    public function add(figure:Figure):Figure {
    	// Add the figure as a UIComponent to the Canvas
    	 addChild(figure as UIComponent);
    	// Add to the drawing.
        return drawing().add(figure);
    }

    /**
     * Removes a figure from the drawing.
     * @return the removed figure
     */
    public function remove(figure:Figure):Figure {
    	var fig:Figure = drawing().remove(figure);
    	removeChild(fig as UIComponent);
        return fig;
    }
    
   	/**
   	 * Remove all figures from the drawing. 
   	 */   
   	public function removeAllFigures():void
   	{
   		drawing().removeAll();
   		removeAllChildren();
   		
   	}
   	
   	
   	/**
   	 * Clear the drawing view from everything 
   	 */   
   	public function clear():void
   	{
   		clearHandles();
   		removeAllFigures();
   	}

    /**
     * Adds a vector of figures to the drawing.
     */
    public function addAll(figures:_Vector):void {
        var k:FigureEnumeration= new FigureEnumerator(figures);
        while (k.hasMoreElements())
            add(k.nextFigure());
    }

    /**
     * Gets the minimum dimension of the drawing.
     */
    public function getMinimumSize():Dimension {
        return fViewSize;
    }

    /**
     * Gets the preferred dimension of the drawing..
     */
    public function getPreferredSize():Dimension {
        return getMinimumSize();
    }

    /**
     * Gets the currently selected figures.
     * @return a vector with the selected figures. The vector
     * is a copy of the current selection.
     */
    public function selection():_Vector {
        // protect the vector with the current selection
        return fSelection.clone() as _Vector;
    }

    /**
     * Gets an enumeration over the currently selected figures.
     */
    public function selectionElements():FigureEnumeration {
        return new FigureEnumerator(fSelection);
    }

    /**
     * Gets the currently selected figures in Z order.
     * @see #selection
     * @return a vector with the selected figures. The vector
     * is a copy of the current selection.
     */
    public function selectionZOrdered():_Vector {
        var result:_Vector= new _Vector();
        var figures:FigureEnumeration= drawing().figures();

        while (figures.hasMoreElements()) {
            var f:Figure= figures.nextFigure();
            if (fSelection.contains(f)) {
                result.addElement(f);
            }
        }
        return result;
    }

    /**
     * Gets the number of selected figures.
     */
    public function selectionCount():int {
        return fSelection.size();
    }

    /**
     * Adds a figure to the current selection.
     */
    public function addToSelection(figure:Figure):void {
        if (!fSelection.contains(figure)) {
            fSelection.addElement(figure);
            clearHandles();
            fSelectionHandles = null;   
            figure.invalidate();
            selectionChanged();
        }
    }

    /**
     * Adds a vector of figures to the current selection.
     */
    public function addToSelectionAll(figures:_Vector):void {
        var k:FigureEnumeration= new FigureEnumerator(figures);
        while (k.hasMoreElements())
            addToSelection(k.nextFigure());
    }

    /**
     * Removes a figure from the selection.
     */
    public function removeFromSelection(figure:Figure):void {
        if (fSelection.contains(figure)) {
            fSelection.removeElement(figure);
            clearHandles();
            fSelectionHandles = null;
            figure.invalidate();
            selectionChanged();
        }
    }

    /**
     * If a figure isn't selected it is added to the selection.
     * Otherwise it is removed from the selection.
     */
    public function toggleSelection(figure:Figure):void {
        if (fSelection.contains(figure))
            removeFromSelection(figure);
        else
            addToSelection(figure);
    }

    /**
     * Clears the current selection.
     */
    public function clearSelection():void {
        var figure:Figure;

        var k:FigureEnumeration= selectionElements();
        if(!k.hasMoreElements())return;
        
        while (k.hasMoreElements())
            k.nextFigure().invalidate();
            
        fSelection = new _Vector();
        clearHandles();
        fSelectionHandles = null;
        selectionChanged();
    }

    /**
     * Gets an enumeration of the currently active handles.
     */
    private function selectionHandles():Enumeration {
    	             	
        if (fSelectionHandles == null) {
            fSelectionHandles = new _Vector();
            var k:FigureEnumeration= selectionElements();
            while (k.hasMoreElements()) {
                var figure:Figure= k.nextFigure();
                var kk:Enumeration= figure.handles().elements();
                while (kk.hasMoreElements()){
                	var h:Object = kk.nextElement();
                    fSelectionHandles.addElement(h);
                }
            }
        }
        return fSelectionHandles.elements();
    }
    
    /**
     * Clear handles
     */
    public function clearHandles():void {
           // Add the handles to the view!
         var kk:Enumeration= selectionHandles();
                while (kk.hasMoreElements()){
                	var h:Object = kk.nextElement();
                	if(handlesCanvas.contains((h as UIComponent))){
                	 handlesCanvas.removeChild((h as UIComponent)); 
                	}
         }
    }
    
    /**
     * Gets the current selection as a FigureSelection. A FigureSelection
     * can be cut, copied, pasted.
     */
    /*
    public function getFigureSelection():FigureSelection {
        return new FigureSelection(selectionZOrdered());
    }*/

    /**
     * Finds a handle at the given coordinates.
     * @return the hit handle, null if no handle is found.
     */
     public function findHandle(x:int, y:int):Handle {
       var handle:Handle;

        var k:Enumeration= selectionHandles();
        while (k.hasMoreElements()) {
            handle = Handle(k.nextElement());
            if (handle.containsPoint(x, y))
                return handle;
        }
        return null;
    }

    /**
     * Informs that the current selection changed.
     * By default this event is forwarded to the
     * drawing editor.
     */
    protected function selectionChanged():void {
        fEditor.selectionChanged(this);   
    }

    /**
     * Gets the position of the last click inside the view.
     */
    public function lastClick():_Point {
        return fLastClick;
    }

    /**
     * Sets the grid spacing that is used to constrain points.
     */
     public function setConstrainer(c:PointConstrainer):void {
        fConstrainer = c;
    }
 
    /**
     * Gets the current constrainer.
     */
     public function getConstrainer():PointConstrainer {
        return fConstrainer;
    }
 
    /**
     * Constrains a point to the current grid.
     */
    protected function constrainPoint(p:_Point):_Point {
        // constrin to view size
        
  /*       var size:Dimension= getSize();
 
        p.x = Geom.range(1, size.width, p.x);
        p.y = Geom.range(1, size.height, p.y);

        if (fConstrainer != null )
            return fConstrainer.constrainPoint(p);
 */            
        return p; 
}

    /**
     * Handles mouse down events. The event is delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */
     public function mousePressed(e:MouseEvent):void {
     	 var p:Point = this.globalToLocal(new Point(e.stageX, e.stageY));
         var cp:_Point= constrainPoint(new _Point(p.x, p.y));         
         fLastClick = new _Point(p.x, p.y);
         tool().mouseDown(e, cp.x, cp.y);   
         checkDamage(); 

    } 

    /**
     * Handles mouse drag events. The event is delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */

	public function mouseDrag(e:MouseEvent,x:int,y:int):void{
		var p:Point = this.globalToLocal(new Point(e.stageX, e.stageY));
        var cp:_Point= constrainPoint(new _Point(p.x, p.y));
        tool().mouseDrag(e, cp.x, cp.y);
        checkDamage();
	}
	
	public function mouseStartDrag(e: MouseEvent,x:int,y:int):void{
	}
	
	public function mouseEndDrag(e:MouseEvent,x:int,y:int):void{
		var p:Point = this.globalToLocal(new Point(e.stageX, e.stageY));
		var cp:_Point= constrainPoint(new _Point(p.x, p.y));
        tool().mouseUp(e, cp.x, cp.y);
        checkDamage();
	}
	

    /**
     * Handles mouse out and over events. The event is delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */
     
     /**
     * Handles mouse move
     */
    public function mouseMove(e:MouseEvent):void {
      var p:Point = this.globalToLocal(new Point(e.stageX, e.stageY));
      tool().mouseMove(e, p.x, p.y);
    }

    /**
     * Handles mouse up events. The event is delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */
     public function mouseReleased(e:MouseEvent):void {
        checkDamage();
    } 

    /**
     * Handles key down events. Cursor keys are handled
     * by the view the other key events are delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */
     public function keyPressed(e:KeyboardEvent):void {
     	
        var code:int= e.keyCode;
        if ((code == Keyboard.BACKSPACE) || (code == Keyboard.DELETE)) {
            var cmd:Command= new DeleteCommand("Delete", this);
            cmd.execute();
        } else if (code == Keyboard.DOWN || code == Keyboard.UP ||
            code == Keyboard.RIGHT || code == Keyboard.LEFT) {
            handleCursorKey(code);
        } else {
            //tool().keyDown(e, code);
        }
        
        checkDamage(); 

    } 

    /**
     * Handles cursor keys by moving all the selected figures
     * one grid point in the cursor direction.
     */
    protected function handleCursorKey(key:*):void {
    	
        var dx:int= 0, dy:int = 0;
        var stepX:int= 1, stepY:int = 1;
        // should consider Null Object.
        
        if (fConstrainer != null) {
            stepX = fConstrainer.getStepX();
            stepY = fConstrainer.getStepY();
        }

        switch (key) {
        case Keyboard.DOWN:
            dy = stepY;
            break;
        case Keyboard.UP:
            dy = -stepY;
            break;
        case Keyboard.RIGHT:
            dx = stepX;
            break;
        case Keyboard.LEFT:
            dx = -stepX;
            break;
        }
        moveSelection(dx, dy); 
    }


    private function moveSelection(dx:int, dy:int):void {
        var figures:FigureEnumeration= selectionElements();
        while (figures.hasMoreElements())
            figures.nextFigure().moveBy(dx, dy);
        checkDamage();
    }

    /**
     * Refreshes the drawing if there is some accumulated damage
     */
    public function checkDamage():void {
         
         // Add the handles to the view!
         var kk:Enumeration= selectionHandles();
                while (kk.hasMoreElements()){
                	var h:UIComponent = kk.nextElement() as UIComponent;
                	//if(!handlesCanvas.contains((h as UIComponent))){
                	
                	// added by Nils (24.02.09)
                	// avoids problems where Flex throws a RangeError if the child has only just been added
                	if(h.parent)
                		h.parent.removeChild(h);
                	
               		handlesCanvas.addChild(h); 
                	//} 
         }
    }

    public function drawingRequestUpdate(e:DrawingChangeEvent):void {
    }

    /**
     * Updates the drawing view.
     */
    public function getGraphics():Graphics {
        return graphics;
    }
    
     /**
     * Gets a graphic to draw the handles into
     */
    public function getHandlesGraphics():Graphics {
    	return handlesCanvas.graphics;
    }

    /**
     * Gets a graphic to draw the select rectangle into
     */
    public function getSelectAreaGraphics():Graphics {
    	return selectAreaCanvas.graphics;
    }

    public function getSize():Dimension {
    	return new Dimension(width,height);
    }
    
 

}
}
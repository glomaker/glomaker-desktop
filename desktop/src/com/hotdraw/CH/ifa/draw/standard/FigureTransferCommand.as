/*
 * @(#)FigureTransferCommand.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;
import com.hotdraw.java.util._Vector;

import com.hotdraw.java.util.*;

/**
 * Common base clase for commands that transfer figures
 * between a drawing and the clipboard.
 */
public class FigureTransferCommand extends Command {

    protected var fView:DrawingView;

   /**
    * Constructs a drawing command.
    * @param name the command name
    * @param view the target view
    */
    public function FigureTransferCommand(name:String, view:DrawingView) {
        super(name);
        fView = view;
    }

   /**
    * Deletes the selection from the drawing.
    */
    protected function deleteSelection():void {
       fView.drawing().removeAll(fView.selection());
       fView.clearSelection();
    }

   /**
    * Copies the selection to the clipboard.
    */
    protected function copySelection():void {
        //var selection:FigureSelection= fView.getFigureSelection();
        //Clipboard.getClipboard().setContents(selection);
    }

   /**
    * Inserts a vector of figures and translates them by the
    * given offset.
    */
    protected function insertFigures(figures:_Vector, dx:int, dy:int):void {
/*         var e:FigureEnumeration= new FigureEnumerator(figures);
        while (e.hasMoreElements()) {
            var figure:Figure= e.nextFigure();
            figure.moveBy(dx, dy);
            figure = fView.add(figure);
            fView.addToSelection(figure);
        } */
    }

}
}
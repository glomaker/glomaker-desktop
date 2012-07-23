/*
 * @(#)DeleteCommand.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {
	
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.java.util.*;

import mx.controls.Alert;
import mx.events.CloseEvent;

/**
 * Command to delete the selection.
 */
public class DeleteCommand extends FigureTransferCommand {

   /**
    * Constructs a delete command.
    * @param name the command name
    * @param view the target view
    */
    public function DeleteCommand(name:String, view:DrawingView) {
        super(name, view);
    }

    override public function execute():void {
    	Alert.yesLabel = "Yes";
    	Alert.noLabel = "No";
    	Alert.show("Do you want to delete all selected Components?", "Warning!",Alert.YES | Alert.NO,null,alertListener, null, Alert.YES);

    }

    override public function isExecutable():Boolean {
        return fView.selectionCount() > 0;
    }
    
      private function alertListener(eventObj:CloseEvent):void             {
                // Check to see if the OK button was pressed.
                if (eventObj.detail==Alert.YES) {
                    deleteSelection();
        			fView.checkDamage(); 
                }
            }

}
}
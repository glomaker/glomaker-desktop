/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.export
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.view.popups.export.ExportResultPopupMediator;
	import org.glomaker.app.view.popups.export.ExportSuccessPopup;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Shows the 'export has completed' popup. 
	 * @author Nils
	 */
	public class ShowExportCompleteMessageCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// show the popup to notify the user that the export has succeeded
			var popup:ExportSuccessPopup = new ExportSuccessPopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new ExportResultPopupMediator(popup));
		}
		
	}
}
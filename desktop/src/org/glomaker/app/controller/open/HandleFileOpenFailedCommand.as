/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.open
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.view.popups.open.OpenFailedPopup;
	import org.glomaker.app.view.popups.open.OpenFailedPopupMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Handles 'failure' to open a file by showing a popup. 
	 * @author Nils
	 */
	public class HandleFileOpenFailedCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// show the popup
			var popup:OpenFailedPopup = new OpenFailedPopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);

			popup.errorMessage = notification.getBody() as String;
			
			// create + register a mediator for it
			facade.registerMediator(new OpenFailedPopupMediator(popup));			
		}
		
	}
}
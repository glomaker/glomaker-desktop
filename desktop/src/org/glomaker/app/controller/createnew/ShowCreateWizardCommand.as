/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.createnew
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.view.popups.create.NewProjectPopup;
	import org.glomaker.app.view.popups.create.NewProjectPopupMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Shows the 'create new project' wizard popup. 
	 * @author Nils
	 */
	public class ShowCreateWizardCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// no document is current open anymore
			// so we hide the actual application
			sendNotification(Notifications.APP_HIDE_APPLICATION);
			
			// show the wizard as a popup
			var popup:NewProjectPopup = new NewProjectPopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			var mediator:NewProjectPopupMediator = new NewProjectPopupMediator(popup); 
			facade.registerMediator(mediator);
		}		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.startup
{
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.view.popups.start.StartChoicesPopup;
	import org.glomaker.app.view.popups.start.StartChoicesPopupMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Shows the startup wizard screen popup. 
	 * @author Nils
	 */
	public class ShowStartupWizardCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// if a file is pending to be opened, we open it now
			// @see HandleAppInvokeCommand
			if( configProxy.pendingStartupFileURL )
			{
				var f:File = new File( configProxy.pendingStartupFileURL );
				configProxy.pendingStartupFileURL = null;
				
				if(f.exists)
				{
					// close all popups
					sendNotification(Notifications.APP_CLOSE_ALL_POPUPS);
				
					// we can launch the actual file
					sendNotification(Notifications.OPENFILE_SELECTED, f);
					
					// done
					return;
				}
			}
			
			// no document is current open
			// so we hide the actual application
			sendNotification(Notifications.APP_HIDE_APPLICATION);
			
			// show the wizard as a popup
			var popup:StartChoicesPopup = new StartChoicesPopup();
			//popup.visible = false;
			PopUpManager.addPopUp( popup, Application.application as DisplayObject,true)// [musbah 20-8-2009, prevent it moving slightly vertically everytime, TOM], PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new StartChoicesPopupMediator(popup));
		}
						
	}
}
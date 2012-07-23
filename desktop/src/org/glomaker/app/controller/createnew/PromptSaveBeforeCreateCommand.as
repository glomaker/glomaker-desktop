/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.createnew
{
	import mx.controls.Alert;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.AlertMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	


	/**
	 * Prompts the user to save data before creating a new document.
	 * You should call the 'SetCreatePendingCommand' before executing this one.
	 * @see org.glomaker.app.controller.open.FileOpenMacroCommand 
	 * @author Nils
	 */
	public class PromptSaveBeforeCreateCommand extends BaseCommand
	{

		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			// we only need to save data if a project currently exists
			// that might not be the case if you are coming from the startup wizard
			if(!project.currentPattern)
			{
				// no pattern defined - hence no project currently exists
				// we skip the entire Save Alert dialog box
				sendNotification(Notifications.CREATE_NEW_PROJECT);
				return;
			}
			
			// temporary label changes
			// might affect other areas of code - so these should always be set again
			Alert.yesLabel = "Save";
			Alert.noLabel = "Continue";
			Alert.cancelLabel = "Cancel";
			Alert.buttonWidth = configProxy.alertButtonWidth;
			
			// create new mediator to look after the alert - and use it to show the alert
			var med:AlertMediator = new AlertMediator();

			// register it (it will remove itself once the user has selected an option)
			facade.registerMediator(med);
			
			// notifications to be sent when user clicks various buttons
			med.yesNotification = Notifications.CONTROLS_SAVE;
			med.noNotification = Notifications.CREATE_NEW_PROJECT;
			med.cancelNotification = Notifications.APP_SET_STATE_IDLE;

			// show the alert
			med.show( "You will lose unsaved changes to your project.\nDo you wish to save before continuing?", "Save Changes?", Alert.YES | Alert.NO | Alert.CANCEL);
		}
		
	}
}
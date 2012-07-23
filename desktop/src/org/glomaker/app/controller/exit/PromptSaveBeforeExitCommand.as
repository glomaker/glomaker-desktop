/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.exit
{
	import mx.controls.Alert;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.AlertMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	


	/**
	 * Prompts the user to save data before exiting the application. 
	 * @author Nils
	 */
	public class PromptSaveBeforeExitCommand extends BaseCommand
	{

		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			// no need for this if no file is currently open
			if( project.currentPattern == null)
			{
				sendNotification( Notifications.APP_FORCE_EXIT );
				return;
			}
			
			// temporary label change
			// might affect other areas of code - so these should always be set again
			Alert.yesLabel = "Save";
			Alert.noLabel = "Close";
			Alert.cancelLabel = "Cancel";
			Alert.buttonWidth = configProxy.alertButtonWidth;
			
			// create new mediator to look after the alert - and use it to show the alert
			var med:AlertMediator = new AlertMediator();

			// register it (it will remove itself once the user has selected an option)
			facade.registerMediator(med);
			
			// notifications to be sent when user clicks various buttons
			med.yesNotification = Notifications.CONTROLS_SAVE;
			med.noNotification = Notifications.APP_FORCE_EXIT;
			med.cancelNotification = Notifications.APP_SET_STATE_IDLE;

			// show the alert
			med.show( "You will loose unsaved changes to your project.\nDo you wish to save before continuing?", "Save Changes?", Alert.YES | Alert.NO | Alert.CANCEL);
		}
		
	}
}
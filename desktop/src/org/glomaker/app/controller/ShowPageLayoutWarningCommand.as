/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import mx.controls.Alert;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.AlertMediator;
	import org.glomaker.common.vo.PageVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Shows a 'warning: all data will be lost if you change page layout' alert box. 
	 * @author Nils
	 */
	public class ShowPageLayoutWarningCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// notification's body should contain the new page layout
			if(!(notification.getBody() is PageVO))
				throw new Error("Notification body must contain PageVO instance.");			
			
			// temporary label change
			// might affect other areas of code - so these should always be set again
			Alert.okLabel = "OK";
			Alert.cancelLabel = "Cancel";
			Alert.buttonWidth = configProxy.alertButtonWidth;
			
			// create new mediator to look after the alert - and use it to show the alert
			var med:AlertMediator = new AlertMediator();

			// register it (it will remove itself once the user has selected an option)
			facade.registerMediator(med);
			
			// notifications to be sent when user clicks various buttons
			med.okNotification = Notifications.PAGE_LAYOUT_CONFIRM;
			med.notificationBody = notification.getBody();

			// show the alert
			med.show( "Are you sure you want to choose a new page template?\nAll content (on this page only) will be deleted.", "Warning", Alert.OK | Alert.CANCEL);
		}
		
	}
}
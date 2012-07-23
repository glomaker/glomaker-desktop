/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.open
{
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.StateProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Handles the situation where user cancelled a 'file open' action. 
	 * @author Nils
	 */
	public class HandleFileOpenCancelledCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// return to idle state
			stateProxy.currentState = StateProxy.STATE_IDLE;
			
			// if no data is currently available, we have to show the startup wizard again
			if(  !project.currentPattern )
				sendNotification( Notifications.APP_SHOW_STARTUP_WIZARD );
			else
				sendNotification( Notifications.APP_SHOW_APPLICATION );
		}
		
	}
}
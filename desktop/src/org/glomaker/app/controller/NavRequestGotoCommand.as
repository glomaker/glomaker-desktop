/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.core.Notifications;
	import org.puremvc.as3.multicore.interfaces.INotification;

	
	/**
	 * Handles navigation request to a specific page.
	 * Will only allow navigation to pages between 0 and the last page.
	 * Fails silently if an out-of-bounds index is supplied. 
	 * @author Nils
	 */	
	public class NavRequestGotoCommand extends BaseCommand
	{
		override public function execute(notification:INotification):void
		{
			// notification's body should contain integer page identifier
			if(!(notification.getBody() is int))
			{
				throw new Error("Notification body must contain target page index as int value.");
			}
			
			//
			var newIndex:int = notification.getBody() as int;

			// Update project settings
			project.settings.loadedPageIndex = newIndex;
			
			// Change index
			sendNotification(Notifications.LIST_SELECT_ITEM, newIndex);

		}
	}
}
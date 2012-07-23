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
	import org.glomaker.app.model.SelectionProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Handles navigation request to next page. 
	 * Fails silently if no previous page exists.
	 * @author Nils
	 */	
	public class NavRequestPreviousCommand extends BaseCommand
	{
		override public function execute(notification:INotification):void
		{
			// calculate index of next page
			var newIndex:int = selections.pageIndex - 1;
			
			// Update project settings
			project.settings.loadedPageIndex = newIndex;

			// Change index
			sendNotification(Notifications.LIST_SELECT_ITEM, newIndex);

		}
	}
}
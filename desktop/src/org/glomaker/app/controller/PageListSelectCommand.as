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
	 * Carries out a new selection in the current page.
	**/
	public class PageListSelectCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// body should contain new index
			var index:int = notification.getBody() as int;
			
			if(!isNaN(index))
			{
				selections.pageIndex = index;
			}	
			
		}
		
	}
}
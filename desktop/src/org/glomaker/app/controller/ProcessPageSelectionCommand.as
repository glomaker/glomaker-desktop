/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Handles a change in the currently selected page. 
	 * @author Nils
	 */	
	public class ProcessPageSelectionCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// body contains newly selected page
			var pageIndex:int = notification.getBody() as int;
			
			// get page definition for this page
			// this call might return a RangeError, so we wrap it in a try...catch
			var page:PageInstanceVO;
			
			try{

				page = project.getPageAt(pageIndex);

			}catch(e:Error){
				// no page found - ignore
				trace("Error: no page found (ProcessPageSelectionCommand)");
			}
			
			// if a valid page was found
			if(page)
			{
				// if a page was previously selected, save the current page now
	 			if(selections.previousPageIndex > -1)
				{
					sendNotification(Notifications.APP_SAVE_DATA, null, "ProcessPageSelectionCommand");
				} 

				// draw the new page
				sendNotification(Notifications.APP_PAGE_DRAW, page);
			}
				
		}
		
	}
}
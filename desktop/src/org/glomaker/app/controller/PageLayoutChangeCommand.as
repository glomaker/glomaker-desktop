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
	import org.glomaker.common.vo.PageVO;
	import org.puremvc.as3.multicore.interfaces.INotification;

	public class PageLayoutChangeCommand extends BaseCommand
	{
		override public function execute(notification:INotification):void
		{	
		
			// get selected page index
			var selectedPageIndex:int = selections.pageIndex;
			
			// if no page is selected, exit
			if(selectedPageIndex < 0)
			{
				return;
			}

			// get the new page selected by the user
			var pageLibraryRef:PageVO = notification.getBody() as PageVO;
			
			
			if(!pageLibraryRef){
				throw new Error("Body does not contain PageVO instance!");
			}
			
			// add the new page as a replacement for the old one
			var page:PageInstanceVO = project.getPageAt(selectedPageIndex);
			page.setPageLayout(pageLibraryRef,project.settings.stageWidth,project.settings.stageHeight);
			
			// redraw current page
			sendNotification(Notifications.APP_PAGE_DRAW, page);
		}
		
	}
}
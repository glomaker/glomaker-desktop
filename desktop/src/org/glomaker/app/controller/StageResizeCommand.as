/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import mx.managers.CursorManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.utils.Size;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Handles Stage Resize Notification
	 * Resize all components based on the new stage size
	 * @author Musbah
	 */	
	 
	public class StageResizeCommand extends BaseCommand
	{
		public function StageResizeCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			// make sure page content has been saved
			sendNotification(Notifications.APP_SAVE_DATA, null, "StageResizeCommand");
			
			// body contains the new size
			var size:Size =  notification.getBody() as Size;
			
			if(!size)
				throw new Error("Notification's body should contain a utils.Size instance.");
			
            // Return if the size has not changed!
			if(project.settings.stageWidth == size.width && project.settings.stageHeight == size.height)
			  return;
			
			// this operation can take quite a long time, so show the busy cursor while it's processing
			CursorManager.setBusyCursor();
			  
			// allow the proxy to resize the stage
			project.setStageDimensions(size.width,size.height);
			
			// no need for the busy cursor anymore
			CursorManager.removeBusyCursor();
			
			// Redraw the current page
			
			var page:PageInstanceVO;
			
			try{

			 page = project.getPageAt(selections.pageIndex);

			}catch(e:Error){
				// no page found - ignore
				// trace("Error: no page found (StageResizeCommand)");
			}
			
			// if a valid page was found
			if(page){
				// draw the new page
				sendNotification(Notifications.APP_PAGE_DRAW, page);
			}
		}
		
	}
}
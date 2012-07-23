/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Moves a component on the current page to the top of the layer order. 
	 * @author Nils
	 */
	public class MoveComponentAboveCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			var fig:ComponentProxyFigure = notification.getBody() as ComponentProxyFigure;
			
			if(!fig)
				throw new Error("Notification's body must contain a ComponentProxyFigure.");


			// get the ComponentInstanceVO associated with this figure
			// it is that instance which is stored in the proxy
			var component:ComponentInstanceVO = fig.getComponentInstance();
				
			if(!component)
				return;

			// save the page, to make sure the component's properties are up to date
			sendNotification( Notifications.APP_SAVE_DATA );
			
			// send it to the bottom of the pile
			// the components are drawn in the order that they come out of the array, so [0] -> bottom-most layer
			var page:PageInstanceVO = project.getPageAt( selections.pageIndex );
			
			var index:int = page.components.indexOf( component );
			
			if(index > -1)
			{
				page.components.splice(index, 1);
				page.components.push(component);
				
				// redraw page
				sendNotification( Notifications.APP_PAGE_DRAW, page );
			}
		}
		
	}
}
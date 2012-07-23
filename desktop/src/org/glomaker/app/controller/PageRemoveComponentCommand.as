/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Removes a component from the current page. 
	 * @author Nils
	 */	
	public class PageRemoveComponentCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// body should contain the ComponentInstanceVO
			var instance:ComponentInstanceVO = notification.getBody() as ComponentInstanceVO;
			
			if(!instance)
				throw new Error("Notification's body should contain an ComponentInstanceVO instance.");
				
			// get reference to current page
			var page:PageInstanceVO = project.getPageAt(selections.pageIndex);
				
			// remove it from the current page
			if(page)
			{
				page.removeComponent(instance);
			}			
		}		
	}
}
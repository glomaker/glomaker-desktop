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
	 * Process event of a component having been added to the page. 
	 * @author Nils
	 */
	public class PageAddComponentCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// body should contain component instance
			var comp:ComponentInstanceVO = notification.getBody() as ComponentInstanceVO;
			
			// the component's rawPropXML property will be null if it's a brand-new, just added component
			// in that case, we need to add it to the page information stored in the model
			// other components that are added already exist on the page
			if(comp.rawPropXML == null)
			{
				// get reference to current page
				var page:PageInstanceVO = project.getPageAt(selections.pageIndex);
				
				if(page)
				{
					page.addComponentInstance(comp);
				}
			}
		}
		
	}
}
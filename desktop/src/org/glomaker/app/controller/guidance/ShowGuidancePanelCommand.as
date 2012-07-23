/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.guidance
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.view.popups.guidance.GuidancePopup;
	import org.glomaker.app.view.popups.guidance.GuidancePopupMediator;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Shows the guidance panel for a particular page. 
	 * @author Nils
	 */
	public class ShowGuidancePanelCommand extends BaseCommand
	{

		/**
		 *   
		 * @param notification Body should contain PageInstanceVO
		 */		
		override public function execute(notification:INotification):void
		{
			var page:PageInstanceVO = notification.getBody() as PageInstanceVO;
			
			if(!page)
				throw new Error("Notification's body must contains PageInstanceVO instance.");
				
			// if a guidance mediator is already registered, then a guidance popup is already visible
			// and we don't need to create/show it again
			if(facade.hasMediator(GuidancePopupMediator.NAME))
				return;
				
			// show the popup
			var popup:GuidancePopup = new GuidancePopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, false, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new GuidancePopupMediator(popup as GuidancePopup));			
		}
		
	}
}
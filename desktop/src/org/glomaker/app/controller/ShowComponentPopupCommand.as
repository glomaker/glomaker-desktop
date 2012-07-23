/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.glomaker.app.view.popups.page.ComponentSelector;
	import org.glomaker.app.view.popups.page.ComponentSelectorMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Shows the component selection popup. 
	 * @author Nils
	 */	
	public class ShowComponentPopupCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// show the popup
			var popup:ComponentSelector = new ComponentSelector();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new ComponentSelectorMediator(popup as ComponentSelector));
		}
		
		
	}
}
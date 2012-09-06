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
	
	import org.glomaker.app.view.popups.journey.JourneySettingsPopup;
	import org.glomaker.app.view.popups.journey.JourneySettingsPopupMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Shows the journey settings popup. 
	 * 
	 * @author Haykel
	 */	
	public class ShowJourneySettingsPopup extends BaseCommand
	{
		override public function execute(notification:INotification):void
		{
			// show the popup
			var popup:JourneySettingsPopup = new JourneySettingsPopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp(popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new JourneySettingsPopupMediator(popup as JourneySettingsPopup));
		}
	}
}
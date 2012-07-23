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
	
	import org.glomaker.app.view.popups.stage.StagePropertiesPopup;
	import org.glomaker.app.view.popups.stage.StagePropertiesPopupMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Shows the stage property popup. 
	 * @author Nils
	 */	
	public class ShowStagePropertyPopup extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			// show the popup
			var popup:StagePropertiesPopup = new StagePropertiesPopup();
			var parent:DisplayObject = Application.application as DisplayObject;
			
			PopUpManager.addPopUp( popup, parent, true, PopUpManagerChildList.POPUP);
			PopUpManager.centerPopUp(popup);
			
			// create + register a mediator for it
			facade.registerMediator(new StagePropertiesPopupMediator(popup as StagePropertiesPopup));
		}
		
		
	}
}
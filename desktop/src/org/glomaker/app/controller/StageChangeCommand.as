/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.glomaker.common.data.StageVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Saves new stage selected by the user. 
	 * @author Nils
	 */	
	public class StageChangeCommand extends BaseCommand
	{

		/**
		 * @param notification Body should contain new StageVO.
		 */		
		override public function execute(notification:INotification):void
		{
			// body should contain StageVO
			var stageVO:StageVO = notification.getBody() as StageVO;
			
			if(!stageVO)
				throw new Error("Notification's body should contain StageVO instance.");

			// store it
			project.settings.selectedStage = stageVO;
		}
		
	}
}
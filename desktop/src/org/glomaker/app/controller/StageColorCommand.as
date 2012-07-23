/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Handles Stage Color change Notification
	 * @author Musbah
	 */	
	 
	public class StageColorCommand extends BaseCommand
	{
		public function StageColorCommand()
		{
			super();
		}
		
			override public function execute(notification:INotification):void{
				var color:uint =  notification.getBody() as uint;
	 		    project.settings.stageColour = color;
			}

		
	}
}
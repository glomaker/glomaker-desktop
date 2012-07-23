/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.guidance
{
	import org.glomaker.app.controller.BaseCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Turns the guidance feature off. 
	 * @author Nils
	 */
	public class GuidanceOffCommand extends BaseCommand
	{
		
		override public function execute(notification:INotification):void
		{
			guidanceProxy.isGuidanceOn = false;
		}
		
	}
}
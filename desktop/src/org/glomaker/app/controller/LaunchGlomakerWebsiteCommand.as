/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Launches the glomaker.org website in a new browser window. 
	 * @author Nils
	 */
	public class LaunchGlomakerWebsiteCommand extends BaseCommand
	{
		override public function execute(notification:INotification):void
		{
			navigateToURL(new URLRequest(configProxy.glomakerWebsiteURL));
		}
	}
}
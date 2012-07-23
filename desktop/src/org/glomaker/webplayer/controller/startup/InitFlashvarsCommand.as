/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller.startup
{
	import org.glomaker.webplayer.GloWebPlayer;
	import org.glomaker.webplayer.controller.BaseCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Initialises config settings from flashvars passed in from HTML.
	 * @author Nils
	 */
	public class InitFlashvarsCommand extends BaseCommand
	{

		/**
		 * @inheritDoc
		 * @param notification Body should contain the File object of the file to open.
		 */
		override public function execute(notification:INotification):void
		{
			
			var appRef:GloWebPlayer = notification.getBody() as GloWebPlayer;
			
			// test correct body
			if(!appRef)
				throw new Error("Notification body must be the main application instance.");
			
			
			// get flashvars object
			var flashvars:Object = appRef.loaderInfo.parameters;
			
			// project path - stored in 'project' flashvars
			if(flashvars.project && flashvars.project != "")
			{
				configProxy.projectPath = configProxy.basePath + flashvars.project;
			}
			
		}
		
		
		
	}
}
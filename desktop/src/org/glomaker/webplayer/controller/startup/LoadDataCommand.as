/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller.startup
{
	import org.glomaker.webplayer.controller.BaseCommand;
	import org.glomaker.webplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Opens a new GLO project file. 
	 * @author Nils
	 */
	public class LoadDataCommand extends BaseCommand
	{

		/**
		 * @inheritDoc
		 * @param notification Body should contain the File object of the file to open.
		 */
		override public function execute(notification:INotification):void
		{
			playerDataProxy.url = configProxy.projectPath;
		}
		
		
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.export
{
	import flash.filesystem.File;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.FileSelectorMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * The command pops up a file selector dialogue to select where to export the project to.
	 */
	public class SelectExportLocationCommand extends BaseCommand
	{
		
		/**
		 * Directory selector will be shown and execution will continue on EXPORT_DIR_SELECTED notification.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{	
			var openDir:File;
			
			// revert to previously used path if possible
			if(configProxy.lastExportDirectory)
				openDir = new File(configProxy.lastExportDirectory);
			else
				openDir = File.documentsDirectory;
			
			// open the browse file selector
			try{

				openDir.browseForDirectory("Choose Packaging Directory (WARNING: Existing content in this directory will be overwritten!)");
				
				// create a mediator to look after the popup
				var dsm:FileSelectorMediator = new FileSelectorMediator(openDir);
				
				dsm.selectNotification = Notifications.EXPORT_DIR_SELECTED;
				dsm.cancelNotification = Notifications.APP_SET_STATE_IDLE;

				facade.registerMediator(dsm);
			}
			catch(evt:Error)
			{
				sendNotification( Notifications.EXPORT_FAILED, "SelectExportLocationCommand::Error - failed to show file selector - " + evt.message);
			}
			
		} 
		
	}
}
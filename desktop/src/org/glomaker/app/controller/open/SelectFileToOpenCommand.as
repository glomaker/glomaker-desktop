/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.open
{
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.FileSelectorMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * The command pops up a file selector dialogue to select a new file to open.
	 */
	public class SelectFileToOpenCommand extends BaseCommand
	{
		
		/**
		 * Directory selector will be shown and execution will continue on OPENFILE_SELECTED notification.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{	
			var openDir:File;
			
			// revert to previously used path if possible
			if(configProxy.lastOpenDirectoryURL)
				openDir = new File(configProxy.lastOpenDirectoryURL);
			else
				openDir = File.documentsDirectory;
			
			// open the browse file selector
			try{
				
				var filter:Array = [new FileFilter("GLO Projects (*.glo)", "*.glo")];
				
				//
				openDir.browseForOpen("Open...", filter);
				
				// create a mediator to look after the popup
				var dsm:FileSelectorMediator = new FileSelectorMediator(openDir);
				
				dsm.selectNotification = Notifications.OPENFILE_SELECTED;
				dsm.cancelNotification = Notifications.OPENFILE_CANCELLED;

				facade.registerMediator(dsm);
			}
			catch(evt:Error)
			{
				trace("SelectFileForOpenCommand::Error - failed to show file selector - ", evt.message);
			}
			
		} 
		
	}
}
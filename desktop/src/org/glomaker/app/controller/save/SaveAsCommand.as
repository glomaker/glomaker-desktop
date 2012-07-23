/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.save
{
	import flash.filesystem.File;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.FileSelectorMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Handles 'Save As...' logic.
	 * The command pops up a file selector dialogue and sets appropriate properties so further processing will be routed to the SaveCommand.
	 */
	public class SaveAsCommand extends BaseCommand
	{
		
		/**
		 * Directory selector will be shown and execution will continue on SAVEFILE_SELECT notification.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{	
			
			// get default save file name / location
			var saveFile:File = getDefaultSaveFile();
			
			try{
				
				saveFile.browseForSave("Save As...");
				
				// create a mediator to look after the popup
				var dsm:FileSelectorMediator = new FileSelectorMediator(saveFile);
				
				dsm.selectNotification = Notifications.SAVEFILE_SELECT;
				dsm.cancelNotification = Notifications.SAVEFILE_CANCEL;

				facade.registerMediator(dsm);
			}
			catch(evt:Error)
			{
				trace("SaveAsCommand::Error - failed to create save dialog - ", evt.message);
			}
			
		} 
		
		/**
		 * Returns a default filename to store a previously unsaved project under.
		 * This filename should be presented to the user in a fileselector.
		 * @return 
		 */		
		protected function getDefaultSaveFile():File
		{
			var filename:String = configProxy.defaultProjectFilename;
			var extension:String = "." + configProxy.projectFileExtension;
			var uniqueCounter:uint = 0;
			
			// try to revert to most recently used 'Save As...' location
			var baseDir:File;
			
			if(configProxy.lastSaveAsDirectoryURL)
				baseDir = new File(configProxy.lastSaveAsDirectoryURL);
			else
				baseDir = File.documentsDirectory;
			
			// resolve to actual document
			var file:File = baseDir.resolvePath(filename + extension);
			
			// if this file exists, keep adding numbers to the end to create a unique filename
			// eg. untitled1.glo, untitled2.glo, untitled3.glo...
			while(file.exists)
			{
				uniqueCounter++;
				file = baseDir.resolvePath(filename + uniqueCounter + extension);
			}
			
			// found a unique file
			return file;
		}

	}
}
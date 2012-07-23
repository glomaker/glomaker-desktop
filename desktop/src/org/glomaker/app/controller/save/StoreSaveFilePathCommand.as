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
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Updates the current project's file path.
	 * Also checks that the correct extension is set.
	 * @author Nils
	 */	
	public class StoreSaveFilePathCommand extends BaseCommand
	{
		/**
		 * Expects a File object in the Notification's body, pointing to the save path.
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			var file:File = notification.getBody() as File;
			
			if(!file)
				throw new Error("File instance expected as notification body.");
			
			// check that the extension is 'glo'
			// if it isn't, we simply add it to the end of the existing filename
			// NB: there is a danger here that existing file will be overwritten silently.
			if(file.extension != configProxy.projectFileExtension)
			{
				file.nativePath += "." + configProxy.projectFileExtension;
			}
			
			// remember this as the most recently used save path (stores the directory)
			configProxy.lastSaveAsDirectoryURL = file.parent.url;
			
			// update settings
			project.setFilename(file.nativePath);
		}
		
	}
}
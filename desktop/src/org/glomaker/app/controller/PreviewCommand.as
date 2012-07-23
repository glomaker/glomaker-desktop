/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.services.AIRFileUtils;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Opens the html file from the project folder. 
	 * @author USER
	 */
	public class PreviewCommand extends BaseCommand
	{
		/**
		 * Execute the command.
		 * 
		 * If the notification's body is a String or File instance, the information will be used to set the save path.
		 * If no save path is set, a file browser will be shown first.
		 * If a save path has been set, the project will be saved and then previewed.
		 * 
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{
			// if the notification contains a string or file body, we update the save path
			// @todo check whether directory exists
			if(notification.getBody() is String)
			{
				project.settings.savePathURL = notification.getBody() as String;
			}else if(notification.getBody() is File){
				project.settings.savePathURL = (notification.getBody() as File).url;
			}
			
			// if a save-path hasn't been defined, we need to pop up a selector
			// otherwise, we can now save the file
			if(project.settings.savePathURL)
			{
				
				var helper:AIRFileUtils = new AIRFileUtils();
				helper.writeToDir(project.settings.savePathURL, project.getProjectXML());
				
				// now do the preview
				var htmlFile:String = project.settings.savePathURL + "/GLO_Player_v2.html";
				var url:URLRequest = new URLRequest(htmlFile);
				navigateToURL(url);
				
			}else{
				
				// The save path has not been set. The user can now decide where to save.
				var projectDirectory:File = File.desktopDirectory;
				
				try{
					
					projectDirectory.browseForDirectory("Select Directory");
					
					// create a mediator to look after the popup
					//facade.registerMediator(new DirectorySelectMediator(projectDirectory, Notifications.PREVIEWDIR_SELECT, Notifications.PREVIEWDIR_CANCEL));
			
				}
				catch(evt:Error)
				{
					trace("PreviewCommand::Error - failed to create save dialog - ", evt.message);
				}
				
			}
			
		}
		
	}
}
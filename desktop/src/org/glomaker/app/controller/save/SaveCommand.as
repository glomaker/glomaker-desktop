/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.save
{
	import org.glomaker.app.core.Notifications;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * If the project was previously saved, it saves it again using the same filename.
	 * If the project wasn't saved, a file selection dialogue is popped up.
	 */
	public class SaveCommand extends AbstractSaveCommand
	{
		
		/**
		 * Attempts to save the current project.		
		 * If no save path is set, directory selector will be shown and execution will continue on SAVEFILE_SELECT notification.
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{	
			// if a save-path hasn't been defined, we need to pop up a selector
			// otherwise, we can save the file
			if(project.settings.savePathURL)
			{
				saveProject(project.settings.savePathURL, createProjectXML());
				
				// if the project is waiting to exit, do so now
				if(stateProxy.isExitPending)
				{
					sendNotification(Notifications.APP_FORCE_EXIT);
					
				}else if(stateProxy.isOpenPending){
					
					sendNotification(Notifications.OPENFILE_SHOWSELECTOR);
					
				}else if(stateProxy.isCreatePending){
					
					sendNotification(Notifications.CREATE_NEW_PROJECT);
					
				}else if(stateProxy.isExportPending){
					
					sendNotification(Notifications.EXPORT_SHOWSELECTOR);
				}
				
			}else{

				// revert to default 'save as' functionality
				sendNotification(Notifications.CONTROLS_SAVEAS, notification.getBody(), notification.getType());

			}
		}

	}
}
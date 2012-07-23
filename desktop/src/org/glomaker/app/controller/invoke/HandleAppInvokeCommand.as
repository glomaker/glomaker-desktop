/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.invoke
{
	import flash.display.DisplayObject;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	
	import mx.core.Application;
	import mx.core.IChildList;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.StartupProgressProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Handles an AIR application invoke event.
	 * These events occur when the user double-clicks on a GLO file or selects 'Open file with GLOMaker'. 
	 * @author Nils
	 */
	public class HandleAppInvokeCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			// body should contain invoke event
			var invokeEvent:InvokeEvent = notification.getBody() as InvokeEvent;
			
			if(!invokeEvent)
				throw new Error("Notification's body must contain InvokeEvent instance.");
				
			// if no arguments were received as part of the invoke event, we can simply ignore it
			// we are only interested in this event if a GLO file needs to be loaded as a result
			if(!invokeEvent.arguments || invokeEvent.arguments.length == 0)
				return;
			
			// file to launch
			var f:File = new File(invokeEvent.arguments[0]);
			
			if(!f.exists)
			{
				trace("File passed as invoke argument doesn't exist.");
				return;
			}
			
			// different behaviour if the application is still starting up
			var startupProxy:StartupProgressProxy = facade.retrieveProxy(StartupProgressProxy.NAME) as StartupProgressProxy;
			
			if(startupProxy && !startupProxy.isStartupComplete)
			{
				// startup is still in progress
				// we save the pending file in the config proxy
				configProxy.pendingStartupFileURL = f.url;
				
			}else{
				
				// startup has finished
				// close all popups
				sendNotification(Notifications.APP_CLOSE_ALL_POPUPS);
				
				// we can launch the actual file
				sendNotification(Notifications.OPENFILE_SELECTED, f);
			}
		}
		
		
	}
}
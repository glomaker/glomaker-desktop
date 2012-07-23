/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.exit
{

	import flash.desktop.NativeApplication;
	
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.model.StateProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Immediately exits the AIR application, without saving data. 
	 * @author Nils
	 */	
	public class ExitNoSaveCommand extends BaseCommand
	{
		
		/**
		 * @inheritDoc 
		 * @param notification
		 */
		override public function execute(notification:INotification):void
		{
			// reset state - no operations are pending anymore
			stateProxy.currentState = StateProxy.STATE_IDLE;
			
			// quit
			NativeApplication.nativeApplication.exit();
		}
		
	}
}
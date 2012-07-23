/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.state
{
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.model.StateProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Changes current state to flag that a 'project export' operation is pending.
	 * Call before running pre-file-opening processes. 
	 * @author Nils
	 */	
	public class SetExportPendingCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			stateProxy.currentState = StateProxy.STATE_OPEN_PENDING;
		}
		
	}
}
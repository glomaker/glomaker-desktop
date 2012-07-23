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
	 * Returns the application to the idle state.
	 * @author Nils
	 */	
	public class SetIdleStateCommand extends BaseCommand
	{
		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			stateProxy.currentState = StateProxy.STATE_IDLE;
		}
		
		
	}
}
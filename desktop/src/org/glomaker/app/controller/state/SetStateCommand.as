/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.state
{
	import org.glomaker.app.controller.BaseCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Sets the current application state.
	 * Specify the new state in the notification's body.
	 * Values should be taken from the static constants defined by the StateProxy class. 
	 * @author Nils
	 */
	public class SetStateCommand extends BaseCommand
	{

		/**
		 * @inheritDoc  
		 * @param notification Body should contain new state.
		 */		
		override public function execute(notification:INotification):void
		{
			// notification body contains the new state.
			stateProxy.currentState = notification.getBody() as uint;
		}
		
	}
}
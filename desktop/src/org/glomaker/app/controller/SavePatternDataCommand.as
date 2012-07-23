/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	
	/**
	 * Saves PatternMaker data in the ProjectSettingsProxy.
  	 * @author Nils
	 */	
	public class SavePatternDataCommand extends BaseCommand
	{

		/**
		 * @inheritDoc 
		 * @param notification Body should contain Array of IPatternNode instances
		 */
		override public function execute(notification:INotification):void
		{
			// retrieve data from body
			var data:Array = notification.getBody() as Array;
			
			if(!data)
				throw new Error("Notification's body should contain array of IPatternNode instances.");
			
			// store it
			project.setPatternNodes(data);
		}
	}
}
/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.createnew
{
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.StateProxy;
	import org.glomaker.common.vo.PatternVO;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Creates a new project (removes existing pages, resets to patternmaker). 
	 * @author Nils
	 */
	public class InitialiseNewProjectCommand extends BaseCommand
	{

		/**
		 * @inheritDoc 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			// update state - no create-new operation is pending anymore
			stateProxy.currentState = StateProxy.STATE_IDLE;

			// new pattern is passed in the notification's body
			var selectedPattern:PatternVO = notification.getBody() as PatternVO;
			
			if(!selectedPattern)
				throw new Error("Notification's body should contain the PatternVO to use for the new project.");

			// remove existing pages
			project.removeAllPages();
			
			// reset pattern nodes to default
			project.setPatternNodes(project.currentPattern.defaultNodes);
			
			// not saved anymore
			project.setFilename(null);
			
			// NB: current pattern, size, stage and background colour are kept intact
			
			// switch on the application again (this is hidden in ShowCreateWizardCommand)
			sendNotification(Notifications.APP_SHOW_APPLICATION);
			
			// switch to pattern maker
			sendNotification(Notifications.APP_REQUEST_SHOW_PATTERNMAKER);
			
			// force pattern update (necessary if we were already on the PatternMaker tab)
			sendNotification(Notifications.APP_REFRESH_DISPLAY);
		} 
		
	}
}
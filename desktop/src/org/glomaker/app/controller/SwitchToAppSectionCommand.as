/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller
{
	import mx.controls.Alert;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.core.mediator.AlertMediator;
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	/**
	 * Reacts to requests that the application should switch to a different section (patternmaker, designer, player).
	 * Carries out a number of checks and blocks/honours the request.
	 * If the request is honoured, a APP_SAVE_DATA' notification will be sent before making the switch. 
	 * @author Nils
	 */
	public class SwitchToAppSectionCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			
			var nextSection:int;
						
			switch(notification.getName())
			{
				case Notifications.APP_REQUEST_SHOW_PATTERNMAKER:
					nextSection = ApplicationStateProxy.SECTION_PATTERNMAKER;
					break;
					
				case Notifications.APP_REQUEST_SHOW_EDITOR:
					nextSection = ApplicationStateProxy.SECTION_EDITOR;
					break;
					
				case Notifications.APP_REQUEST_SHOW_PLAYER:
					nextSection = ApplicationStateProxy.SECTION_PLAYER;
					break;
			}
			
			
			// if there is no change, we don't need to do anything else
			// this is very important since it also prevents the APP_SAVE_DATA call from overwritting existing patternmaker data when loading/creating new projects
			var currentSection:int = appStateProxy.selectedSection;
			
			if(nextSection == currentSection)
				return;

			// make sure current section saves data before switching
			sendNotification( Notifications.APP_SAVE_DATA );

			// prevent user switching away from PatternMaker if there is no data available
			if(currentSection == ApplicationStateProxy.SECTION_PATTERNMAKER && project.currentPatternNodes.length == 0)
			{
				showPatternMakerWarning();
				return; 
			}
			
			// assign
			appStateProxy.selectedSection = nextSection;
		}
		
		
		/**
		 * Shows the message that you must create a Pattern before switching to the Designer. 
		 */
		protected function showPatternMakerWarning():void
		{
			// temporary label change
			// might affect other areas of code - so these should always be set again
			Alert.okLabel = "OK";
			Alert.buttonWidth = configProxy.alertButtonWidth;
			
			// create new mediator to look after the alert - and use it to show the alert
			var med:AlertMediator = new AlertMediator();

			// register it (it will remove itself once the user has selected an option)
			facade.registerMediator(med);
			
			// show the alert
			med.show( "You must create a Pedagogical Pattern before moving on.", "No Pattern Created", Alert.OK);
		}
		
	}
}